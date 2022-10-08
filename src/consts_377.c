/*
 * Copyright Supranational LLC
 * Licensed under the Apache License, Version 2.0, see LICENSE for details.
 * SPDX-License-Identifier: Apache-2.0
 */

#include "consts_377.h"

/* z = 0x8508c00000000001 */
const vec384 BLS12_377_P = {    /* (z^6 - 2*z^5 + 2*z^3 + z + 1)/3 */
    TO_LIMB_T(0x8508c00000000001), TO_LIMB_T(0x170b5d4430000000),
    TO_LIMB_T(0x1ef3622fba094800), TO_LIMB_T(0x1a22d9f300f5138f),
    TO_LIMB_T(0xc63b05c06ca1493b), TO_LIMB_T(0x01ae3a4617c510ea)
};
const limb_t BLS12_377_p0 = (limb_t)0x8508bfffffffffff;  /* -1/P */

const radix384 BLS12_377_Rx = { /* (1<<384)%P, "radix", one-in-Montgomery */
  { { ONE_MONT_P },
    { 0 } }
};

const vec384 BLS12_377_RR = {   /* (1<<768)%P, "radix"^2, to-Montgomery */
    TO_LIMB_T(0xb786686c9400cd22), TO_LIMB_T(0x0329fcaab00431b1),
    TO_LIMB_T(0x22a5f11162d6b46d), TO_LIMB_T(0xbfdf7d03827dc3ac),
    TO_LIMB_T(0x837e92f041790bf9), TO_LIMB_T(0x006dfccb1e914b88)
};

const vec256 BLS12_377_r = {    /* z^4 - z^2 + 1, group order */
    TO_LIMB_T(0x0a11800000000001), TO_LIMB_T(0x59aa76fed0000001),
    TO_LIMB_T(0x60b44d1e5c37b001), TO_LIMB_T(0x12ab655e9a2ca556)
};

const vec256 BLS12_377_rRR = {  /* (1<<512)%r, "radix"^2, to-Montgomery */
    TO_LIMB_T(0x25d577bab861857b), TO_LIMB_T(0xcc2c27b58860591f),
    TO_LIMB_T(0xa7cc008fe5dc8593), TO_LIMB_T(0x011fdae7eff1c939)
};
