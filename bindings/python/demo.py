#!/usr/bin/env python3

import os
import sys
import subprocess
import re

def newer(*files) :
    assert len(files) > 1
    rh = files[-1]
    if not os.path.exists(rh) :
        return True
    for lh in files[:-1] :
        if os.stat(lh).st_ctime > os.stat(rh).st_ctime :
            return True
    return False

here = re.split(r'/(?=[^/]*$)', sys.argv[0])
if len(here) > 1:
    os.chdir(here[0])

if not os.path.exists("libblst.a") :
    print("building libblst.a...")
    subprocess.call(["../../build.sh"]) == 0 or sys.exit(1)

if newer("../blst.swg", "../blst.h", "../blst.hpp", "blst_wrap.cpp") :
    print("swig-ing...")
    subprocess.call(["swig", "-c++", "-python", "-O",
                     "-o", "blst_wrap.cpp", "-outdir", ".",
                     "../blst.swg"]) == 0 or sys.exit(1)

if newer("blst_wrap.cpp", "libblst.a", "_blst.so") :
    print("compiling _blst.so...")
    maj_min = "{}.{}".format(sys.version_info.major, sys.version_info.minor)
    subprocess.call(["c++", "-shared", "-o", "_blst.so", "-fPIC", #"-std=c++17",
                     "-I/usr/include/python" + maj_min, "-I..", "-O", "-Wall",
                     "blst_wrap.cpp", "libblst.a", "-Wl,-Bsymbolic"]) == 0 \
    or sys.exit(1)

print("testing...")
########################################################################
import blst

msg = b"assertion"		# this what we're signing
DST = b"MY-DST"			# domain separation tag

SK = blst.SecretKey()
SK.keygen(b"passw@rd")		# secret key

########################################################################
# generate public key and signature

pk = blst.P1(SK)
pk_for_wire = pk.serialize()

sig = blst.P2()			#    vvvvvvvvvvv optional augmentation
sig_for_wire = sig.hash_to(msg, DST, pk_for_wire) \
                  .sign_with(SK) \
                  .serialize()

########################################################################
# at this point 'pk_for_wire', 'sig_for_wire' and 'msg' are
# "sent over network," so now on "receiver" side

sig = blst.P2_Affine(sig_for_wire)
pk  = blst.P1_Affine(pk_for_wire)
if pk.in_group() :		# vet the public key
    ctx = blst.Pairing(True, DST)
    ctx.aggregate(pk, sig, msg, pk_for_wire)
    ctx.commit()
    print(ctx.finalverify())
else :
    print("disaster")

########################################################################
# generate public key and signature

pk = blst.P2(SK)
pk_for_wire = pk.serialize()

sig = blst.P1()			#    vvvvvvvvvvv optional augmentation
sig_for_wire = sig.hash_to(msg, DST, pk_for_wire) \
                  .sign_with(SK) \
                  .serialize()

########################################################################
# at this point 'pk_for_wire', 'sig_for_wire' and 'msg' are
# "sent over network," so now on "receiver" side

sig = blst.P1_Affine(sig_for_wire)
pk  = blst.P2_Affine(pk_for_wire)
if pk.in_group() :		# vet the public key
    ctx = blst.Pairing(True, DST)
    ctx.aggregate(pk, sig, msg, pk_for_wire)
    ctx.commit()
    print(ctx.finalverify())
else :
    print("disaster")

########################################################################
# from https://github.com/supranational/blst/issues/5

pk_for_wire = bytes.fromhex("ab10fc693d038b73d67279127501a05f0072cbb7147c68650ef6ac4e0a413e5cabd1f35c8711e1f7d9d885bbc3b8eddc")
sig_for_wire = bytes.fromhex("a44158c08c8c584477770feec2afa24d5a0b0bab2800414cb9efbb37c40339b6318c9349dad8de27ae644376d71232580ff5102c7a8579a6d2627c6e40b0ced737a60c66c7ebd377c04bf5ac957bf05bc8b6b09fbd7bdd2a7fa1090b5a0760bb")
msg = bytes.fromhex("0000000000000000000000000000000000000000000000000000000000000000")
DST = bytes.fromhex("424c535f5349475f424c53313233383147325f584d443a5348412d3235365f535357555f524f5f504f505f")

sig = blst.P2_Affine(sig_for_wire)
pk  = blst.P1_Affine(pk_for_wire)
if pk.in_group() :	# vet the public key
    print(sig.core_verify(pk, True, msg, DST) == blst.BLST_SUCCESS)
else :
    print("disaster")
