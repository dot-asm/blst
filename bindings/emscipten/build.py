#!/usr/bin/env python3
# Copyright Supranational LLC
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0

import os
import re
import sys
import shutil
import subprocess

emcc = shutil.which("emcc")
if emcc is None:
    print("FATAL: no 'emcc' on the program search path", file=sys.stderr)
    sys.exit(2)

common_cpp = """
#include <emscripten.h>
#include <blst.hpp>
using namespace blst;
#pragma GCC diagnostic ignored "-Wreturn-stack-address"
extern "C" {

EM_JS(void, blst_exception, (BLST_ERROR code), {
    throw new Error(BLST_ERROR_str[code]);
});
"""
common_js = """
const BLST_ERROR_str = [
    "BLST_ERROR: success",
    "BLST_ERROR: bad point encoding",
    "BLST_ERROR: point is not on curve",
    "BLST_ERROR: point is not in group",
    "BLST_ERROR: context type mismatch",
    "BLST_ERROR: verify failed",
    "BLST_ERROR: public key is infinite",
    "BLST_ERROR: bad scalar",
];
"""

# ###### P1_Affine
p1_cpp = """
P1_Affine* EMSCRIPTEN_KEEPALIVE P1_Affine_0()
{   return new P1_Affine();   }
P1_Affine* EMSCRIPTEN_KEEPALIVE P1_Affine_1(const P1* input)
{   return new P1_Affine(*input);   }
P1_Affine* EMSCRIPTEN_KEEPALIVE P1_Affine_2(const byte* input, size_t len)
{   try                         { return new P1_Affine(input, len); }
    catch (const BLST_ERROR& e) { blst_exception(e);                }
    return nullptr;
}
void EMSCRIPTEN_KEEPALIVE P1_Affine__destroy__0(P1_Affine* self)
{   delete self;   }
"""
p1_js = """
/** @this{Object} */
function P1_Affine(input)
{
    ensureCache.prepare();
    if (input === undefined)
        this.ptr = _P1_Affine_0();
    else if (input instanceof Uint8Array)
        this.ptr = _P1_Affine_2(ensureInt8(input), input.length);
    else if (input instanceof P1)
        this.ptr = _P1_Affine_1(input.ptr);
    else
        throw new Error(`unsupported type ${input.constructor.name}`);
    getCache(P1_Affine)[this.ptr] = this;
}
P1_Affine.prototype = Object.create(WrapperObject.prototype);
P1_Affine.prototype.constructor = P1_Affine;
P1_Affine.prototype.__class__ = P1_Affine;
P1_Affine.__cache__ = {};
Module['P1_Affine'] = P1_Affine;
P1_Affine.prototype['__destroy__'] = P1_Affine.prototype.__destroy__ = /** @this{Object} */
function()
{   _P1_Affine__destroy__0(this.ptr); this.ptr = 0;   };;
"""
p1_cpp += """
P1_Affine* EMSCRIPTEN_KEEPALIVE P1_Affine_dup_0(const P1_Affine* self)
{   return new P1_Affine(self->dup());   }
"""
p1_js += """
P1_Affine.prototype['dup'] = P1_Affine.prototype.dup = /** @this{Object} */
function()
{   return wrapPointer(_P1_Affine_dup_0(this.ptr), P1_Affine);   };;
"""
p1_cpp += """
P1* EMSCRIPTEN_KEEPALIVE P1_Affine_to_jacobian_0(const P1_Affine* self)
{   return new P1(self->to_jacobian());   }
"""
p1_js += """
P1_Affine.prototype['to_jacobian'] = P1_Affine.prototype.to_jacobian = /** @this{Object} */
function()
{   return wrapPointer(_P1_Affine_to_jacobian_0(this.ptr), P1);   };;
"""
p1_cpp += """
byte* EMSCRIPTEN_KEEPALIVE P1_Affine_serialize_0(const P1_Affine* self)
{
    byte out[96*1];
    self->serialize(out);
    return out;
}
"""
p1_js += """
P1_Affine.prototype['serialize'] = P1_Affine.prototype.serialize = /** @this{Object} */
function()
{
    var out = _P1_Affine_serialize_0(this.ptr);
    return new Uint8Array(HEAPU8.subarray(out, out + 96*1));
};;
"""
p1_cpp += """
byte* EMSCRIPTEN_KEEPALIVE P1_Affine_compress_0(const P1_Affine* self)
{
    byte out[48*1];
    self->compress(out);
    return out;
}
"""
p1_js += """
P1_Affine.prototype['compress'] = P1_Affine.prototype.compress = /** @this{Object} */
function()
{
    var out = _P1_Affine_compress_0(this.ptr);
    return new Uint8Array(HEAPU8.subarray(out, out + 48*1));
};;
"""
p1_cpp += """
bool EMSCRIPTEN_KEEPALIVE P1_Affine_on_curve_0(const P1_Affine* self)
{   return self->on_curve();   }
"""
p1_js += """
P1_Affine.prototype['on_curve'] = P1_Affine.prototype.on_curve = /** @this{Object} */
function()
{   return !!(_P1_Affine_on_curve_0(this.ptr));   };;
"""
p1_cpp += """
bool EMSCRIPTEN_KEEPALIVE P1_Affine_in_group_0(const P1_Affine* self)
{   return self->in_group();   }
"""
p1_js += """
P1_Affine.prototype['in_group'] = P1_Affine.prototype.in_group = /** @this{Object} */
function()
{   return !!(_P1_Affine_in_group_0(this.ptr));   };;
"""
p1_cpp += """
bool EMSCRIPTEN_KEEPALIVE P1_Affine_is_inf_0(const P1_Affine* self)
{   return self->is_inf();   }
"""
p1_js += """
P1_Affine.prototype['is_inf'] = P1_Affine.prototype.is_inf = /** @this{Object} */
function()
{   return !!(_P1_Affine_is_inf_0(this.ptr));   };;
"""
p1_cpp += """
bool EMSCRIPTEN_KEEPALIVE P1_Affine_is_equal_1(const P1_Affine* self, const P1_Affine* p)
{   return self->is_equal(*p);   }
"""
p1_js += """
P1_Affine.prototype['is_equal'] = P1_Affine.prototype.is_equal = /** @this{Object} */
function(p)
{
    if (p instanceof P1_Affine)
        return !!(_P1_Affine_is_equal_1(this.ptr, p.ptr));
    throw new Error(`unsupported type ${p.constructor.name}`);
};;
"""
p1_cpp += """
int EMSCRIPTEN_KEEPALIVE P1_Affine_core_verify_7(const P1_Affine* self,
                                const P2_Affine* pk, bool hash_or_encode,
                                const byte* msg, size_t msg_len,
                                const char* DST,
                                const byte* aug, size_t aug_len)
{ return self->core_verify(*pk, hash_or_encode, msg, msg_len, DST ? DST : "", aug, aug_len); }
"""
p1_js += """
P1_Affine.prototype['core_verify'] = P1_Affine.prototype.core_verify = /** @this{Object} */
function(pk, hash_or_encode, msg, DST, aug)
{
    if (!(pk instanceof P2_Affine))
        throw new Error(`unsupported type ${pk.constructor.name}`);
    ensureCache.prepare();
    const [_msg, msg_len] = ensureAny(msg);
    DST = ensureString(DST);
    const [_aug, aug_len] = ensureAny(aug);
    return _P1_Affine_core_verify_7(this.ptr, pk.ptr, !!hash_or_encode, _msg, msg_len, DST, _aug, aug_len);
};;
"""
p1_cpp += """
P1_Affine* EMSCRIPTEN_KEEPALIVE P1_Affine_generator_0()
{   return new P1_Affine(P1_Affine::generator());   }
"""
p1_js += """
P1_Affine.generator =
function()
{   return wrapPointer(_P1_Affine_generator_0(), P1_Affine);   }
"""

# ###### P1
p1_cpp += """
P1* EMSCRIPTEN_KEEPALIVE P1_0()
{   return new P1();   }
P1* EMSCRIPTEN_KEEPALIVE P1_affine_1(const P1_Affine* p)
{   return new P1(*p);   }
P1* EMSCRIPTEN_KEEPALIVE P1_secretkey_1(const SecretKey* sk)
{   return new P1(*sk);   }
P1* EMSCRIPTEN_KEEPALIVE P1_2(const byte* input, size_t len)
{   try                         { return new P1(input, len); }
    catch (const BLST_ERROR& e) { blst_exception(e);         }
    return nullptr;
}
void EMSCRIPTEN_KEEPALIVE P1__destroy__0(P1* self)
{   delete self;   }
"""
p1_js += """
/** @this{Object} */
function P1(input)
{
    ensureCache.prepare();
    if (input === undefined)
        this.ptr = _P1_0();
    else if (input instanceof Uint8Array)
        this.ptr = _P1_2(ensureInt8(input), input.length);
    else if (input instanceof P1_Affine)
        this.ptr = _P1_affine_1(input.ptr);
    else if (input instanceof SecretKey)
        this.ptr = _P1_secretkey_1(input.ptr);
    else
        throw new Error(`unsupported type ${input.constructor.name}`);
    getCache(P1)[this.ptr] = this;
}
P1.prototype = Object.create(WrapperObject.prototype);
P1.prototype.constructor = P1;
P1.prototype.__class__ = P1;
P1.__cache__ = {};
Module['P1'] = P1;
P1.prototype['__destroy__'] = P1.prototype.__destroy__ = /** @this{Object} */
function()
{   _P1__destroy__0(this.ptr); this.ptr = 0;  };;
"""
p1_cpp += """
P1* EMSCRIPTEN_KEEPALIVE P1_dup_0(const P1* self)
{   return new P1(self->dup());   }
"""
p1_js += """
P1.prototype['dup'] = P1.prototype.dup = /** @this{Object} */
function()
{   return wrapPointer(_P1_dup_0(this.ptr), P1);   };;
"""
p1_cpp += """
P1* EMSCRIPTEN_KEEPALIVE P1_to_affine_0(const P1* self)
{   return new P1(self->to_affine());   }
"""
p1_js += """
P1.prototype['to_affine'] = P1.prototype.to_affine = /** @this{Object} */
function()
{   return wrapPointer(_P1_to_affine_0(this.ptr), P1_Affine);   };;
"""
p1_cpp += """
byte* EMSCRIPTEN_KEEPALIVE P1_serialize_0(const P1* self)
{
    byte out[96*1];
    self->serialize(out);
    return out;
}
"""
p1_js += """
P1.prototype['serialize'] = P1.prototype.serialize = /** @this{Object} */
function()
{
    var out = _P1_serialize_0(this.ptr);
    return new Uint8Array(HEAPU8.subarray(out, out + 96*1));
};;
"""
p1_cpp += """
byte* EMSCRIPTEN_KEEPALIVE P1_compress_0(const P1* self)
{
    byte out[48*1];
    self->compress(out);
    return out;
}
"""
p1_js += """
P1.prototype['compress'] = P1.prototype.compress = /** @this{Object} */
function()
{
    var out = _P1_compress_0(this.ptr);
    return new Uint8Array(HEAPU8.subarray(out, out + 48*1));
};;
"""
p1_cpp += """
bool EMSCRIPTEN_KEEPALIVE P1_on_curve_0(const P1* self)
{   return self->on_curve();   }
"""
p1_js += """
P1.prototype['on_curve'] = P1.prototype.on_curve = /** @this{Object} */
function()
{   return !!(_P1_on_curve_0(this.ptr));   };;
"""
p1_cpp += """
bool EMSCRIPTEN_KEEPALIVE P1_in_group_0(const P1* self)
{   return self->in_group();   }
"""
p1_js += """
P1.prototype['in_group'] = P1.prototype.in_group = /** @this{Object} */
function()
{   return !!(_P1_in_group_0(this.ptr));   };;
"""
p1_cpp += """
bool EMSCRIPTEN_KEEPALIVE P1_is_inf_0(const P1* self)
{   return self->is_inf();   }
"""
p1_js += """
P1.prototype['is_inf'] = P1.prototype.is_inf = /** @this{Object} */
function()
{   return !!(_P1_is_inf_0(this.ptr));   };;
"""
p1_cpp += """
bool EMSCRIPTEN_KEEPALIVE P1_is_equal_1(const P1* self, const P1* p)
{   return self->is_equal(*p);   }
"""
p1_js += """
P1.prototype['is_equal'] = P1.prototype.is_equal = /** @this{Object} */
function(p)
{
    if (p instanceof P1)
        return !!(_P1_is_equal_1(this.ptr, p.ptr));
    throw new Error(`unsupported type ${p.constructor.name}`);
};;
"""
p1_cpp += """
void EMSCRIPTEN_KEEPALIVE P1_aggregate_1(P1* self, const P1_Affine* p)
{   return self->aggregate(*p);   }
"""
p1_js += """
P1.prototype['aggregate'] = P1.prototype.aggregate = /** @this{Object} */
function(p)
{
    if (p instanceof P1_Affine)
        _P1_aggregate_1(this.ptr, p.ptr);
    else
        throw new Error(`unsupported type ${p.constructor.name}`);
};;
"""
p1_cpp += """
void EMSCRIPTEN_KEEPALIVE P1_sign_with_1(P1* self, const SecretKey* sk)
{   (void)self->sign_with(*sk);   }
"""
p1_js += """
P1.prototype['sign_with'] = P1.prototype.sign_with = /** @this{Object} */
function(sk)
{
    if (sk instanceof SecretKey)
        _P1_sign_with_1(this.ptr, sk.ptr);
    else
        throw new Error(`unsupported type ${sk.constructor.name}`);
    return this;
};;
"""
p1_cpp += """
void EMSCRIPTEN_KEEPALIVE P1_hash_to_5(P1* self, const byte* msg, size_t msg_len,
                                                 const char* DST,
                                                 const byte* aug, size_t aug_len)
{   (void)self->hash_to(msg, msg_len, DST ? DST : "", aug, aug_len);   }
"""
p1_js += """
P1.prototype['hash_to'] = P1.prototype.hash_to = /** @this{Object} */
function(msg, DST, aug)
{
    ensureCache.prepare();
    const [_msg, msg_len] = ensureAny(msg);
    DST = ensureString(DST);
    const [_aug, aug_len] = ensureAny(aug);
    _P1_hash_to_5(this.ptr, _msg, msg_len, DST, _aug, aug_len);
    return this;
};;
"""
p1_cpp += """
void EMSCRIPTEN_KEEPALIVE P1_encode_to_5(P1* self, const byte* msg, size_t msg_len,
                                                   const char* DST,
                                                   const byte* aug, size_t aug_len)
{   (void)self->encode_to(msg, msg_len, DST ? DST : "", aug, aug_len);   }
"""
p1_js += """
P1.prototype['encode_to'] = P1.prototype.encode_to = /** @this{Object} */
function(msg, DST, aug)
{
    ensureCache.prepare();
    const [_msg, msg_len] = ensureAny(msg);
    DST = ensureString(DST);
    const [_aug, aug_len] = ensureAny(aug);
    _P1_encode_to_5(this.ptr, _msg, msg_len, DST, _aug, aug_len);
    return this;
};;
"""
p1_cpp += """
void EMSCRIPTEN_KEEPALIVE P1_mult_1(P1* self, const Scalar* scalar)
{   (void)self->mult(*scalar);   }
void EMSCRIPTEN_KEEPALIVE P1_mult_2(P1* self, const byte* scalar, size_t nbits)
{   (void)self->mult(scalar, nbits);   }
"""
p1_js += """
P1.prototype['mult'] = P1.prototype.mult = /** @this{Object} */
function(scalar)
{
    /*if (scalar instanceof Scalar) {
        _P1_mult_1(this.ptr, scalar.ptr);
    } else*/ {
        ensureCache.prepare();
        const [_scalar, len] = ensureAny(scalar);
        _P1_mult_2(this.ptr, _scalar, len*8);
    }
    return this;
};;
"""
p1_cpp += """
void EMSCRIPTEN_KEEPALIVE P1_cneg_1(P1* self, bool flag)
{   (void)self->cneg(flag);   }
"""
p1_js += """
P1.prototype['cneg'] = P1.prototype.cneg = /** @this{Object} */
function(flag)
{
    _P1_cneg_1(this.ptr, !!flag);
    return this;
};;
P1.prototype['neg'] = P1.prototype.neg = /** @this{Object} */
function()
{
    _P1_cneg_1(this.ptr, true);
    return this;
};;
"""
p1_cpp += """
void EMSCRIPTEN_KEEPALIVE P1_add_1(P1* self, const P1* a)
{   (void)self->add(*a);   }
void EMSCRIPTEN_KEEPALIVE P1_add_affine_1(P1* self, const P1_Affine* a)
{   (void)self->add(*a);   }
"""
p1_js += """
P1.prototype['add'] = P1.prototype.add = /** @this{Object} */
function(p)
{
    if (p instanceof P1)
        _P1_add_1(this.ptr, p.ptr);
    else if (p instanceof P1_Affine)
        _P1_add_affine_1(this.ptr, p.ptr);
    else
        throw new Error(`unsupported type ${p.constructor.name}`);
    return this;
};;
"""
p1_cpp += """
void EMSCRIPTEN_KEEPALIVE P1_dbl_0(P1* self)
{   (void)self->dbl();   }
"""
p1_js += """
P1.prototype['dbl'] = P1.prototype.dbl = /** @this{Object} */
function()
{
    _P1_dbl_0(this.ptr);
    return this;
};;
"""
p1_cpp += """
P1* EMSCRIPTEN_KEEPALIVE P1_generator_0()
{   return new P1(P1::generator());   }
"""
p1_js += """
P1.generator =
function()
{   return wrapPointer(_P1_generator_0(), P1);   }
"""

common_js += """
function ensureAny(value) {
    if (typeof value === "undefined" || value === null)
        return [0, 0];

    switch (value.constructor.name) {
        case "String":
            return [ensureString(value), lengthBytesUTF8(value)];
        case "Buffer": case "Uint8Array":
            return [ensureInt8(value), value.length];
        case "BigInt":
            if (value < 0)
                throw new Error("expecting unsigned BigInt value");
            var temp = [];
            while (value != 0) {
                temp.push(Number(value & 255n));
                value >>= 8n;
            }
            return [ensureInt8(temp), temp.length];
        default:
            throw new Error(`unsupported type for 'value': ${value.constructor.name}`);
    }
}
"""

# ###### SecretKey
common_cpp += """
SecretKey* EMSCRIPTEN_KEEPALIVE SecretKey_0()
{   return new SecretKey();   }
void EMSCRIPTEN_KEEPALIVE SecretKey__destroy__0(SecretKey* self)
{   explicit_bzero((void*)self, sizeof(*self)); delete self;   }
"""
common_js += """
/** @this{Object} */
function SecretKey()
{
    this.ptr = _SecretKey_0();
    getCache(SecretKey)[this.ptr] = this;
}
SecretKey.prototype = Object.create(WrapperObject.prototype);
SecretKey.prototype.constructor = SecretKey;
SecretKey.prototype.__class__ = SecretKey;
SecretKey.__cache__ = {};
Module['SecretKey'] = SecretKey;
SecretKey.prototype['__destroy__'] = SecretKey.prototype.__destroy__ = /** @this{Object} */
function()
{   _SecretKey__destroy__0(this.ptr); this.ptr = 0;  };;
"""
common_cpp += """
void EMSCRIPTEN_KEEPALIVE SecretKey_keygen_3(SecretKey* self, const byte* IKM, size_t IKM_len, const char* info)
{   self->keygen(IKM, IKM_len, info ? info : "");   }
"""
common_js += """
SecretKey.prototype['keygen'] = SecretKey.prototype.keygen = /** @this{Object} */
function(IKM, info)
{
    ensureCache.prepare();
    const [_IKM, IKM_len] = ensureAny(IKM);
    if (IKM_len < 32)
        throw new Error("IKM is too short");
    info = ensureString(info);
    _SecretKey_keygen_3(this.ptr, _IKM, IKM_len, info);
    HEAP8.fill(0, _IKM, _IKM + IKM_len);
}
"""

# ###### Pairing
common_cpp += """
Pairing* EMSCRIPTEN_KEEPALIVE Pairing_2(bool hash_or_encode, const char* DST)
{   return new Pairing(hash_or_encode, DST ? DST : "");   }
void EMSCRIPTEN_KEEPALIVE Pairing__destroy__0(Pairing* self)
{   delete self;   }
"""
common_js += """
/** @this{Object} */
function Pairing(hash_or_encode, DST)
{
    ensureCache.prepare();
    DST = ensureString(DST);
    this.ptr = _Pairing_2(!!hash_or_encode, DST);
    getCache(SecretKey)[this.ptr] = this;
}
Pairing.prototype = Object.create(WrapperObject.prototype);
Pairing.prototype.constructor = Pairing;
Pairing.prototype.__class__ = Pairing;
Pairing.__cache__ = {};
Module['Pairing'] = Pairing;
Pairing.prototype['__destroy__'] = Pairing.prototype.__destroy__ = /** @this{Object} */
function()
{   _Pairing__destroy__0(this.ptr); this.ptr = 0;  };;
"""
common_cpp += """
int EMSCRIPTEN_KEEPALIVE Pairing_aggregate_pk_in_g1_6(Pairing* self,
                                const P1_Affine* pk, const P2_Affine* sig,
                                const byte* msg, size_t msg_len,
                                const byte* aug, size_t aug_len)
{   return self->aggregate(pk, sig, msg, msg_len, aug, aug_len);   }
int EMSCRIPTEN_KEEPALIVE Pairing_aggregate_pk_in_g2_6(Pairing* self,
                                const P2_Affine* pk, const P1_Affine* sig,
                                const byte* msg, size_t msg_len,
                                const byte* aug, size_t aug_len)
{   return self->aggregate(pk, sig, msg, msg_len, aug, aug_len);   }
"""
common_js += """
Pairing.prototype['aggregate'] = Pairing.aggregate = /** @this{Object} */
function(pk, sig, msg, aug)
{
    ensureCache.prepare();
    const [_msg, msg_len] = ensureAny(msg);
    const [_aug, aug_len] = ensureAny(aug);
    if (pk instanceof P1_Affine && sig instanceof P2_Affine)
        return _Pairing_aggregate_pk_in_g1_6(this.ptr, pk.ptr, sig.ptr, _msg, msg_len, _aug, aug_len);
    else if (pk instanceof P2_Affine && sig instanceof P1_Affine)
        return _Pairing_aggregate_pk_in_g2_6(this.ptr, pk.ptr, sig.ptr, _msg, msg_len, _aug, aug_len);
    else
        throw new Error(`unsupported types ${pk.constructor.name} and ${sig.constructor.name} or combination thereof`);
    return -1;
}
"""
common_cpp += """
void EMSCRIPTEN_KEEPALIVE Pairing_commit_0(Pairing* self)
{   self->commit();   }
"""
common_js += """
Pairing.prototype['commit'] = Pairing.commit = /** @this{Object} */
function()
{   _Pairing_commit_0(this.ptr);    }
"""
common_cpp += """
bool EMSCRIPTEN_KEEPALIVE Pairing_finalverify_0(const Pairing* self)
{   return self->finalverify();   }
"""
common_js += """
Pairing.prototype['finalverify'] = Pairing.finalverify = /** @this{Object} */
function()
{   return !!(_Pairing_finalverify_0(this.ptr));    }
"""


here = os.getcwd()
there = re.split(r'[/\\](?=[^/\\]*$)', sys.argv[0])
if len(there) > 1:
    os.chdir(there[0])


def xchg_1vs2(matchobj):
    if matchobj.group(2) == '1':
        return matchobj.group(1) + '2'
    else:
        return matchobj.group(1) + '1'


fd = open("blst_embind.cpp", "w")
print("//!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!", file=fd)
print("// DO NOT EDIT THIS FILE!!!",                         file=fd)
print("// The file is auto-generated by " + there[-1],       file=fd)
print("//!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!", file=fd)
print(common_cpp, file=fd)
print(p1_cpp, file=fd)
print(re.sub(r'((?<!f)[pgPG\*])([12])', xchg_1vs2, p1_cpp), file=fd)
print("}", file=fd)  # close extern "C" {
fd.close()

fd = open("blst_embind.js", "w")
print("//!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!", file=fd)
print("// DO NOT EDIT THIS FILE!!!",                         file=fd)
print("// The file is auto-generated by " + there[-1],       file=fd)
print("//!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!", file=fd)
print(common_js, file=fd)
print(p1_js, file=fd)
print(re.sub(r'((?<!f)[pgPG\*])([12])', xchg_1vs2, p1_js), file=fd)
fd.close()

subprocess.check_call([os.path.dirname(emcc) + os.path.normpath("/tools/webidl_binder"),
                       os.devnull, "embind"])
subprocess.check_call(["emcc", "-I..", "-fexceptions", "-include", "stddef.h",
                       "embind.cpp", "--post-js", "embind.js",
                       "blst_embind.cpp", "--post-js", "blst_embind.js",
                       "../../src/server.c", "-lembind",
                       "-o", os.path.normpath(here + "/blst.js")] +
                      sys.argv[1:])  # pass through flags, e.g. -Os
