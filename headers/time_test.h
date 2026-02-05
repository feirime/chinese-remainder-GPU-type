#ifndef TIME_TEST_H
#define TIME_TEST_H

#include <chrono>
#include <iostream>
#include <fstream>

void showTime(std::chrono::duration<double, std::milli> elapsed_time);
void saveTime(std::ofstream& file, std::chrono::duration<double, std::milli> gmpTime, 
    std::chrono::duration<double, std::milli> cudaTime, long int dataSize, long int launchSize);

#endif