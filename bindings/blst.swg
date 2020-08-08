// Copyright Supranational LLC
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

%module blst
%rename("%(strip:[blst_])s") "";    // prefix is redundant in named module

%include "exception.i"
#ifdef __cplusplus
%include "std_string.i"
#endif
%include "stdint.i"

typedef void void_;

#if defined(SWIGPYTHON) || defined(SWIGPERL)
// some sorcery to allow assignments as output, e.g.
//      hash = p.encode_to(b"foo")

# if defined(SWIGPYTHON)
%typemap(out) void " $result = NULL; ";
%typemap(ret) void " if ($result == NULL) $result = SWIG_Py_Void(); ";
# endif

%typemap(in, numinputs=0) OBJECT *OUTPUT($1_basetype temp) { $1 = &temp; };
%typemap(argout) OBJECT *OUTPUT {
# ifdef SWIGPYTHON
    PyObject *obj = SWIG_NewPointerObj(memcpy(malloc(sizeof($1_basetype)),
                                              $1,sizeof($1_basetype)),
                                       $descriptor, SWIG_POINTER_NEW);
    $result = ($result==NULL) ? obj
                              : SWIG_Python_AppendOutput($result, obj);
# else // TODO: figure out more language-specific ways to return multi-values...
    if ($result == NULL)
        $result = SWIG_NewPointerObj(memcpy(malloc(sizeof($1_basetype)),
                                            $1,sizeof($1_basetype)),
                                     $descriptor, SWIG_POINTER_NEW);
# endif
};
%apply OBJECT *OUTPUT {
    blst_p1        *out, blst_p1        *out_pk, blst_p1        *out_sig,
    blst_p1_affine *out, blst_p1_affine *out_pk, blst_p1_affine *out_sig,
    blst_p2        *out, blst_p2        *out_pk, blst_p2        *out_sig,
    blst_p2_affine *out, blst_p2_affine *out_pk, blst_p2_affine *out_sig,
    blst_scalar    *out, blst_scalar    *out_SK,
    blst_fp12      *out
};

#ifdef __cplusplus
%typemap(out) BLST_ERROR {
    if ($1 != BLST_SUCCESS) {
        SWIG_exception(SWIG_ValueError, BLST_ERROR_str[$1]);
        SWIG_fail;
    }
    $result = SWIG_From_int($1);
};
#endif

%typemap(in, numinputs=0) byte out[ANY](byte temp[$1_dim0]) {
    $1 = temp;
};
%typemap(argout) byte out[ANY] {
# ifdef SWIGPYTHON
    PyObject *obj = SWIG_FromCharPtrAndSize((char *)$1, $1_dim0);
    $result = ($result==NULL) ? obj
                              : SWIG_Python_AppendOutput($result, obj);
# else // TODO: figure out more language-specific ways to return multi-values...
    if ($result == NULL)
        $result = SWIG_FromCharPtrAndSize((char *)$1, $1_dim0);
# endif
};

%typemap(in, numinputs=0) blst_pairing *new_ctx {
    $1 = (blst_pairing *)calloc(1, blst_pairing_sizeof());
};
%typemap(argout) blst_pairing *new_ctx {
    $result = SWIG_NewPointerObj($1, $descriptor, SWIG_POINTER_NEW);
};
#endif	// defined(SWIGPYTHON) || defined(SWIGPERL)

#if defined(SWIGJAVA) && defined(__cplusplus)
%include "enums.swg"
%javaconst(1);
%include "arrays_java.i"

%typemap(throws) BLST_ERROR %{
    SWIG_JavaThrowException(jenv, SWIG_JavaRuntimeException,
                                  BLST_ERROR_str[$1]);
%};

// some sorcery to return byte[] from serialization methods
%typemap(in, numinputs=0) byte out[ANY](byte temp[$1_dim0]) {
    $1 = temp;
};
%typemap(argout) byte out[ANY] {
    $result = jenv->NewByteArray($1_dim0);
    if ($result != $null) {
        jenv->SetByteArrayRegion($result, 0, $1_dim0, (const jbyte *)$1);
    }
};
%typemap(jni)     void_ "jbyteArray"
%typemap(jtype)   void_ "byte[]"
%typemap(jstype)  void_ "byte[]"
%typemap(javaout) void_ "{ return $jnicall; }"

// handle input const byte[] more efficiently...
%apply signed char[] { const byte* in }
%typemap(in) const byte* in %{
    $1 = ($1_ltype)jenv->GetByteArrayElements($input, 0);
%};
%typemap(argout)  const byte* in ""
%typemap(freearg) const byte* in %{
    jenv->ReleaseByteArrayElements($input, (jbyte *)$1, JNI_ABORT);
%};

%apply const byte* in { const byte in[ANY] }
%typemap(in) const byte in[ANY] {
    size_t sz = jenv->GetArrayLength($input);
    if (sz != $1_dim0) {
        SWIG_JavaThrowException(jenv, SWIG_JavaIndexOutOfBoundsException,
                                      "BLST_ERROR: input size mismatch");
        return $null;
    }
    $1 = ($1_ltype)jenv->GetByteArrayElements($input, 0);
};

%apply long long[] { const limb_t* scalar }
%typemap(in) const limb_t* scalar (size_t _global_scalar_sz) %{
    $1 = ($1_ltype)jenv->GetLongArrayElements($input, 0);
    _global_scalar_sz = jenv->GetArrayLength($input);
%};
%typemap(argout)  const limb_t* scalar ""
%typemap(freearg) const limb_t* scalar %{
    jenv->ReleaseLongArrayElements($input, (jlong *)$1, JNI_ABORT);
%};
%typemap(in) size_t nbits %{
    if (($1 = (size_t)$input) > 8*sizeof(jlong)*_global_scalar_sz) {
        SWIG_JavaThrowException(jenv, SWIG_JavaIndexOutOfBoundsException,
                                      "BLST_ERROR: scalar size mismatch");
        $1 = 8*sizeof(jlong)*_global_scalar_sz;
    }
%};
#if SWIG_VERSION < 0x040000
%apply (char *STRING, size_t LENGTH) { (const char *STRING, size_t LENGTH) }
#endif
#else
%apply const char * { const byte in[ANY], const byte *in }
#endif
%apply (const char *STRING, size_t LENGTH) {
       (const byte *msg,    size_t msg_len),
       (const byte *DST,    size_t DST_len),
       (const byte *aug,    size_t aug_len),
       (const byte *IKM,    size_t IKM_len),
       (const byte *info,   size_t info_len)
};

#ifdef __cplusplus
%apply const std::string& { const std::string* };

#pragma SWIG nowarn=509,516

%ignore nullptr;
%ignore None;
%catches(BLST_ERROR) P1(const byte* in);
%catches(BLST_ERROR) P1_Affine(const byte* in);
%catches(BLST_ERROR) aggregate(const P1_Affine& in);

%catches(BLST_ERROR) P2(const byte* in);
%catches(BLST_ERROR) P2_Affine(const byte* in);
%catches(BLST_ERROR) aggregate(const P2_Affine& in);

typedef enum {
    BLST_SUCCESS = 0,
    BLST_BAD_ENCODING,
    BLST_POINT_NOT_ON_CURVE,
    BLST_POINT_NOT_IN_GROUP,
    BLST_AGGR_TYPE_MISMATCH,
    BLST_VERIFY_FAIL,
} BLST_ERROR;

%include "blst.hpp"
#else
%ignore blst_fr;
%ignore blst_fp;
%ignore blst_fp2;
%ignore blst_fp6;

%include "blst.h"
%include "blst_aux.h"
%extend blst_pairing {
    blst_pairing()  { return NULL; } // steer user toward pairing_init!
    ~blst_pairing() { free($self); }
};
#endif

%begin %{
#ifdef __cplusplus
# include "blst.hpp"
using namespace blst;
#else
# include "blst.h"
#endif

static const char *const BLST_ERROR_str [] = {
    "BLST_ERROR: success",
    "BLST_ERROR: bad point encoding",
    "BLST_ERROR: point is not on curve",
    "BLST_ERROR: point is not in group",
    "BLST_ERROR: context type mismatch",
    "BLST_ERROR: verify failed",
};

#define SWIG_PYTHON_STRICT_BYTE_CHAR
%}

#if defined(SWIGPYTHON) || defined(SWIGPERL)
%include "cdata.i"
#endif
