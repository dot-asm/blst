// Copyright Supranational LLC
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

%module blst
%rename("%(strip:[blst_])s") "";    // prefix is redundant in named module

%include "exception.i"
#ifdef __cplusplus
%include "std_string.i"
#endif

#if defined(SWIGPYTHON) || defined(SWIGPERL)
# if defined(SWIGPYTHON)
%begin %{
#define SWIG_PYTHON_STRICT_BYTE_CHAR
%}
# endif

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
    blst_p1 *out, blst_p1 *out_pk, blst_p1 *out_sig,
    blst_p1_affine *out, blst_p1_affine *out_pk, blst_p1_affine *out_sig,
    blst_p2 *out, blst_p2 *out_pk, blst_p2 *out_sig,
    blst_p2_affine *out, blst_p2_affine *out_pk, blst_p2_affine *out_sig,
    blst_scalar *out, blst_scalar *out_SK, blst_fp12 *out
};

%typemap(out) BLST_ERROR {
    if ($1 != BLST_SUCCESS) {
        SWIG_exception(SWIG_ValueError, BLST_ERROR_str[$1]);
        SWIG_fail;
    }
    resultobj = SWIG_From_int($1);
};

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

%apply const char * { const byte in[ANY] };
%apply const char * { const byte *in };
%apply (const char *STRING, size_t LENGTH) {
    (const byte *msg, size_t msg_len),
    (const byte *DST, size_t DST_len),
    (const byte *aug, size_t aug_len),
    (const byte *IKM, size_t IKM_len),
    (const byte *info, size_t info_len)
};

#ifdef __cplusplus
%apply const std::string& { const std::string* };

#pragma SWIG nowarn=509,516

%ignore nullptr;
%catches(BLST_ERROR) P1(const byte *in);
%catches(BLST_ERROR) P1_Affine(const byte *in);

%catches(BLST_ERROR) P2(const byte *in);
%catches(BLST_ERROR) P2_Affine(const byte *in);

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
    blst_pairing()  { return NULL; } // adhere to pairing_init!
    ~blst_pairing() { free($self); }
};
#endif

%begin %{
#ifdef __cplusplus
# include "blst.hpp"
#else
# include "blst.h"
#endif

static const char *const BLST_ERROR_str [] = {
    "success",
    "bad point encoding",
    "point is not on curve",
    "point is not in group",
    "context type mismatch",
    "verify failed",
};
%}

%include "cdata.i"
