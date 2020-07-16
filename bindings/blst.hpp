/*
 * Copyright Supranational LLC
 * Licensed under the Apache License, Version 2.0, see LICENSE for details.
 * SPDX-License-Identifier: Apache-2.0
 */
#ifndef __BLST_HPP__
#define __BLST_HPP__

#include "blst.h"

#include <string>

#if __cplusplus >= 201703L
# include <string_view>
# ifndef app__string_view
#  define app__string_view std::string_view // std::basic_string_view<byte>
# endif
#endif

#if __cplusplus < 201103L
# ifdef __GNUG__
#  define nullptr __null
# else
#  define nullptr 0
# endif
#endif

namespace blst {

class P1_Affine;
class P1;
class P2_Affine;
class P2;
class Pairing;

/*
 * As for SecretKey being struct and not class, and lack of constructors
 * with one accepting for example |IKM|. We can't make assumptions about
 * application's policy toward handling secret key material. Hence it's
 * argued that application is entitled for transparent structure, not
 * opaque or semi-opaque class. And in the context it's appropriate not
 * to "entice" developers with idiomatic constructors:-) Though this
 * doesn't really apply to SWIG-assisted interfaces...
 */
struct SecretKey {
    blst_scalar key;

    void keygen(const byte* IKM, size_t IKM_len,
                const std::string* info = nullptr)
    {   if (info == nullptr)
            blst_keygen(&key, IKM, IKM_len, nullptr, 0);
        else
            blst_keygen(&key, IKM, IKM_len,
                        reinterpret_cast<const byte *>(info->data()),
                        info->size());
    }
#if __cplusplus >= 201703L
    void keygen(const app__string_view IKM, // string_view by value, cool!
                const std::string* info = nullptr)
    {   keygen(reinterpret_cast<const byte *>(IKM.data()),
               IKM.size(), info);
    }
#endif
    void from_bendian(const byte in[32]) { blst_scalar_from_bendian(&key, in); }
    void from_lendian(const byte in[32]) { blst_scalar_from_lendian(&key, in); }

    void to_bendian(byte out[32]) const { blst_bendian_from_scalar(out, &key); }
    void to_lendian(byte out[32]) const { blst_lendian_from_scalar(out, &key); }
};

class P1_Affine {
private:
    blst_p1_affine point;

public:
    P1_Affine() {}
    P1_Affine(const byte *in)
    {   BLST_ERROR err = blst_p1_deserialize(&point, in);
        if (err != BLST_SUCCESS)
            throw err;
    }
    P1_Affine(const P1& jacobian);

    void serialize(byte out[96]) const
    {   blst_p1_affine_serialize(out, &point);   }
    void compress(byte out[48]) const
    {   blst_p1_affine_compress(out, &point);   }
    bool on_curve() const { return blst_p1_affine_on_curve(&point); }
    bool in_group() const { return blst_p1_affine_in_g1(&point);    }
    BLST_ERROR core_verify(const P2_Affine& pk, bool hash_or_encode,
                           const byte* msg, size_t msg_len,
                           const std::string* DST = nullptr,
                           const byte* aug = nullptr, size_t aug_len = 0) const;
#if __cplusplus >= 201703L
    BLST_ERROR core_verify(const P2_Affine& pk, bool hash_or_encode,
                           const app__string_view msg,
                           const std::string* DST = nullptr,
                           const app__string_view* aug = nullptr) const;
#endif

private:
    friend class Pairing;
    friend class P2_Affine;
    operator const blst_p1_affine*() const { return &point; }
};

class P1 {
private:
    blst_p1 point;

public:
    P1() {}
    P1(SecretKey& sk) { blst_sk_to_pk_in_g1(&point, &sk.key); }
    P1(const byte *in)
    {   blst_p1_affine a;
        BLST_ERROR err = blst_p1_deserialize(&a, in);
        if (err != BLST_SUCCESS)
            throw err;
        blst_p1_from_affine(&point, &a);
    }

    P1_Affine to_affine() const         { P1_Affine ret(*this); return ret;  }
    void serialize(byte out[96]) const  { blst_p1_serialize(out, &point);    }
    void compress(byte out[48]) const   { blst_p1_compress(out, &point);     }
    P1* sign_with(SecretKey& sk)
    {   blst_p1_mult(&point, &point, &sk.key, 255); return this;   }
    P1* hash_to(const byte* msg, size_t msg_len,
                const std::string* DST = nullptr,
                const byte* aug = nullptr, size_t aug_len = 0)
    {   if (DST == nullptr)
            blst_hash_to_g1(&point, msg, msg_len, nullptr, 0, nullptr, 0);
        else
            blst_hash_to_g1(&point, msg, msg_len,
                            reinterpret_cast<const byte *>(DST->data()),
                            DST->size(), aug, aug_len);
        return this;
    }
    P1* encode_to(const byte* msg, size_t msg_len,
                  const std::string* DST = nullptr,
                  const byte* aug = nullptr, size_t aug_len = 0)
    {   if (DST == nullptr)
            blst_encode_to_g1(&point, msg, msg_len, nullptr, 0, nullptr, 0);
        else
            blst_encode_to_g1(&point, msg, msg_len,
                              reinterpret_cast<const byte *>(DST->data()),
                              DST->size(), aug, aug_len);
        return this;
    }
#if __cplusplus >= 201703L
    P1* hash_to(const app__string_view msg, const std::string* DST = nullptr,
                const app__string_view* aug = nullptr)
    {   if (aug == nullptr)
            return hash_to(reinterpret_cast<const byte *>(msg.data()),
                           msg.size(), DST, nullptr, 0);
        else
            return hash_to(reinterpret_cast<const byte *>(msg.data()),
                           msg.size(), DST,
                           reinterpret_cast<const byte *>(aug->data()),
                           aug->size());
    }
    P1* encode_to(const app__string_view msg, const std::string* DST = nullptr,
                  const app__string_view* aug = nullptr)
    {   if (aug == nullptr)
            return encode_to(reinterpret_cast<const byte *>(msg.data()),
                             msg.size(), DST, nullptr, 0);
        else
            return encode_to(reinterpret_cast<const byte *>(msg.data()),
                             msg.size(), DST,
                             reinterpret_cast<const byte *>(aug->data()),
                             aug->size());
    }
#endif

private:
    friend class P1_Affine;
    operator const blst_p1*() const { return &point; }
};

class P2_Affine {
private:
    blst_p2_affine point;

public:
    P2_Affine() {}
    P2_Affine(const byte *in)
    {   BLST_ERROR err = blst_p2_deserialize(&point, in);
        if (err != BLST_SUCCESS)
            throw err;
    }
    P2_Affine(const P2& jacobian);

    void serialize(byte out[192]) const
    {   blst_p2_affine_serialize(out, &point);   }
    void compress(byte out[96]) const
    {   blst_p2_affine_compress(out, &point);   }
    bool on_curve() const { return blst_p2_affine_on_curve(&point); }
    bool in_group() const { return blst_p2_affine_in_g2(&point);    }
    BLST_ERROR core_verify(const P1_Affine& pk, bool hash_or_encode,
                           const byte* msg, size_t msg_len,
                           const std::string* DST = nullptr,
                           const byte* aug = nullptr, size_t aug_len = 0) const;
#if __cplusplus >= 201703L
    BLST_ERROR core_verify(const P1_Affine& pk, bool hash_or_encode,
                           const app__string_view msg,
                           const std::string* DST = nullptr,
                           const app__string_view* aug = nullptr) const;
#endif

private:
    friend class Pairing;
    friend class P1_Affine;
    operator const blst_p2_affine*() const { return &point; }
};

class P2 {
private:
    blst_p2 point;

public:
    P2() {}
    P2(SecretKey& sk) { blst_sk_to_pk_in_g2(&point, &sk.key); }
    P2(const byte *in)
    {   blst_p2_affine a;
        BLST_ERROR err = blst_p2_deserialize(&a, in);
        if (err != BLST_SUCCESS)
            throw err;
        blst_p2_from_affine(&point, &a);
    }

    P2_Affine to_affine() const         { P2_Affine ret(*this); return ret; }
    void serialize(byte out[192]) const { blst_p2_serialize(out, &point);   }
    void compress(byte out[96]) const   { blst_p2_compress(out, &point);    }
    P2* sign_with(SecretKey& sk)
    {   blst_p2_mult(&point, &point, &sk.key, 255); return this;   }
    P2* hash_to(const byte* msg, size_t msg_len,
                const std::string* DST = nullptr,
                const byte* aug = nullptr, size_t aug_len = 0)
    {   if (DST == nullptr)
            blst_hash_to_g2(&point, msg, msg_len, nullptr, 0, nullptr, 0);
        else
            blst_hash_to_g2(&point, msg, msg_len,
                            reinterpret_cast<const byte *>(DST->data()),
                            DST->size(), aug, aug_len);
        return this;
    }
    P2* encode_to(const byte* msg, size_t msg_len,
                  const std::string* DST = nullptr,
                  const byte* aug = nullptr, size_t aug_len = 0)
    {   if (DST == nullptr)
            blst_encode_to_g2(&point, msg, msg_len, nullptr, 0, nullptr, 0);
        else
            blst_encode_to_g2(&point, msg, msg_len,
                              reinterpret_cast<const byte *>(DST->data()),
                              DST->size(), aug, aug_len);
        return this;
    }
#if __cplusplus >= 201703L
    P2* hash_to(const app__string_view msg, const std::string* DST = nullptr,
                 const app__string_view* aug = nullptr)
    {   if (aug == nullptr)
            return hash_to(reinterpret_cast<const byte *>(msg.data()),
                           msg.size(), DST, nullptr, 0);
        else
            return hash_to(reinterpret_cast<const byte *>(msg.data()),
                           msg.size(), DST,
                           reinterpret_cast<const byte *>(aug->data()),
                           aug->size());
    }
    P2* encode_to(const app__string_view msg, const std::string* DST = nullptr,
                  const app__string_view* aug = nullptr)
    {   if (aug == nullptr)
            return encode_to(reinterpret_cast<const byte *>(msg.data()),
                             msg.size(), DST, nullptr, 0);
        else
            return encode_to(reinterpret_cast<const byte *>(msg.data()),
                             msg.size(), DST,
                             reinterpret_cast<const byte *>(aug->data()),
                             aug->size());
    }
#endif

private:
    friend class P2_Affine;
    operator const blst_p2*() const { return &point; }
};

inline P1_Affine::P1_Affine(const P1& jacobian)
{   blst_p1_to_affine(&point, jacobian);   }
inline P2_Affine::P2_Affine(const P2& jacobian)
{   blst_p2_to_affine(&point, jacobian);   }

inline BLST_ERROR P1_Affine::core_verify(const P2_Affine& pk,
                                         bool hash_or_encode,
                                         const byte* msg, size_t msg_len,
                                         const std::string* DST,
                                         const byte* aug, size_t aug_len) const
{   if (DST == nullptr)
        return blst_core_verify_pk_in_g2(pk, &point, hash_or_encode,
                                msg, msg_len, nullptr, 0, nullptr, 0);
    else
        return blst_core_verify_pk_in_g2(pk, &point, hash_or_encode,
                                msg, msg_len,
                                reinterpret_cast<const byte *>(DST->data()),
                                DST->size(), aug, aug_len);
}
inline BLST_ERROR P2_Affine::core_verify(const P1_Affine& pk,
                                         bool hash_or_encode,
                                         const byte* msg, size_t msg_len,
                                         const std::string* DST,
                                         const byte* aug, size_t aug_len) const
{   if (DST == nullptr)
        return blst_core_verify_pk_in_g1(pk, &point, hash_or_encode,
                                msg, msg_len, nullptr, 0, nullptr, 0);
    else
        return blst_core_verify_pk_in_g1(pk, &point, hash_or_encode,
                                msg, msg_len,
                                reinterpret_cast<const byte *>(DST->data()),
                                DST->size(), aug, aug_len);
}
#if __cplusplus >= 201703L
inline BLST_ERROR P1_Affine::core_verify(const P2_Affine& pk,
                                         bool hash_or_encode,
                                         const app__string_view msg,
                                         const std::string* DST,
                                         const app__string_view* aug) const
{   if (aug == nullptr)
        return core_verify(pk, hash_or_encode,
                           reinterpret_cast<const byte *>(msg.data()),
                           msg.size(), DST, nullptr, 0);
    else
        return core_verify(pk, hash_or_encode,
                           reinterpret_cast<const byte *>(msg.data()),
                           msg.size(), DST,
                           reinterpret_cast<const byte *>(aug->data()),
                           aug->size());
}
inline BLST_ERROR P2_Affine::core_verify(const P1_Affine& pk,
                                         bool hash_or_encode,
                                         const app__string_view msg,
                                         const std::string* DST,
                                         const app__string_view* aug) const
{   if (aug == nullptr)
        return core_verify(pk, hash_or_encode,
                           reinterpret_cast<const byte *>(msg.data()),
                           msg.size(), DST, nullptr, 0);
    else
        return core_verify(pk, hash_or_encode,
                           reinterpret_cast<const byte *>(msg.data()),
                           msg.size(), DST,
                           reinterpret_cast<const byte *>(aug->data()),
                           aug->size());
}
#endif

class Pairing {
private:
    operator blst_pairing*()
    {   return reinterpret_cast<blst_pairing *>(this);   }
    operator const blst_pairing*() const
    {   return reinterpret_cast<const blst_pairing *>(this);   }

public:
#ifndef SWIG
    void* operator new(size_t)
    {   return new uint64_t[blst_pairing_sizeof()/sizeof(uint64_t)];  }
#endif
    Pairing(bool hash_or_encode, std::string DST)
    {   init(hash_or_encode, DST);   }

    void init(bool hash_or_encode, std::string DST)
    {   blst_pairing_init(*this, hash_or_encode,
                          reinterpret_cast<const byte *>(DST.data()),
                          DST.size());
    }
    BLST_ERROR aggregate(const P1_Affine* pk, const P2_Affine* sig,
                         const byte* msg, size_t msg_len,
                         const byte* aug = nullptr, size_t aug_len = 0)
    {   return blst_pairing_aggregate_pk_in_g1(*this, *pk, *sig,
                         msg, msg_len, aug, aug_len);
    }
    BLST_ERROR aggregate(const P2_Affine* pk, const P1_Affine* sig,
                         const byte* msg, size_t msg_len,
                         const byte* aug = nullptr, size_t aug_len = 0)
    {   return blst_pairing_aggregate_pk_in_g2(*this, *pk, *sig,
                         msg, msg_len, aug, aug_len);
    }
#if __cplusplus >= 201703L
    BLST_ERROR aggregate(const P1_Affine* pk, const P2_Affine* sig,
                         const app__string_view msg,
                         const app__string_view* aug = nullptr)
    {   if (aug == nullptr)
            return aggregate(pk, sig,
                             reinterpret_cast<const byte *>(msg.data()),
                             msg.size(), nullptr, 0);
        else
            return aggregate(pk, sig,
                             reinterpret_cast<const byte *>(msg.data()),
                             msg.size(),
                             reinterpret_cast<const byte *>(aug->data()),
                             aug->size());
    }
    BLST_ERROR aggregate(const P2_Affine* pk, const P1_Affine* sig,
                         const app__string_view msg,
                         const app__string_view* aug = nullptr)
    {   if (aug == nullptr)
            return aggregate(pk, sig,
                             reinterpret_cast<const byte *>(msg.data()),
                             msg.size(), nullptr, 0);
        else
            return aggregate(pk, sig,
                             reinterpret_cast<const byte *>(msg.data()),
                             msg.size(),
                             reinterpret_cast<const byte *>(aug->data()),
                             aug->size());
    }
#endif
    void commit()
    {   blst_pairing_commit(*this);   }
    BLST_ERROR merge(const Pairing* ctx)
    {   return blst_pairing_merge(*this, *ctx);   }
    bool finalverify(const blst_fp12* sig = nullptr) const
    {   return blst_pairing_finalverify(*this, sig);   }
};

class Fp12 {
private:
    blst_fp12 value;

public:
    Fp12() {}
};

} // namespace blst

#endif
