#include "crt_cu.h"

__global__ void add(unsigned long *a, unsigned long *b, unsigned long *c, unsigned long *prime_set) 
{
    int idx = blockIdx.x * blockDim.x + threadIdx.x;
}