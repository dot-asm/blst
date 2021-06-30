#!/usr/bin/env python
#
# This script utilizes python-enabled cuda-gdb on your $PATH to collect
# per-instruction execution trace for first invocation of named function
# [and its descendants]. It also annotates instructions that reference
# memory with actual effective addresses...
#
#                                           @dot-asm

from __future__ import print_function       # cuda-gdb runs python2.7

import os
import sys
import re
import subprocess

debug_flag = False
#debug_flag = True

##############################################################################
# detect if already in gdb context, and if not, run gdb

try:
    gdb             # gdb module is pre-loaded in gdb context
except NameError:
    argc = len(sys.argv)
    if argc < 3 or not os.access(sys.argv[1], os.X_OK):
        print("Usage: {0:s} executable function [output]".format(sys.argv[0]))
        sys.exit(-1)

    # pass arguments through environment
    os.environ["TRACE_FUNCTION"] = sys.argv[2]
    if argc > 3:
        os.environ["TRACE_OUTFILE"] = sys.argv[3]

    try:
        os.execlpe("cuda-gdb", "cuda-gdb", "--batch",
                                           "--command=" + sys.argv[0],
                                           sys.argv[1],
                   os.environ)
    except OSError as e:
        if e.errno == 2:
            print("no 'cuda-gdb' on $PATH")
        sys.exit(e.errno)
    sys.exit(-1)

##############################################################################
# this part is executed in gdb context and that's where it all happens...

class Extractor:
    def __init__(self):
        pass
    def printHeader(self, function):
        raise NotImplementedError("Subclasses must override printHeader")
    def isBranch(self, insns, frame):
        # subclass is held responsible for self.branchpattern
        return self.branchpattern.match(insns[0]["asm"])
    def isFunctionCall(self, b):
        raise NotImplementedError("Subclasses must override isFunctionCall")
    def isFunctionReturn(self, b):
        raise NotImplementedError("Subclasses must override isFunctionReturn")
    def getEA(self, insn, frame):
        raise NotImplementedError("Subclasses must override getEA")
    def fixup(self, mnemonic, frame=None):
        return mnemonic

class NVIDIA(Extractor):
    branchpattern = re.compile(r'^((?:@!?P[0-9]+\s+)?BRA|CALL|RET)\b')
    # e.g. [R20], [R20+0x40], [R21:R20], ...
    eapattern = re.compile(r'\[(?:(R[0-9]+):)?(R[0-9]+)(\s*[\+\-]\s*(?:0x)?[0-9a-fA-F]+)?\]')
    # address: value
    gdb_x = re.compile(r'0x[0-9a-fA-F]+\s*<?.*>?\s*:\s+(0x[0-9a-fA-F]+)')

    def printHeader(self, function):
        print(function + ":")
        return

    def isFunctionCall(self, b):
        return b.group(1).startswith("CALL")

    def isFunctionReturn(self, b):
        return b.group(1) == "RET"

    def getEA(self, mnemonic, frame):
        ea = self.eapattern.search(mnemonic)
        if ea is None:
            return
        addr = 0
        if ea.group(1):
            v = "%s" % frame.read_register(ea.group(1))
            addr = int(v, 0) & 0xffffffff
            addr <<= 32
        v = "%s" % frame.read_register(ea.group(2))
        addr |= int(v, 0) & 0xffffffff
        base = ea.group(2)
        offset = ea.group(3)
        debug("Effective address: Group 1: %s" % base)
        debug("Effective address: Group 2: %s" % offset)
        debug("Effective address: Base: 0x%x" % addr)
        if offset:
            debug("Effective address: Offset: 0x%x" % int(offset, 0))
            addr += int(offset, 0)
        #if mnemonic.startswith("LD."):
        #    return {'addr': addr, 'load': True}
        #else:
        return {'addr': addr}

    def fixup(self, mnemonic, frame=None):
        debug("mnemonic = %s" % mnemonic)

        mnemonic = re.sub(r'\.reuse', r'', mnemonic)

        #### evaluate predicate
        m = re.match(r'@(!)?(P[0-9])\s+(.*)', mnemonic)
        if m:
            p = "%s" % frame.read_register(m.group(2))
            if int(p) or m.group(1):
                mnemonic = m.group(3)
            else:
                mnemonic = "#" + mnemonic

        #### resolve constants from .nv.constant3 segment
        m = re.match(r'(.*),\s*c\[0x3\]\[(0x[0-9a-f]+)\](,.*)', mnemonic)
        if m:
            i = int(m.group(2), 0)
            value = gdb.execute("x/1xw (@global int *)0x{0:x}"
                                .format(nv_constant3 + i), to_string=True)
            value = self.gdb_x.match(value).group(1)
            mnemonic = m.expand(r'\1, %s\3' % value)

        #### register pairs in load and stores
        if re.match(r'^(?:ST|LD)', mnemonic):
            m = re.match(r'^((?:ST|LD)[^\s]*\.64.*)(?<!\[)R([0-9]+)(.*)',
                         mnemonic)
            if m:
                i = int(m.group(2))
                mnemonic = m.expand(r'\1R%i:R%i\3' % (i+1, i))

            if wordsize == 32:
                return mnemonic

            m = re.match(r'^((?:ST|LD)(?!L).+)(?:\[R([0-9]+))(.*)',
                         mnemonic)
            if m:
                i = int(m.group(2))
                mnemonic = m.expand(r'\1[R%i:R%i\3' % (i+1, i))

            return mnemonic

        #### register pairs in IMAD
        elif re.match(r'^IMAD', mnemonic):
            m = re.match(r'^(?:IMAD(?!\.X)[^\s]*)(.*)RZ,\s*RZ,\s*(.*)',
                         mnemonic)
            if m:
                return m.expand(r'MOV\1\2')

            m = re.match(r'^(?:IMAD)(.*),\s*RZ\s*$', mnemonic)
            if m:
                mnemonic = m.expand(r'IMUL\1')

            m = re.match(r'^((?:IMAD|IMUL)\.WIDE[^\s]*[\s]+)R([0-9]+)(?:,\s*(P[0-9]))?(.*)',
                         mnemonic)
            if m:
                i = int(m.group(2))
                if m.group(3):
                    mnemonic = m.expand(r'\1\3:R%i:R%i\4' % (i+1, i))
                else:
                    mnemonic = m.expand(r'\1R%i:R%i\4' % (i+1, i))

            m = re.match(r'^(IMAD\.(?:WIDE|HI).+)R([0-9]+)(?:,\s*(P[0-9]))?\s*$',
                         mnemonic)
            if m:
                i = int(m.group(2))
                if m.group(3):
                    mnemonic = m.expand(r'\1R%i:R%i:\3' % (i+1, i))
                else:
                    mnemonic = m.expand(r'\1R%i:R%i' % (i+1, i))

            return mnemonic

        #### simplify IADD3
        elif re.match(r'^IADD', mnemonic):
            m = re.match(r'^IADD3(.*),\s*RZ(?:(,\s*P[0-9]),\s*\!PT)?\s*$',
                         mnemonic)
            if m:
                if m.lastindex == 1:
                    mnemonic = m.expand(r'IADD\1')
                else:
                    mnemonic = m.expand(r'IADD\1\2')

            m = re.match(r'^(IADD[^\s]*\s+)(R[0-9]+)(?:,\s*(P[0-9]))?([^P]*)(?:,\s*(P[0-9]))?\s*$',
                         mnemonic)
            if m:
                if m.group(3):
                    mnemonic = m.expand(r'\1\3:\2\4')
                else:
                    mnemonic = m.expand(r'\1\2\4')
                if m.group(5):
                    mnemonic += m.expand(r':\5')

            return mnemonic

        ### simplify LOP3.LUT
        elif re.match(r'^LOP3\.LUT', mnemonic):
            m = re.match(r'^LOP3\.LUT(.*)(,\s*RZ,\s*0xc0,\s*\!PT)\s*$',
                         mnemonic)
            if m:
                mnemonic = m.expand(r'AND\1')
                return mnemonic

            m = re.match(r'^LOP3\.LUT(.*)(?:,\s*RZ)(,\s*R[0-9]+)(,\s*RZ,\s*0x33,\s*\!PT)\s*$',
                         mnemonic)
            if m:
                mnemonic = m.expand(r'NOT\1\2')
                return mnemonic

            return mnemonic

        return mnemonic

# figure out if platform is 32- or 64-bit and instantiate extractor,
# all based on 'info target'...

target = gdb.execute("info target", to_string=True)
platform = re.search(r'file type (\w+)-([\w\-]+)', target)
elf = platform.group(1)
mach = platform.group(2)

if re.search(r'32$', elf):
    wordsize = 32
else:
    wordsize = 64

extr = NVIDIA()

def debug(msg):
    if debug_flag:
        print("DEBUG: {}".format(msg))

def trace():
    frame = gdb.newest_frame()
    arch = frame.architecture()

    while(frame.is_valid()):
        insns = arch.disassemble(frame.pc())
        mnemonic = extr.fixup(insns[0]["asm"], frame)
        b = extr.isBranch(insns, frame)
        if b:                               # skip over flow control
            gdb.execute("stepi", to_string=True)
            print("\t#{0:59s}#! PC = 0x{1:x}"
                  .format(mnemonic, insns[0]["addr"]))
            if extr.isFunctionCall(b):      # calls are handled recursively
                debug("Call")
                trace()
            elif extr.isFunctionReturn(b):
                debug("Return")
                return
            elif not frame.is_valid():      # inter-procedure branches
                debug("Invalid")
                frame = gdb.newest_frame()
                arch = frame.architecture()
            else:
                debug("Unhandled case")
        else:
            ea = extr.getEA(mnemonic, frame)
            if ea:
                print("\t{0:60s}#! EA = L0x{1:x}; PC = 0x{2:x}"
                      .format(mnemonic, ea["addr"], insns[0]["addr"]))
            else:
                print("\t{0:60s}#! PC = 0x{1:x}"
                      .format(mnemonic, insns[0]["addr"]))
            gdb.execute("stepi", to_string=True)

        if not frame.is_valid():            # inter-procedure branches?
            debug("Unexpected invalid frame!")
            frame = gdb.newest_frame()
            arch = frame.architecture()

    gdb.execute("stepi", to_string=True)    # step over retq
    return

# "main"
if "TRACE_OUTFILE" in os.environ:
    sys.stdout = open(os.environ["TRACE_OUTFILE"], "w")

function = os.environ["TRACE_FUNCTION"]

gdb.execute("set cuda break_on_launch application", to_string=True)
gdb.execute("run", to_string=True)

# collect symbols from cuda modules and locate .nv.constant3
elfs = []
for bfd in gdb.execute("maintenance info bfds", to_string=True).split('\n'):
    # print bfd
    elf = re.search(r'(/tmp/cuda-dbg/.*/elf\.[^\s]*)', bfd)
    if elf:
        elfs.append(elf.group(1))

symbols = subprocess.check_output(["objdump", "-t"] + elfs)
nv_constant3 = 0
for symbol in symbols.decode('utf8').split('\n'):
    debug(symbol)
    sym = re.search(r'(^[0-9a-fA-F]+).*\.nv\.constant3', symbol)
    if sym:
        addr = int(sym.group(1), 16)
        if addr != 0 and (nv_constant3 == 0 or addr < nv_constant3):
            nv_constant3 = addr

debug(".nv.constant3 = %s" % hex(nv_constant3))

# quirk: even though gdb.Breakpoint is documented to have pending attribute
# it didn't work for me :-(
s = gdb.execute("break *" + function, to_string=True)
if re.search("not defined", s):             # symbol was not found
    print(s.split("\n")[0], file=sys.stderr)
    sys.exit(-1)

gdb.execute("continue", to_string=True)

debug("After run")

extr.printHeader(function)
trace()

gdb.execute("delete breakpoints", to_string=True)
