#include <iostream>
using namespace std;

#include <cuda.h>
#include <stdio.h>

extern "C" {
#include "consts.c"

#include "point.h"
#include "fields.h"

#include "ec_ops.h"
POINT_DADD_IMPL(POINTonE1, 384, fp)
POINT_DADD_AFFINE_IMPL_A0(POINTonE1, 384, fp, BLS12_381_Rx.p)
POINT_ADD_IMPL(POINTonE1, 384, fp)
POINT_ADD_AFFINE_IMPL(POINTonE1, 384, fp, BLS12_381_Rx.p)
POINT_DOUBLE_IMPL_A0(POINTonE1, 384, fp)
POINT_IS_EQUAL_IMPL(POINTonE1, 384, fp)
}

class Vec384 {
    vec384 v;

public:
    Vec384& operator=(const vec384 a) {
        vec_copy(v, a, sizeof(v));
        return *this;
    }

    __host__ __device__ operator const vec384&() const { return v; }
    __host__ __device__ operator void*() { return v; }

    friend ostream& operator<<(ostream& os, Vec384& obj) {
        char buf[6*16+1], *str=buf; 
        for (int i=6; i > 0; str+=16)
            (void)snprintf(str, 17, "%016llx", obj.v[--i]);
        return os << "0x" << buf;
    }
};

__device__ uint32_t times[12];

__global__ void kernel(Vec384 in[])
{
    vec384 a, b, c;
    vec768 d;

    vec_load_global(a, in[1], sizeof(a));
    vec_load_global(b, in[2], sizeof(b));

    vec_select(c, a, b, sizeof(c), 1);

    // warm up caches
    mul_384(d, a, b);
    sqr_384(d, a);
    redc_fp(c, d);

    mul_fp(c, c, b);
    sqr_fp(c, a);
    lshift_fp(c, c, 1);
    rshift_fp(c, c, 1);
    //mul_by_3_fp(c, c);
    add_fp(c, a, b);
    sub_fp(c, c, b);

    uint32_t start, end;

    asm volatile("mov.u32 %0, %%clock;" : "=r"(start));
    add_fp(c, a, b);
    asm volatile("mov.u32 %0, %%clock;" : "=r"(end));
    if (threadIdx.x == 0) times[0] = end - start;

    asm volatile("mov.u32 %0, %%clock;" : "=r"(start));
    sub_fp(c, c, b);
    asm volatile("mov.u32 %0, %%clock;" : "=r"(end));
    if (threadIdx.x == 0) times[1] = end - start;

    asm volatile("mov.u32 %0, %%clock;" : "=r"(start));
    lshift_fp(c, c, 1);
    asm volatile("mov.u32 %0, %%clock;" : "=r"(end));
    if (threadIdx.x == 0) times[2] = end - start;

    asm volatile("mov.u32 %0, %%clock;" : "=r"(start));
    rshift_fp(c, c, 1);
    asm volatile("mov.u32 %0, %%clock;" : "=r"(end));
    if (threadIdx.x == 0) times[3] = end - start;

    asm volatile("mov.u32 %0, %%clock;" : "=r"(start));
    lshift_fp(c, c, 2);
    asm volatile("mov.u32 %0, %%clock;" : "=r"(end));
    if (threadIdx.x == 0) times[4] = end - start;

    asm volatile("mov.u32 %0, %%clock;" : "=r"(start));
    rshift_fp(c, c, 2);
    asm volatile("mov.u32 %0, %%clock;" : "=r"(end));
    if (threadIdx.x == 0) times[5] = end - start;

    mul_fp(c, c, b);
    asm volatile("mov.u32 %0, %%clock;" : "=r"(start));
    mul_fp(c, c, b);
    asm volatile("mov.u32 %0, %%clock;" : "=r"(end));
    if (threadIdx.x == 0) times[6] = end - start;

    sqr_fp(c, a);
    asm volatile("mov.u32 %0, %%clock;" : "=r"(start));
    sqr_fp(c, c);
    asm volatile("mov.u32 %0, %%clock;" : "=r"(end));
    if (threadIdx.x == 0) times[7] = end - start;

    mul_384(d, a, b);
    asm volatile("mov.u32 %0, %%clock;" : "=r"(start));
    mul_384(d, a, b);
    asm volatile("mov.u32 %0, %%clock;" : "=r"(end));
    if (threadIdx.x == 0) times[8] = end - start;

    sqr_384(d, a);
    asm volatile("mov.u32 %0, %%clock;" : "=r"(start));
    sqr_384(d, a);
    asm volatile("mov.u32 %0, %%clock;" : "=r"(end));
    if (threadIdx.x == 0) times[9] = end - start;

    redc_fp(c, d);
    asm volatile("mov.u32 %0, %%clock;" : "=r"(start));
    redc_fp(c, d);
    asm volatile("mov.u32 %0, %%clock;" : "=r"(end));
    if (threadIdx.x == 0) times[10] = end - start;

    vec_copy(in[0], c, sizeof(c));
}

int main()
{
    cudaDeviceProp prop;
    cudaGetDeviceProperties(&prop, 0);
    cout << prop.name << endl;
    cout << "Capability: " << prop.major << "." << prop.minor << endl;
    cout << "Clock rate: " << prop.clockRate << "kHz" << endl;
    cout << "L2 cache size: " << prop.l2CacheSize << endl;

    size_t free, total;
    cudaMemGetInfo(&free, &total);
    cout << (prop.integrated ? "integrated" : "discrete") << " memory: "
         << free << "/" << total << endl;

    int blockSize;      // The launch configurator returned block size 
    int minGridSize;    // The minimum grid size needed to achieve the 
                        // maximum occupancy for a full device launch 
    cudaOccupancyMaxPotentialBlockSize(&minGridSize, &blockSize, kernel); 
    cout << "kernel<<<" << minGridSize << ", " << blockSize << ">>>" << endl;

    cudaDeviceGetLimit(&free, cudaLimitStackSize);
    cout << "stack: " << free << endl;

    const static vec384 one = { ONE_MONT_P };

    Vec384 *dst, ret[3];

    ret[1] = one;
    ret[2] = one;
    cout << ret[1] << endl;

    if (!prop.integrated) {
        cudaMalloc(&dst, sizeof(ret));
        cudaMemcpy(dst, ret, sizeof(ret), cudaMemcpyHostToDevice);
    } else {
        cudaMallocManaged(&dst, sizeof(ret));
        memcpy(dst, ret, sizeof(ret));
    }

    kernel<<<1, 32, sizeof(vec384)*blockSize>>>(dst);

    cudaDeviceSynchronize();

    if (!prop.integrated)
        cudaMemcpy(ret, dst, sizeof(ret), cudaMemcpyDeviceToHost);
    else
        memcpy(ret, dst, sizeof(ret));

    cudaFree(dst);

    cout << ret[0] << endl;

    uint32_t dtimes[12];
    cudaMemcpyFromSymbol(dtimes, times, sizeof(dtimes));
    cout << "add_fp:       " << dtimes[0] << endl;
    cout << "sub_fp:       " << dtimes[1] << endl;
    cout << "lshift_fp(1): " << dtimes[2] << endl;
    cout << "rshift_fp(1): " << dtimes[3] << endl;
    cout << "lshift_fp(2): " << dtimes[4] << endl;
    cout << "rshift_fp(2): " << dtimes[5] << endl;
    cout << "mul_fp:       " << dtimes[6] << endl;
    cout << "sqr_fp:       " << dtimes[7] << endl;
    cout << "mul_384:      " << dtimes[8] << endl;
    cout << "sqr_384:      " << dtimes[9] << endl;
    cout << "redc_fp:      " << dtimes[10] << endl;
}
