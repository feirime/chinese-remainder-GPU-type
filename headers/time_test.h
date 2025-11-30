#ifndef TIME_TEST_H
#define TIME_TEST_H

#include <chrono>
#include <iostream>

void showTime(std::chrono::duration<double, std::milli> elapsed_time);
std::chrono::duration<double, std::milli> gmpTest();

#endif