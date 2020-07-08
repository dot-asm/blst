#!/usr/bin/env python3

import os
import sys
import subprocess
import re

here = re.split(r'/(?=[^/]*$)', sys.argv[0])
if len(here) > 1:
    os.chdir(here[0])

if not os.path.exists("libblst.a") :
    print("building libbst.a...")
    subprocess.call(["../../build.sh"]) == 0 or sys.exit(1)

def newer(lh, rh) :
    if os.path.exists(rh) :
        return os.stat(lh).st_ctime > os.stat(rh).st_ctime
    else :
        return True

if newer("../blst.swg", "blst_wrap.cpp") :
    print("swig-ing...")
    subprocess.call(["swig", "-c++", "-python", "-O",
                     "-o", "blst_wrap.cpp", "-outdir", ".",
                     "../blst.swg"]) == 0 or sys.exit(1)

if newer("blst_wrap.cpp", "_blst.so") or newer("libblst.a", "_blst.so") :
    print("compiling _blst.so...")
    pyver = "python{}.{}".format(sys.version_info.major, sys.version_info.minor)
    subprocess.call(["c++", "-shared", "-o", "_blst.so", "-fPIC",
                     "-I/usr/include/" + pyver, "-I..", "-O", "-Wall",
                     "blst_wrap.cpp", "libblst.a", "-Wl,-Bsymbolic"]) == 0 or \
    sys.exit(1)

print("testing...")
########################################################################
import blst

msg = b"assertion"		# this what we're signing
DST = b"MY-DST"			# domain separation tag
SK = blst.keygen(b"passw@rd")	# secret key

########################################################################
# generate public key and signature

pk_for_wire = blst.p1_serialize(blst.sk_to_pk_in_g1(SK))
				#vvvvvvvvvvv optional augmentation
hash = blst.hash_to_g2(msg, DST, pk_for_wire)
sig_for_wire = blst.p2_serialize(blst.sign_pk_in_g1(hash, SK))

########################################################################
# at this point 'pk_for_wire', 'sig_for_wire' and 'msg' are
# "sent over network," so now on "receiver" side

_, pk = blst.p1_deserialize(pk_for_wire)
_, sig = blst.p2_deserialize(sig_for_wire)
if blst.p1_affine_in_g1(pk) :	# vet the public key
    ctx = blst.pairing_init()
    blst.pairing_aggregate_pk_in_g1(ctx, pk, sig,
                    True,	# because "sender" called hash_to_g2
                    msg, DST, pk_for_wire)
    blst.pairing_commit(ctx)
    result = blst.pairing_finalverify(ctx)

print(result)

########################################################################
# generate public key and signature

pk_for_wire = blst.p2_serialize(blst.sk_to_pk_in_g2(SK))
				#vvvvvvvvvvv optional augmentation
hash = blst.hash_to_g1(msg, DST, pk_for_wire)
sig_for_wire = blst.p1_serialize(blst.sign_pk_in_g2(hash, SK))

########################################################################
# at this point 'pk_for_wire', 'sig_for_wire' and 'msg' are
# "sent over network," so now on "receiver" side

_, pk = blst.p2_deserialize(pk_for_wire)
_, sig = blst.p1_deserialize(sig_for_wire)
if blst.p2_affine_in_g2(pk) :	# vet the public key
    ctx = blst.pairing_init()
    blst.pairing_aggregate_pk_in_g2(ctx, pk, sig,
                    True,	# because "sender" called hash_to_g2
                    msg, DST, pk_for_wire)
    blst.pairing_commit(ctx)
    result = blst.pairing_finalverify(ctx)

print(result)

pk_for_wire = bytes.fromhex("ab10fc693d038b73d67279127501a05f0072cbb7147c68650ef6ac4e0a413e5cabd1f35c8711e1f7d9d885bbc3b8eddc")
sig_for_wire = bytes.fromhex("a44158c08c8c584477770feec2afa24d5a0b0bab2800414cb9efbb37c40339b6318c9349dad8de27ae644376d71232580ff5102c7a8579a6d2627c6e40b0ced737a60c66c7ebd377c04bf5ac957bf05bc8b6b09fbd7bdd2a7fa1090b5a0760bb")
msg = bytes.fromhex("0000000000000000000000000000000000000000000000000000000000000000")
DST = bytes.fromhex("424c535f5349475f424c53313233383147325f584d443a5348412d3235365f535357555f524f5f504f505f")

_, pk = blst.p1_uncompress(pk_for_wire)
_, sig = blst.p2_uncompress(sig_for_wire)
if blst.p1_affine_in_g1(pk) :	# vet the public key
    ctx = blst.pairing_init()
    blst.pairing_aggregate_pk_in_g1(ctx, pk, sig,
                    True,	# because "sender" called hash_to_g2
                    msg, DST)
    blst.pairing_commit(ctx)
    result = blst.pairing_finalverify(ctx)

print(result)


