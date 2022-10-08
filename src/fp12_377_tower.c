/*
 * Copyright Supranational LLC
 * Licensed under the Apache License, Version 2.0, see LICENSE for details.
 * SPDX-License-Identifier: Apache-2.0
 */

#include "consts_377.c"

/*
 * Fp2  = Fp[u]  / (u^2 + 5)
 * Fp6  = Fp2[v] / (v^3 - u)
 * Fp12 = Fp6[w] / (w^2 - v)
 */

typedef vec384x   vec384fp2;
typedef vec384fp2 vec384fp6[3];
typedef vec384fp6 vec384fp12[2];

/*
 * BLS12-377-specifc Fp shortcuts to assembly.
 */
static inline void add_fp(vec384 ret, const vec384 a, const vec384 b)
{   add_mod_384(ret, a, b, BLS12_377_P);   }

static inline void sub_fp(vec384 ret, const vec384 a, const vec384 b)
{   sub_mod_384(ret, a, b, BLS12_377_P);   }

static inline void mul_by_3_fp(vec384 ret, const vec384 a)
{   mul_by_3_mod_384(ret, a, BLS12_377_P);   }

static inline void mul_by_5_fp(vec384 ret, const vec384 a)
{   mul_by_5_mod_384(ret, a, BLS12_377_P);   }

static inline void mul_by_8_fp(vec384 ret, const vec384 a)
{   mul_by_8_mod_384(ret, a, BLS12_377_P);   }

static inline void lshift_fp(vec384 ret, const vec384 a, size_t count)
{   lshift_mod_384(ret, a, count, BLS12_377_P);   }

static inline void rshift_fp(vec384 ret, const vec384 a, size_t count)
{   rshift_mod_384(ret, a, count, BLS12_377_P);   }

static inline void div_by_2_fp(vec384 ret, const vec384 a)
{   div_by_2_mod_384(ret, a, BLS12_377_P);   }

static inline void mul_fp(vec384 ret, const vec384 a, const vec384 b)
{   mul_mont_384(ret, a, b, BLS12_377_P, p0);   }

static inline void sqr_fp(vec384 ret, const vec384 a)
{   sqr_mont_384(ret, a, BLS12_377_P, p0);   }

static inline void cneg_fp(vec384 ret, const vec384 a, bool_t flag)
{   cneg_mod_384(ret, a, flag, BLS12_377_P);   }

static inline void from_fp(vec384 ret, const vec384 a)
{   from_mont_384(ret, a, BLS12_377_P, p0);   }

static inline void redc_fp(vec384 ret, const vec768 a)
{   redc_mont_384(ret, a, BLS12_377_P, p0);   }

static void inverse_fp(vec384 out, const vec384 inp)
{
    static const vec384 Px128 = {   /* left-aligned value of the modulus */
        TO_LIMB_T(0x8460000000000080), TO_LIMB_T(0x85aea21800000042),
        TO_LIMB_T(0x79b117dd04a4000b), TO_LIMB_T(0x116cf9807a89c78f),
        TO_LIMB_T(0x1d82e03650a49d8d), TO_LIMB_T(0xd71d230be2887563)
    };
    static const vec384 RRx4 = {    /* (4<<768)%P */
        TO_LIMB_T(0x5910e1b250033487), TO_LIMB_T(0xf59c95669010c6c6),
        TO_LIMB_T(0x6ba46215d15189b3), TO_LIMB_T(0xe55b1a1b0901fb21),
        TO_LIMB_T(0x47bf46009942e6ab), TO_LIMB_T(0x0009b8e662801d37)
    };
    union { vec768 x; vec384 r[2]; } temp;

    ct_inverse_mod_383(temp.x, inp, BLS12_377_P, Px128);
    redc_mont_384(temp.r[0], temp.x, BLS12_377_P, p0);
    mul_mont_384(out, temp.r[0], RRx4, BLS12_377_P, p0);
}

/*
 * BLS12-377-specifc Fp2 shortcuts to assembly.
 */
static inline void add_fp2(vec384x ret, const vec384x a, const vec384x b)
{   add_mod_384x(ret, a, b, BLS12_377_P);   }

static inline void sub_fp2(vec384x ret, const vec384x a, const vec384x b)
{   sub_mod_384x(ret, a, b, BLS12_377_P);   }

static inline void mul_by_3_fp2(vec384x ret, const vec384x a)
{   mul_by_3_mod_384x(ret, a, BLS12_377_P);   }

static inline void mul_by_8_fp2(vec384x ret, const vec384x a)
{   mul_by_8_mod_384x(ret, a, BLS12_377_P);   }

static inline void lshift_fp2(vec384x ret, const vec384x a, size_t count)
{
    lshift_fp(ret[0], a[0], count);
    lshift_fp(ret[1], a[1], count);
}

static inline void cneg_fp2(vec384x ret, const vec384x a, bool_t flag)
{
    cneg_fp(ret[0], a[0], flag);
    cneg_fp(ret[1], a[1], flag);
}
#define neg_fp2(r,a) cneg_fp2((r),(a),1)

static void mul_fp2(vec384x ret, const vec384x a, const vec384x b)
{
    vec384 t0, t1;

    add_fp(t0, a[0], a[1]);             /* (a0+a1) */
    add_fp(t1, b[0], b[1]);             /* (b0+b1) */

    mul_fp(ret[0], a[0], b[0]);         /* a0*b0 */
    mul_fp(ret[1], a[1], b[1]);         /* a1*b1 */
    mul_fp(t0, t0, t1);                 /* (a0+a1)*(b0+b1) */

    mul_by_5_fp(t1, ret[1]);
    sub_fp(t0, t0, ret[0]);
    sub_fp(ret[0], ret[0], t1);         /* a0*b0-5*a1*b1 */
    sub_fp(ret[1], t0, ret[1]);         /* a0*b1+a1*b0 */
}

static void sqr_fp2(vec384x ret, const vec384x a)
{
    vec384 t0, t1, t2;

    add_fp(t0, a[1], a[1]);             /* 2*a1 */
    mul_by_3_fp(t1, a[1]);              /* 3*a1 */

    add_fp(t1, t1, t0);                 /* 5*a1 */
    sub_fp(t2, a[0], a[1]);             /* (a0-a1) */
    add_fp(t1, a[0], t1);               /* (a0+5*a1) */

    mul_fp(ret[1], a[0], t0);           /* 2*a0*a1 */

    mul_fp(ret[0], t2, t1);             /* (a0-a1)*(a0+5*a1) */
    sub_fp(ret[0], ret[0], ret[1]);
    sub_fp(ret[0], ret[0], ret[1]);     /* a0^2-5*a1^2 */
}

static void inverse_fp2(vec384x ret, const vec384x a)
{
    vec384 t0, t1;

    sqr_mont_384(t0, a[0], BLS12_377_P, p0);
    sqr_mont_384(t1, a[1], BLS12_377_P, p0);
    mul_by_5_mod_384(t1, t1, BLS12_377_P);
    add_mod_384(t0, t0, t1, BLS12_377_P);

    inverse_fp(t1, t0);

    mul_mont_384(ret[0], a[0], t1, BLS12_377_P, p0);
    mul_mont_384(ret[1], a[1], t1, BLS12_377_P, p0);
    cneg_mod_384(ret[1], ret[1], 1, BLS12_377_P);
}

static inline void mul_by_u_fp2(vec384x ret, const vec384x a)
{
    vec384 t0;

    mul_by_5_fp(t0, a[1]);
    vec_copy(ret[1], a[0], sizeof(vec384));
    cneg_fp(ret[0], t0, 1);
}

#if 1 && !defined(__BLST_NO_ASM__)
#define __FP2x2__
/*
 * Fp2x2 is a "widened" version of Fp2, which allows to consolidate
 * reductions from several multiplications. In other words instead of
 * "mul_redc-mul_redc-add" we get "mul-mul-add-redc," where latter
 * addition is double-width... To be more specific this gives ~7-10%
 * faster pairing depending on platform...
 */
typedef vec768 vec768x[2];

static inline void add_fp2x2(vec768x ret, const vec768x a, const vec768x b)
{
    add_mod_384x384(ret[0], a[0], b[0], BLS12_377_P);
    add_mod_384x384(ret[1], a[1], b[1], BLS12_377_P);
}

static inline void sub_fp2x2(vec768x ret, const vec768x a, const vec768x b)
{
    sub_mod_384x384(ret[0], a[0], b[0], BLS12_377_P);
    sub_mod_384x384(ret[1], a[1], b[1], BLS12_377_P);
}

static inline void mul_by_u_fp2x2(vec768x ret, const vec768x a)
{
    /* caveat lector! |ret| may not be same as |a| */
    mul_by_5_mod_384x384(ret[0], a[1], BLS12_377_P);
    vec_copy(ret[1], a[0], sizeof(vec768));
    neg_mod_384x384(ret[0], ret[0], BLS12_377_P);
}

static inline void redc_fp2x2(vec384x ret, const vec768x a)
{
    redc_mont_384(ret[0], a[0], BLS12_377_P, p0);
    redc_mont_384(ret[1], a[1], BLS12_377_P, p0);
}

static void mul_fp2x2(vec768x ret, const vec384x a, const vec384x b)
{
    union { vec384 x[2]; vec768 x2; } t;

    add_mod_384(t.x[0], a[0], a[1], BLS12_377_P);       /* (a0+a1) */
    add_mod_384(t.x[1], b[0], b[1], BLS12_377_P);       /* (b0+b1) */
    mul_384(ret[1], t.x[0], t.x[1]);                    /* (a0+a1)*(b0+b1) */

    mul_384(ret[0], a[0], b[0]);                        /* a0*b0 */
    mul_384(t.x2,   a[1], b[1]);                        /* a1*b1 */

    sub_mod_384x384(ret[1], ret[1], ret[0], BLS12_377_P);
    sub_mod_384x384(ret[1], ret[1], t.x2, BLS12_377_P); /* a0*b1+a1*b0 */

    mul_by_5_mod_384x384(t.x2, t.x2, BLS12_377_P);
    sub_mod_384x384(ret[0], ret[0], t.x2, BLS12_377_P); /* a0*b0-5*a1*b1 */
}

static void sqr_fp2x2(vec768x ret, const vec384x a)
{
    union { vec384 x[2]; vec768 x2; } t;

    add_mod_384(t.x[0], a[1], a[1], BLS12_377_P);       /* 2*a1 */
    mul_by_3_mod_384(t.x[1], a[1], BLS12_377_P);        /* 3*a1 */

    mul_384(ret[1], a[0], t.x[0]);                      /* 2*a0*a1 */

    add_mod_384(t.x[1], t.x[1], t.x[0], BLS12_377_P);   /* 5*a1 */
    sub_mod_384(t.x[0], a[0], a[1], BLS12_377_P);       /* (a0-a1) */
    add_mod_384(t.x[1], a[0], t.x[1], BLS12_377_P);     /* (a0+5*a1) */

    mul_384(ret[0], t.x[0], t.x[1]);                    /* (a0-a1)*(a0+5*a1) */
    sub_mod_384x384(ret[0], ret[0], ret[1], BLS12_377_P);
    sub_mod_384x384(ret[0], ret[0], ret[1], BLS12_377_P);
}
#endif  /* __FP2x2__ */

/*
 * Fp6 extension
 */
#if defined(__FP2x2__)  /* ~10-13% improvement for mul_fp12 and sqr_fp12 */
typedef vec768x vec768fp6[3];

static inline void sub_fp6x2(vec768fp6 ret, const vec768fp6 a,
                                            const vec768fp6 b)
{
    sub_fp2x2(ret[0], a[0], b[0]);
    sub_fp2x2(ret[1], a[1], b[1]);
    sub_fp2x2(ret[2], a[2], b[2]);
}

static void mul_fp6x2(vec768fp6 ret, const vec384fp6 a, const vec384fp6 b)
{
    vec768x t0, t1, t2;
    vec384x aa, bb;

    mul_fp2x2(t0, a[0], b[0]);
    mul_fp2x2(t1, a[1], b[1]);
    mul_fp2x2(t2, a[2], b[2]);

    /* ret[0] = ((a1 + a2)*(b1 + b2) - a1*b1 - a2*b2)*u + a0*b0
              = (a1*b2 + a2*b1)*u + a0*b0 */
    add_fp2(aa, a[1], a[2]);
    add_fp2(bb, b[1], b[2]);
    mul_fp2x2(ret[0], aa, bb);
    sub_fp2x2(ret[0], ret[0], t1);
    sub_fp2x2(ret[1], ret[0], t2);  /* borrow ret[1] for a moment */
#if 0
    mul_by_u_fp2x2(ret[0], ret[1]);
    add_fp2x2(ret[0], ret[0], t0);
#else
    mul_by_5_mod_384x384(ret[1][1], ret[1][1], BLS12_377_P);
    sub_mod_384x384(ret[0][0], t0[0], ret[1][1], BLS12_377_P);
    add_mod_384x384(ret[0][1], t0[1], ret[1][0], BLS12_377_P);
#endif

    /* ret[1] = (a0 + a1)*(b0 + b1) - a0*b0 - a1*b1 + a2*b2*u
              = a0*b1 + a1*b0 + a2*b2*u */
    add_fp2(aa, a[0], a[1]);
    add_fp2(bb, b[0], b[1]);
    mul_fp2x2(ret[1], aa, bb);
    sub_fp2x2(ret[1], ret[1], t0);
    sub_fp2x2(ret[1], ret[1], t1);
#if 0
    mul_by_u_fp2x2(ret[2], t2);     /* borrow ret[2] for a moment */
    add_fp2x2(ret[1], ret[1], ret[2]);
#else
    mul_by_5_mod_384x384(ret[2][0], t2[1], BLS12_377_P);
    sub_mod_384x384(ret[1][0], ret[1][0], ret[2][0], BLS12_377_P);
    add_mod_384x384(ret[1][1], ret[1][1], t2[0], BLS12_377_P);
#endif

    /* ret[2] = (a0 + a2)*(b0 + b2) - a0*b0 - a2*b2 + a1*b1
              = a0*b2 + a2*b0 + a1*b1 */
    add_fp2(aa, a[0], a[2]);
    add_fp2(bb, b[0], b[2]);
    mul_fp2x2(ret[2], aa, bb);
    sub_fp2x2(ret[2], ret[2], t0);
    sub_fp2x2(ret[2], ret[2], t2);
    add_fp2x2(ret[2], ret[2], t1);
}

static inline void redc_fp6x2(vec384fp6 ret, const vec768fp6 a)
{
    redc_fp2x2(ret[0], a[0]);
    redc_fp2x2(ret[1], a[1]);
    redc_fp2x2(ret[2], a[2]);
}

static void mul_fp6(vec384fp6 ret, const vec384fp6 a, const vec384fp6 b)
{
    vec768fp6 r;

    mul_fp6x2(r, a, b);
    redc_fp6x2(ret, r); /* narrow to normal width */
}

static void sqr_fp6(vec384fp6 ret, const vec384fp6 a)
{
    vec768x s0, m01, m12, s2, rx;

    sqr_fp2x2(s0, a[0]);

    mul_fp2x2(m01, a[0], a[1]);
    add_fp2x2(m01, m01, m01);

    mul_fp2x2(m12, a[1], a[2]);
    add_fp2x2(m12, m12, m12);

    sqr_fp2x2(s2, a[2]);

    /* ret[2] = (a0 + a1 + a2)^2 - a0^2 - a2^2 - 2*(a0*a1) - 2*(a1*a2)
              = a1^2 + 2*(a0*a2) */
    add_fp2(ret[2], a[2], a[1]);
    add_fp2(ret[2], ret[2], a[0]);
    sqr_fp2x2(rx, ret[2]);
    sub_fp2x2(rx, rx, s0);
    sub_fp2x2(rx, rx, s2);
    sub_fp2x2(rx, rx, m01);
    sub_fp2x2(rx, rx, m12);
    redc_fp2x2(ret[2], rx);

    /* ret[0] = a0^2 + 2*(a1*a2)*u */
#if 0
    mul_by_u_fp2x2(rx, m12);
    add_fp2x2(rx, rx, s0);
#else
    mul_by_5_mod_384x384(rx[0], m12[1], BLS12_377_P);
    sub_mod_384x384(rx[0], s0[0], rx[0], BLS12_377_P);
    add_mod_384x384(rx[1], s0[1], m12[0], BLS12_377_P);
#endif
    redc_fp2x2(ret[0], rx);

    /* ret[1] = a2^2*u + 2*(a0*a1) */
#if 0
    mul_by_u_fp2x2(rx, s2);
    add_fp2x2(rx, rx, m01);
#else
    mul_by_5_mod_384x384(rx[0], s2[1], BLS12_377_P);
    sub_mod_384x384(rx[0], m01[0], rx[0], BLS12_377_P);
    add_mod_384x384(rx[1], m01[1], s2[0], BLS12_377_P);
#endif
    redc_fp2x2(ret[1], rx);
}
#else
static void mul_fp6(vec384fp6 ret, const vec384fp6 a, const vec384fp6 b)
{
    vec384x t0, t1, t2, t3, t4, t5;

    mul_fp2(t0, a[0], b[0]);
    mul_fp2(t1, a[1], b[1]);
    mul_fp2(t2, a[2], b[2]);

    /* ret[0] = ((a1 + a2)*(b1 + b2) - a1*b1 - a2*b2)*u + a0*b0
              = (a1*b2 + a2*b1)*u + a0*b0 */
    add_fp2(t4, a[1], a[2]);
    add_fp2(t5, b[1], b[2]);
    mul_fp2(t3, t4, t5);
    sub_fp2(t3, t3, t1);
    sub_fp2(t3, t3, t2);
    /* mul_by_u_fp2(t3, t3);
     * add_fp2(ret[0], t3, t0); considering possible aliasing... */

    /* ret[1] = (a0 + a1)*(b0 + b1) - a0*b0 - a1*b1 + a2*b2*u
              = a0*b1 + a1*b0 + a2*b2*u */
    add_fp2(t4, a[0], a[1]);
    add_fp2(t5, b[0], b[1]);
    mul_fp2(ret[1], t4, t5);
    sub_fp2(ret[1], ret[1], t0);
    sub_fp2(ret[1], ret[1], t1);
#if 0
    mul_by_u_fp2(t4, t2);
    add_fp2(ret[1], ret[1], t4);
#else
    mul_by_5_fp(t4[0], t2[1]);
    sub_fp(ret[1][0], ret[1][0], t4[0]);
    add_fp(ret[1][1], ret[1][1], t2[0]);
#endif

    /* ret[2] = (a0 + a2)*(b0 + b2) - a0*b0 - a2*b2 + a1*b1
              = a0*b2 + a2*b0 + a1*b1 */
    add_fp2(t4, a[0], a[2]);
    add_fp2(t5, b[0], b[2]);
    mul_fp2(ret[2], t4, t5);
    sub_fp2(ret[2], ret[2], t0);
    sub_fp2(ret[2], ret[2], t2);
    add_fp2(ret[2], ret[2], t1);

#if 0
    mul_by_u_fp2(t3, t3);       /* ... moved from above */
    add_fp2(ret[0], t3, t0);
#else
    mul_by_5_fp(ret[0][0], t3[1]);
    sub_fp(ret[0][0], t0[0], ret[0][0]);
    add_fp(ret[0][1], t0[1], t3[0]);
#endif
}

static void sqr_fp6(vec384fp6 ret, const vec384fp6 a)
{
    vec384x s0, m01, m12, s2;

    sqr_fp2(s0, a[0]);

    mul_fp2(m01, a[0], a[1]);
    add_fp2(m01, m01, m01);

    mul_fp2(m12, a[1], a[2]);
    add_fp2(m12, m12, m12);

    sqr_fp2(s2, a[2]);

    /* ret[2] = (a0 + a1 + a2)^2 - a0^2 - a2^2 - 2*(a0*a1) - 2*(a1*a2)
              = a1^2 + 2*(a0*a2) */
    add_fp2(ret[2], a[2], a[1]);
    add_fp2(ret[2], ret[2], a[0]);
    sqr_fp2(ret[2], ret[2]);
    sub_fp2(ret[2], ret[2], s0);
    sub_fp2(ret[2], ret[2], s2);
    sub_fp2(ret[2], ret[2], m01);
    sub_fp2(ret[2], ret[2], m12);

    /* ret[0] = a0^2 + 2*(a1*a2)*u */
#if 0
    mul_by_u_fp2(ret[0], m12);
    add_fp2(ret[0], ret[0], s0);
#else
    mul_by_5_fp(ret[0][0], m12[1]);
    sub_fp(ret[0][0], s0[0], ret[0][0]);
    add_fp(ret[0][1], s0[1], m12[0]);
#endif

    /* ret[1] = a2^2*u + 2*(a0*a1) */
#if 0
    mul_by_u_fp2(ret[1], s2);
    add_fp2(ret[1], ret[1], m01);
#else
    mul_by_5_fp(ret[1][0], s2[1]);
    sub_fp(ret[1][0], m01[0], ret[1][0]);
    add_fp(ret[1][1], m01[1], s2[0]);
#endif
}
#endif

static void add_fp6(vec384fp6 ret, const vec384fp6 a, const vec384fp6 b)
{
    add_fp2(ret[0], a[0], b[0]);
    add_fp2(ret[1], a[1], b[1]);
    add_fp2(ret[2], a[2], b[2]);
}

static void sub_fp6(vec384fp6 ret, const vec384fp6 a, const vec384fp6 b)
{
    sub_fp2(ret[0], a[0], b[0]);
    sub_fp2(ret[1], a[1], b[1]);
    sub_fp2(ret[2], a[2], b[2]);
}

static void neg_fp6(vec384fp6 ret, const vec384fp6 a)
{
    neg_fp2(ret[0], a[0]);
    neg_fp2(ret[1], a[1]);
    neg_fp2(ret[2], a[2]);
}

#if 0
#define mul_by_v_fp6 mul_by_v_fp6
static void mul_by_v_fp6(vec384fp6 ret, const vec384fp6 a)
{
    vec384x t;

    mul_by_u_fp2(t, a[2]);
    vec_copy(ret[2], a[1], sizeof(a[1]));
    vec_copy(ret[1], a[0], sizeof(a[0]));
    vec_copy(ret[0], t, sizeof(t));
}
#endif

/*
 * Fp12 extension
 */
#if defined(__FP2x2__)
static void mul_fp12(vec384fp12 ret, const vec384fp12 a, const vec384fp12 b)
{
    vec768fp6 t0, t1, rx;
    vec384fp6 t2;

    mul_fp6x2(t0, a[0], b[0]);
    mul_fp6x2(t1, a[1], b[1]);

    /* ret[1] = (a0 + a1)*(b0 + b1) - a0*b0 - a1*b1
              = a0*b1 + a1*b0 */
    add_fp6(t2, a[0], a[1]);
    add_fp6(ret[1], b[0], b[1]);
    mul_fp6x2(rx, ret[1], t2);
    sub_fp6x2(rx, rx, t0);
    sub_fp6x2(rx, rx, t1);
    redc_fp6x2(ret[1], rx);

    /* ret[0] = a0*b0 + a1*b1*v */
#if 0
    mul_by_u_fp2x2(rx[0], t1[2]);
    add_fp2x2(rx[0], t0[0], rx[0]);
#else
    mul_by_5_mod_384x384(rx[0][0], t1[2][1], BLS12_377_P);
    sub_mod_384x384(rx[0][0], t0[0][0], rx[0][0], BLS12_377_P);
    add_mod_384x384(rx[0][1], t0[0][1], t1[2][0], BLS12_377_P);
#endif
    add_fp2x2(rx[1], t0[1], t1[0]);
    add_fp2x2(rx[2], t0[2], t1[1]);
    redc_fp6x2(ret[0], rx);
}

static inline void mul_by_0y0_fp6x2(vec768fp6 ret, const vec384fp6 a,
                                                   const vec384fp2 b)
{
    mul_fp2x2(ret[1], a[2], b);     /* borrow ret[1] for a moment */
    mul_by_u_fp2x2(ret[0], ret[1]);
    mul_fp2x2(ret[1], a[0], b);
    mul_fp2x2(ret[2], a[1], b);
}

static void mul_by_xy0_fp6x2(vec768fp6 ret, const vec384fp6 a,
                                            const vec384fp6 b)
{
    vec768x t0, t1;
    vec384x aa, bb;

    mul_fp2x2(t0, a[0], b[0]);
    mul_fp2x2(t1, a[1], b[1]);

    /* ret[0] = ((a1 + a2)*(b1 + 0) - a1*b1 - a2*0)*u + a0*b0
              = (a1*0 + a2*b1)*u + a0*b0 */
    mul_fp2x2(ret[1], a[2], b[1]);  /* borrow ret[1] for a moment */
#if 0
    mul_by_u_fp2x2(ret[0], ret[1]);
    add_fp2x2(ret[0], ret[0], t0);
#else
    mul_by_5_mod_384x384(ret[0][0], ret[1][1], BLS12_377_P);
    sub_mod_384x384(ret[0][0], t0[0], ret[0][0], BLS12_377_P);
    add_mod_384x384(ret[0][1], t0[1], ret[1][0], BLS12_377_P);
#endif

    /* ret[1] = (a0 + a1)*(b0 + b1) - a0*b0 - a1*b1 + a2*0*u
              = a0*b1 + a1*b0 + a2*0*u */
    add_fp2(aa, a[0], a[1]);
    add_fp2(bb, b[0], b[1]);
    mul_fp2x2(ret[1], aa, bb);
    sub_fp2x2(ret[1], ret[1], t0);
    sub_fp2x2(ret[1], ret[1], t1);

    /* ret[2] = (a0 + a2)*(b0 + 0) - a0*b0 - a2*0 + a1*b1
              = a0*0 + a2*b0 + a1*b1 */
    mul_fp2x2(ret[2], a[2], b[0]);
    add_fp2x2(ret[2], ret[2], t1);
}

static void mul_by_xy00z0_fp12(vec384fp12 ret, const vec384fp12 a,
                                               const vec384fp6 xy00z0)
{
    vec768fp6 t0, t1, rr;
    vec384fp6 t2;

    mul_by_xy0_fp6x2(t0, a[0], xy00z0);
    mul_by_0y0_fp6x2(t1, a[1], xy00z0[2]);

    /* ret[1] = (a0 + a1)*(b0 + b1) - a0*b0 - a1*b1
              = a0*b1 + a1*b0 */
    vec_copy(t2[0], xy00z0[0], sizeof(t2[0]));
    add_fp2(t2[1], xy00z0[1], xy00z0[2]);
    add_fp6(ret[1], a[0], a[1]);
    mul_by_xy0_fp6x2(rr, ret[1], t2);
    sub_fp6x2(rr, rr, t0);
    sub_fp6x2(rr, rr, t1);
    redc_fp6x2(ret[1], rr);

    /* ret[0] = a0*b0 + a1*b1*v */
#if 0
    mul_by_u_fp2x2(rr[0], t1[2]);
    add_fp2x2(rr[0], t0[0], rr[0]);
#else
    mul_by_5_mod_384x384(rr[0][0], t1[2][1], BLS12_377_P);
    sub_mod_384x384(rr[0][0], t0[0][0], rr[0][0], BLS12_377_P);
    add_mod_384x384(rr[0][1], t0[0][1], t1[2][0], BLS12_377_P);
#endif
    add_fp2x2(rr[1], t0[1], t1[0]);
    add_fp2x2(rr[2], t0[2], t1[1]);
    redc_fp6x2(ret[0], rr);
}
#else
static void mul_fp12(vec384fp12 ret, const vec384fp12 a, const vec384fp12 b)
{
    vec384fp6 t0, t1, t2;

    mul_fp6(t0, a[0], b[0]);
    mul_fp6(t1, a[1], b[1]);

    /* ret[1] = (a0 + a1)*(b0 + b1) - a0*b0 - a1*b1
              = a0*b1 + a1*b0 */
    add_fp6(t2, a[0], a[1]);
    add_fp6(ret[1], b[0], b[1]);
    mul_fp6(ret[1], ret[1], t2);
    sub_fp6(ret[1], ret[1], t0);
    sub_fp6(ret[1], ret[1], t1);

    /* ret[0] = a0*b0 + a1*b1*v */
#ifdef mul_by_v_fp6
    mul_by_v_fp6(t1, t1);
    add_fp6(ret[0], t0, t1);
#else
# if 0
    mul_by_u_fp2(t1[2], t1[2]);
    add_fp2(ret[0][0], t0[0], t1[2]);
# else
    mul_by_5_fp(ret[0][0][0], t1[2][1]);
    sub_fp(ret[0][0][0], t0[0][0], ret[0][0][0]);
    add_fp(ret[0][0][1], t0[0][1], t1[2][0]);
# endif
    add_fp2(ret[0][1], t0[1], t1[0]);
    add_fp2(ret[0][2], t0[2], t1[1]);
#endif
}

static inline void mul_by_0y0_fp6(vec384fp6 ret, const vec384fp6 a,
                                                 const vec384fp2 b)
{
    vec384x t;

    mul_fp2(t,      a[2], b);
    mul_fp2(ret[2], a[1], b);
    mul_fp2(ret[1], a[0], b);
    mul_by_u_fp2(ret[0], t);
}

static void mul_by_xy0_fp6(vec384fp6 ret, const vec384fp6 a, const vec384fp6 b)
{
    vec384x t0, t1, /*t2,*/ t3, t4, t5;

    mul_fp2(t0, a[0], b[0]);
    mul_fp2(t1, a[1], b[1]);

    /* ret[0] = ((a1 + a2)*(b1 + 0) - a1*b1 - a2*0)*(u+1) + a0*b0
              = (a1*0 + a2*b1)*(u+1) + a0*b0 */
    mul_fp2(t3, a[2], b[1]);
    /* mul_by_u_fp2(t3, t3);
     * add_fp2(ret[0], t3, t0); considering possible aliasing... */

    /* ret[1] = (a0 + a1)*(b0 + b1) - a0*b0 - a1*b1 + a2*0*(u+1)
              = a0*b1 + a1*b0 + a2*0*(u+1) */
    add_fp2(t4, a[0], a[1]);
    add_fp2(t5, b[0], b[1]);
    mul_fp2(ret[1], t4, t5);
    sub_fp2(ret[1], ret[1], t0);
    sub_fp2(ret[1], ret[1], t1);

    /* ret[2] = (a0 + a2)*(b0 + 0) - a0*b0 - a2*0 + a1*b1
              = a0*0 + a2*b0 + a1*b1 */
    mul_fp2(ret[2], a[2], b[0]);
    add_fp2(ret[2], ret[2], t1);

#if 0
    mul_by_u_fp2(t3, t3);       /* ... moved from above */
    add_fp2(ret[0], t3, t0);
#else
    mul_by_5_fp(ret[0][0], t3[1]);
    sub_fp(ret[0][0], t0[0], ret[0][0]);
    add_fp(ret[0][1], t0[1], t3[0]);
#endif
}

static void mul_by_xy00z0_fp12(vec384fp12 ret, const vec384fp12 a,
                                               const vec384fp6 xy00z0)
{
    vec384fp6 t0, t1, t2;

    mul_by_xy0_fp6(t0, a[0], xy00z0);
    mul_by_0y0_fp6(t1, a[1], xy00z0[2]);

    /* ret[1] = (a0 + a1)*(b0 + b1) - a0*b0 - a1*b1
              = a0*b1 + a1*b0 */
    vec_copy(t2[0], xy00z0[0], sizeof(t2[0]));
    add_fp2(t2[1], xy00z0[1], xy00z0[2]);
    add_fp6(ret[1], a[0], a[1]);
    mul_by_xy0_fp6(ret[1], ret[1], t2);
    sub_fp6(ret[1], ret[1], t0);
    sub_fp6(ret[1], ret[1], t1);

    /* ret[0] = a0*b0 + a1*b1*v */
#ifdef mul_by_v_fp6
    mul_by_v_fp6(t1, t1);
    add_fp6(ret[0], t0, t1);
#else
# if 0
    mul_by_u_fp2(t1[2], t1[2]);
    add_fp2(ret[0][0], t0[0], t1[2]);
# else
    mul_by_5_fp(ret[0][0][0], t1[2][1]);
    sub_fp(ret[0][0][0], t0[0][0], ret[0][0][0]);
    add_fp(ret[0][0][1], t0[0][1], t1[2][0]);
# endif
    add_fp2(ret[0][1], t0[1], t1[0]);
    add_fp2(ret[0][2], t0[2], t1[1]);
#endif
}
#endif

static void sqr_fp12(vec384fp12 ret, const vec384fp12 a)
{
    vec384fp6 t0, t1;

    add_fp6(t0, a[0], a[1]);
#ifdef mul_by_v_fp6
    mul_by_v_fp6(t1, a[1]);
    add_fp6(t1, a[0], t1);
#else
# if 0
    mul_by_u_fp2(t1[2], a[1][2]);
    add_fp2(t1[0], a[0][0], t1[2]);
# else
    mul_by_5_fp(t1[0][0], a[1][2][1]);
    sub_fp(t1[0][0], a[0][0][0], t1[0][0]);
    add_fp(t1[0][1], a[0][0][1], a[1][2][0]);
# endif
    add_fp2(t1[1], a[0][1], a[1][0]);
    add_fp2(t1[2], a[0][2], a[1][1]);
#endif
    mul_fp6(t0, t0, t1);
    mul_fp6(t1, a[0], a[1]);

    /* ret[1] = 2*(a0*a1) */
    add_fp6(ret[1], t1, t1);

    /* ret[0] = (a0 + a1)*(a0 + a1*v) - a0*a1 - a0*a1*v
              = a0^2 + a1^2*v */
    sub_fp6(ret[0], t0, t1);
#ifdef mul_by_v_fp6
    mul_by_v_fp6(t1, t1);
    sub_fp6(ret[0], ret[0], t1);
#else
# if 0
    mul_by_u_fp2(t1[2], t1[2]);
    sub_fp2(ret[0][0], ret[0][0], t1[2]);
# else
    mul_by_5_fp(t1[2][1], t1[2][1]);
    add_fp(ret[0][0][0], ret[0][0][0], t1[2][1]);
    sub_fp(ret[0][0][1], ret[0][0][1], t1[2][0]);
# endif
    sub_fp2(ret[0][1], ret[0][1], t1[0]);
    sub_fp2(ret[0][2], ret[0][2], t1[1]);
#endif
}

static void conjugate_fp12(vec384fp12 a)
{   neg_fp6(a[1], a[1]);   }

static void inverse_fp6(vec384fp6 ret, const vec384fp6 a)
{
    vec384x c0, c1, c2, t0, t1;

    /* c0 = a0^2 - (a1*a2)*u */
    sqr_fp2(c0, a[0]);
    mul_fp2(t0, a[1], a[2]);
    mul_by_u_fp2(t0, t0);
    sub_fp2(c0, c0, t0);

    /* c1 = a2^2*u - (a0*a1) */
    sqr_fp2(c1, a[2]);
    mul_by_u_fp2(c1, c1);
    mul_fp2(t0, a[0], a[1]);
    sub_fp2(c1, c1, t0);

    /* c2 = a1^2 - a0*a2 */
    sqr_fp2(c2, a[1]);
    mul_fp2(t0, a[0], a[2]);
    sub_fp2(c2, c2, t0);

    /* (a2*c1 + a1*c2)*u + a0*c0 */
    mul_fp2(t0, c1, a[2]);
    mul_fp2(t1, c2, a[1]);
    add_fp2(t0, t0, t1);
    mul_by_u_fp2(t0, t0);
    mul_fp2(t1, c0, a[0]);
    add_fp2(t0, t0, t1);

    inverse_fp2(t1, t0);

    mul_fp2(ret[0], c0, t1);
    mul_fp2(ret[1], c1, t1);
    mul_fp2(ret[2], c2, t1);
}

static void inverse_fp12(vec384fp12 ret, const vec384fp12 a)
{
    vec384fp6 t0, t1;

    sqr_fp6(t0, a[0]);
    sqr_fp6(t1, a[1]);
#ifdef mul_by_v_fp6
    mul_by_v_fp6(t1, t1);
    sub_fp6(t0, t0, t1);
#else
# if 0
    mul_by_u_fp2(t1[2], t1[2]);
    sub_fp2(t0[0], t0[0], t1[2]);
# else
    mul_by_5_fp(t1[2][1], t1[2][1]);
    add_fp(t0[0][0], t0[0][0], t1[2][1]);
    sub_fp(t0[0][1], t0[0][1], t1[2][0]);
# endif
    sub_fp2(t0[1], t0[1], t1[0]);
    sub_fp2(t0[2], t0[2], t1[1]);
#endif

    inverse_fp6(t1, t0);

    mul_fp6(ret[0], a[0], t1);
    mul_fp6(ret[1], a[1], t1);
    neg_fp6(ret[1], ret[1]);
}

typedef vec384x vec384fp4[2];

#if defined(__FP2x2__)
static void sqr_fp4(vec384fp4 ret, const vec384x a0, const vec384x a1)
{
    vec768x t0, t1, t2;

    sqr_fp2x2(t0, a0);
    sqr_fp2x2(t1, a1);
    add_fp2(ret[1], a0, a1);

#if 0
    mul_by_u_fp2x2(t2, t1);
    add_fp2x2(t2, t2, t0);
#else
    mul_by_5_mod_384x384(t2[0], t1[1], BLS12_377_P);
    sub_mod_384x384(t2[0], t0[0], t2[0], BLS12_377_P);
    add_mod_384x384(t2[1], t0[1], t1[0], BLS12_377_P);
#endif
    redc_fp2x2(ret[0], t2);

    sqr_fp2x2(t2, ret[1]);
    sub_fp2x2(t2, t2, t0);
    sub_fp2x2(t2, t2, t1);
    redc_fp2x2(ret[1], t2);
}
#else
static void sqr_fp4(vec384fp4 ret, const vec384x a0, const vec384x a1)
{
    vec384x t0, t1;

    sqr_fp2(t0, a0);
    sqr_fp2(t1, a1);
    add_fp2(ret[1], a0, a1);

#if 0
    mul_by_u_fp2(ret[0], t1);
    add_fp2(ret[0], ret[0], t0);
#else
    mul_by_5_fp(ret[0][0], t1[1]);
    sub_fp(ret[0][0], t0[0], ret[0][0]);
    add_fp(ret[0][1], t0[1], t1[0]);
#endif

    sqr_fp2(ret[1], ret[1]);
    sub_fp2(ret[1], ret[1], t0);
    sub_fp2(ret[1], ret[1], t1);
}
#endif

static void cyclotomic_sqr_fp12(vec384fp12 ret, const vec384fp12 a)
{
    vec384fp4 t0, t1, t2;

    sqr_fp4(t0, a[0][0], a[1][1]);
    sqr_fp4(t1, a[1][0], a[0][2]);
    sqr_fp4(t2, a[0][1], a[1][2]);

    sub_fp2(ret[0][0], t0[0],     a[0][0]);
    add_fp2(ret[0][0], ret[0][0], ret[0][0]);
    add_fp2(ret[0][0], ret[0][0], t0[0]);

    sub_fp2(ret[0][1], t1[0],     a[0][1]);
    add_fp2(ret[0][1], ret[0][1], ret[0][1]);
    add_fp2(ret[0][1], ret[0][1], t1[0]);

    sub_fp2(ret[0][2], t2[0],     a[0][2]);
    add_fp2(ret[0][2], ret[0][2], ret[0][2]);
    add_fp2(ret[0][2], ret[0][2], t2[0]);

    mul_by_u_fp2(t2[1], t2[1]);
    add_fp2(ret[1][0], t2[1],     a[1][0]);
    add_fp2(ret[1][0], ret[1][0], ret[1][0]);
    add_fp2(ret[1][0], ret[1][0], t2[1]);

    add_fp2(ret[1][1], t0[1],     a[1][1]);
    add_fp2(ret[1][1], ret[1][1], ret[1][1]);
    add_fp2(ret[1][1], ret[1][1], t0[1]);

    add_fp2(ret[1][2], t1[1],     a[1][2]);
    add_fp2(ret[1][2], ret[1][2], ret[1][2]);
    add_fp2(ret[1][2], ret[1][2], t1[1]);
}

/*
 * caveat lector! |n| has to be non-zero and not more than 3!
 */
static inline void frobenius_map_fp2(vec384x ret, const vec384x a, size_t n)
{
    vec_copy(ret[0], a[0], sizeof(ret[0]));
    cneg_fp(ret[1], a[1], n & 1);
}

static inline void mul_fp2_by_fp(vec384x ret, const vec384x a, const vec384 b)
{
    mul_fp(ret[0], a[0], b);
    mul_fp(ret[1], a[1], b);
}

static void frobenius_map_fp6(vec384fp6 ret, const vec384fp6 a, size_t n)
{
    static const vec384 coeffs1[] = {   /* u^((P^n - 1) / 3) */
      {   TO_LIMB_T(0x5892506da58478da), TO_LIMB_T(0x133366940ac2a74b),
          TO_LIMB_T(0x9b64a150cdf726cf), TO_LIMB_T(0x5cc426090a9c587e),
          TO_LIMB_T(0x5cf848adfdcd640c), TO_LIMB_T(0x004702bf3ac02380)   },
      {   TO_LIMB_T(0xdacd106da5847973), TO_LIMB_T(0xd8fe2454bac2a79a),
          TO_LIMB_T(0x1ada4fd6fd832edc), TO_LIMB_T(0xfb9868449d150908),
          TO_LIMB_T(0xd63eb8aeea32285e), TO_LIMB_T(0x0167d6a36f873fd0)   },
      {   TO_LIMB_T(0x823ac00000000099), TO_LIMB_T(0xc5cabdc0b000004f),
          TO_LIMB_T(0x7f75ae862f8c080d), TO_LIMB_T(0x9ed4423b9278b089),
          TO_LIMB_T(0x79467000ec64c452), TO_LIMB_T(0x0120d3e434c71c50)   }
    };
    static const vec384 coeffs2[] = {   /* u^((2P^n - 2) / 3) */
      {   TO_LIMB_T(0xdacd106da5847973), TO_LIMB_T(0xd8fe2454bac2a79a),
          TO_LIMB_T(0x1ada4fd6fd832edc), TO_LIMB_T(0xfb9868449d150908),
          TO_LIMB_T(0xd63eb8aeea32285e), TO_LIMB_T(0x0167d6a36f873fd0)   },
      {   TO_LIMB_T(0x2c766f925a7b8727), TO_LIMB_T(0x03d7f6b0253d58b5),
          TO_LIMB_T(0x838ec0deec122131), TO_LIMB_T(0xbd5eb3e9f658bb10),
          TO_LIMB_T(0x6942bd126ed3e52e), TO_LIMB_T(0x01673786dd04ed6a)   },
      {   TO_LIMB_T(0x02cdffffffffff68), TO_LIMB_T(0x51409f837fffffb1),
          TO_LIMB_T(0x9f7db3a98a7d3ff2), TO_LIMB_T(0x7b4e97b76e7c6305),
          TO_LIMB_T(0x4cf495bf803c84e8), TO_LIMB_T(0x008d6661e2fdf49a)   }
    };

    frobenius_map_fp2(ret[0], a[0], n);
    frobenius_map_fp2(ret[1], a[1], n);
    frobenius_map_fp2(ret[2], a[2], n);
    --n;    /* implied ONE_MONT_P at index 0 */
    mul_fp2_by_fp(ret[1], ret[1], coeffs1[n]);
    mul_fp2_by_fp(ret[2], ret[2], coeffs2[n]);
}

static void frobenius_map_fp12(vec384fp12 ret, const vec384fp12 a, size_t n)
{
    static const vec384 coeffs[] = {    /* u^((P^n - 1) / 6) */
      {   TO_LIMB_T(0x6ec47a04a3f7ca9e), TO_LIMB_T(0xa42e0cb968c1fa44),
          TO_LIMB_T(0x578d5187fbd2bd23), TO_LIMB_T(0x930eeb0ac79dd4bd),
          TO_LIMB_T(0xa24883de1e09a9ee), TO_LIMB_T(0x00daa7058067d46f)   },
      {   TO_LIMB_T(0x5892506da58478da), TO_LIMB_T(0x133366940ac2a74b),
          TO_LIMB_T(0x9b64a150cdf726cf), TO_LIMB_T(0x5cc426090a9c587e),
          TO_LIMB_T(0x5cf848adfdcd640c), TO_LIMB_T(0x004702bf3ac02380)   },
      {   TO_LIMB_T(0x982c13d9d084771f), TO_LIMB_T(0xfd49de0c6da34a32),
          TO_LIMB_T(0x61a530d183ab0e53), TO_LIMB_T(0xdf8fe44106dd9879),
          TO_LIMB_T(0x40f29b58d88472bc), TO_LIMB_T(0x0158723199046d5d)   }
    };

    frobenius_map_fp6(ret[0], a[0], n);
    frobenius_map_fp6(ret[1], a[1], n);
    --n;    /* implied ONE_MONT_P at index 0 */
    mul_fp2_by_fp(ret[1][0], ret[1][0], coeffs[n]);
    mul_fp2_by_fp(ret[1][1], ret[1][1], coeffs[n]);
    mul_fp2_by_fp(ret[1][2], ret[1][2], coeffs[n]);
}


/*
 * BLS12-377-specifc Fp12 shortcuts.
 */
void blst_fp12_377_sqr(vec384fp12 ret, const vec384fp12 a)
{   sqr_fp12(ret, a);   }

void blst_fp12_377_cyclotomic_sqr(vec384fp12 ret, const vec384fp12 a)
{   cyclotomic_sqr_fp12(ret, a);   }

void blst_fp12_377_mul(vec384fp12 ret, const vec384fp12 a, const vec384fp12 b)
{   mul_fp12(ret, a, b);   }

void blst_fp12_377_mul_by_xy00z0(vec384fp12 ret, const vec384fp12 a,
                                                 const vec384fp6 xy00z0)
{   mul_by_xy00z0_fp12(ret, a, xy00z0);   }

void blst_fp12_377_conjugate(vec384fp12 a)
{   conjugate_fp12(a);   }

void blst_fp12_377_inverse(vec384fp12 ret, const vec384fp12 a)
{   inverse_fp12(ret, a);   }

/* caveat lector! |n| has to be non-zero and not more than 3! */
void blst_fp12_377_frobenius_map(vec384fp12 ret, const vec384fp12 a, size_t n)
{   frobenius_map_fp12(ret, a, n);   }

int blst_fp12_377_is_one(const vec384fp12 a)
{
    return (int)(vec_is_equal(a[0][0], BLS12_377_Rx.p2, sizeof(a[0][0])) &
                 vec_is_zero(a[0][1], sizeof(vec384fp12) - sizeof(a[0][0])));
}

const vec384fp12 *blst_fp12_377_one(void)
{   return (const vec384fp12 *)BLS12_377_Rx.p12;   }
