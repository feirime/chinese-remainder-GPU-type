#ifndef CRT_CPU_H
#define CRT_CPU_H

#include <gmpxx.h>

extern bool spin_glass_read;

void modular_inverse_element_2_with_prime_modulo(mpz_t product, mpz_t x,  long int rec_number);
long int modular_gcd_v1(long int a, mpz_t const b);
void chinese_decryption(char *result, const unsigned long int *rem, unsigned int *prime_number, long int pr_n);

void converterGMPtoCRT(std::vector<mpz_class> a, unsigned long *a_dev, size_t size, unsigned long *prime_set, size_t prime_set_size);

#endif
