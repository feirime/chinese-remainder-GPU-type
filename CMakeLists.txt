cmake_minimum_required(VERSION 3.19.0)

project(crt CUDA CXX)

set(CMAKE_CUDA_STANDARD 20)
set(CMAKE_CXX_STANDARD 20)
include_directories(${PROJECT_SOURCE_DIR}/headers 
                    ${PROJECT_SOURCE_DIR}/external/cgbn/include/cgbn)

file(GLOB sources ${PROJECT_SOURCE_DIR}/sources/*.cu
                  ${PROJECT_SOURCE_DIR}/sources/*.cpp)
file(GLOB headers ${PROJECT_SOURCE_DIR}/headers/*.h)

add_executable(crt ${headers} ${sources})

target_link_libraries(crt gmp gmpxx)

set_target_properties(crt PROPERTIES
        CUDA_SEPARABLE_COMPILATION ON)
