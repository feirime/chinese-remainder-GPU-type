#include "time_test.h"

void showTime(std::chrono::duration<double, std::milli> elapsed_time)
{
    std::chrono::hh_mm_ss time {elapsed_time};
    auto hours = time.hours().count();
    auto minutes = time.minutes().count();
    auto seconds = time.seconds().count();
    auto millisec = duration_cast<std::chrono::milliseconds>(time.subseconds()).count();
    std::cout << "Elapsed time: " << hours << " hours, " << minutes << " minutes, " 
              << seconds << " seconds, " << millisec << " milliseconds" << std::endl;
}

std::chrono::duration<double, std::milli> gmpTest()
{}
