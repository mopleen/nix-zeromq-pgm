cmake_minimum_required(VERSION 3.22)
project(App)

set(CMAKE_CXX_STANDARD 17)

FIND_PACKAGE(Boost REQUIRED COMPONENTS log_setup)

add_executable(main main.cpp)
target_link_libraries(main PUBLIC zmq pgm Boost::log_setup mylib)

add_library(mylib STATIC q.cpp)

install(TARGETS main)

