project(App)

set(CMAKE_CXX_STANDARD 17)

add_executable(main main.cpp)
target_link_libraries(main PUBLIC zmq pgm)

install(TARGETS main)
