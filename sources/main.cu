#include "crt.h"
#include "crt_cu.h"
#include "time_test.h"


int main()
{
    int primeSize = 20;
    int dataSize_start = 10;
    int dataSize_stop = 10000000;
    int launchSize_start = 100000000;
    int launchSize_stop = 100;
    int batchSize = 18;
    int dataSize_step = std::pow((dataSize_stop / dataSize_start), 1 / static_cast<float>(batchSize));
    int launchSize_step = std::pow((launchSize_start/ launchSize_stop), 1 / static_cast<float>(batchSize));
    std::cout << "Data size step: " << dataSize_step << std::endl;
    std::cout << "Launch size step: " << launchSize_step << std::endl;
    

    // Инициализация генератора GMP
    gmp_randstate_t state;
    gmp_randinit_default(state);
    // Семя: текущее время (можно заменить любым источником энтропии)
    unsigned long seed = static_cast<unsigned long>(std::chrono::high_resolution_clock::now().time_since_epoch().count());
    gmp_randseed_ui(state, seed);
    std::vector<mpz_class> a; 
    std::vector<mpz_class> b;
    a.resize(dataSize_stop);
    b.resize(dataSize_stop);
    // Генерируем случайное число с 101 битом и устанавливаем старший бит (бит 100),
    // чтобы гарантировать порядок ~2^100 (т.е. значение в интервале [2^100, 2^101-1]).
    const unsigned int HIGH_BIT = 100;
    for (int i = 0; i < dataSize_stop; i++)
    {
        mpz_urandomb(a[i].get_mpz_t(), state, HIGH_BIT + 1);
        mpz_setbit(a[i].get_mpz_t(), HIGH_BIT);
        mpz_urandomb(b[i].get_mpz_t(), state, HIGH_BIT + 1);
        mpz_setbit(b[i].get_mpz_t(), HIGH_BIT);
    }

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
    cudaMallocManaged(&a_dev, dataSize_stop * primeSize * sizeof(int));
    cudaMallocManaged(&b_dev, dataSize_stop * primeSize * sizeof(int));
    cudaMallocManaged(&c_dev, dataSize_stop * primeSize * sizeof(int));
    converterGMPtoCRT(a, a_dev, dataSize_stop, prime_set, primeSize);
    converterGMPtoCRT(b, b_dev, dataSize_stop, prime_set, primeSize);
    std::ofstream file("data/time.csv");
    for(int i = 0; i < batchSize; i++)
    {
        auto startTime = std::chrono::high_resolution_clock::now();
        for(int i = 0; i < launchSize_start; i++)
        {
            for(int j = 0; j < dataSize_start; j++)
            {
                mpz_class sum = a[j] + b[j];
            }
        }
        auto endTime = std::chrono::high_resolution_clock::now();
        auto gmpTime = endTime - startTime;
        showTime(gmpTime);
        startTime = std::chrono::high_resolution_clock::now();
        for(int i = 0; i < launchSize_start; i++)
        {
            add<<<1, 1>>>(a_dev, b_dev, c_dev, dataSize_start, prime_set, primeSize);
        }
        endTime = std::chrono::high_resolution_clock::now();
        auto cudaTime = endTime - startTime;
        saveTime(file, gmpTime, cudaTime, dataSize_start, launchSize_start);
        showTime(cudaTime);
        dataSize_start *= dataSize_step;
        launchSize_start /= launchSize_step;
    }

    cudaFree(a_dev);
    cudaFree(b_dev);
    cudaFree(c_dev);
    cudaFree(prime_set);
    gmp_randclear(state);
}
