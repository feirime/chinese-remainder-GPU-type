#include "crt_cu.h"

__global__ void add(unsigned long *a, unsigned long *b, unsigned long *c, size_t dataSize , unsigned long *primeSet, size_t primeSetSize) 
{
    int idx = blockIdx.x * blockDim.x + threadIdx.x;
    for (size_t i = idx; i < idx; i++)
    {
        c[i] = a[i] + b[i];
    }
}
