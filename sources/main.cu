#include "crt.h"
#include "crt_cu.h"
#include "time_test.h"


int main()
{
    int primeSize = 20;
    int launchSize = 1000;
    int testSize = 100000;

    // Инициализация генератора GMP
    gmp_randstate_t state;
    gmp_randinit_default(state);
    // Семя: текущее время (можно заменить любым источником энтропии)
    unsigned long seed = static_cast<unsigned long>(std::chrono::high_resolution_clock::now().time_since_epoch().count());
    gmp_randseed_ui(state, seed);
    std::vector<mpz_class> a; 
    std::vector<mpz_class> b;
    a.resize(testSize);
    b.resize(testSize);
    // Генерируем случайное число с 101 битом и устанавливаем старший бит (бит 100),
    // чтобы гарантировать порядок ~2^100 (т.е. значение в интервале [2^100, 2^101-1]).
    const unsigned int HIGH_BIT = 100;
    for (int i = 0; i < testSize; i++)
    {
        mpz_urandomb(a[i].get_mpz_t(), state, HIGH_BIT + 1);
        mpz_setbit(a[i].get_mpz_t(), HIGH_BIT);
        mpz_urandomb(b[i].get_mpz_t(), state, HIGH_BIT + 1);
        mpz_setbit(b[i].get_mpz_t(), HIGH_BIT);
    }
    auto start_time = std::chrono::high_resolution_clock::now();
    for(int i = 0; i < launchSize; i++)
    {
        for(int j = 0; j < testSize; j++)
        {
            mpz_class sum = a[j] + b[j];
        }
    }
    auto end_time = std::chrono::high_resolution_clock::now();
    std::ofstream fileGmp("data/gmp_time.csv");
    saveTime(fileGmp, end_time - start_time);
    showTime(end_time - start_time);

    unsigned long *prime_set;
    cudaMallocManaged(&prime_set, primeSize* sizeof(unsigned long));
    prime_set[0] = 997;
    prime_set[1] = 991;
    prime_set[2] = 983;
    prime_set[3] = 977;
    prime_set[4] = 971;
    prime_set[5] = 967;
    prime_set[6] = 953;
    prime_set[7] = 947;
    prime_set[8] = 941;
    prime_set[9] = 937;
    prime_set[10] = 929;
    prime_set[11] = 919;
    prime_set[12] = 911;
    prime_set[13] = 907;
    prime_set[14] = 887;
    prime_set[15] = 883;
    prime_set[16] = 881;
    prime_set[17] = 877;
    prime_set[18] = 863;
    prime_set[19] = 859;
    unsigned long *a_dev, *b_dev, *c_dev;
    cudaMallocManaged(&a_dev, testSize * primeSize * sizeof(int));
    cudaMallocManaged(&b_dev, testSize * primeSize * sizeof(int));
    cudaMallocManaged(&c_dev, testSize * primeSize * sizeof(int));
    start_time = std::chrono::high_resolution_clock::now();
    converterGMPtoCRT(a, a_dev, testSize, prime_set, primeSize);
    converterGMPtoCRT(b, b_dev, testSize, prime_set, primeSize);
    for(int i = 0; i < launchSize; i++)
    {
        add<<<1, 1>>>(a_dev, b_dev, c_dev, prime_set);
    }
    end_time = std::chrono::high_resolution_clock::now();
    std::ofstream fileCuda("data/cuda_time.csv");
    saveTime(fileCuda, end_time - start_time);
    showTime(end_time - start_time);

    cudaFree(a_dev);
    cudaFree(b_dev);
    cudaFree(c_dev);
    cudaFree(prime_set);
    gmp_randclear(state);
}
