#include <iostream>
#include <thread>
#include <string_view>

#include <zmq.hpp>

#include <boost/log/trivial.hpp>

namespace {

int main_pub(const char * address) {
    zmq::context_t ctx {};
    zmq::socket_t pub {ctx, ZMQ_PUB};
    try {
        pub.bind(address);
    } catch (zmq::error_t const& e) {
        std::cerr << e.what() << '\n';
        return 1;
    }
    while (true) {
        std::cout << "hello\n";
        pub.send(zmq::str_buffer("hello"));
        std::this_thread::sleep_for(std::chrono::seconds{1});
    }
    return 0;
}

int main_sub(const char * address) {
    zmq::context_t ctx {};
    zmq::socket_t sub {ctx, ZMQ_SUB};
    sub.set(zmq::sockopt::subscribe, "");
    try {
        sub.connect(address);
    } catch (zmq::error_t const& e) {
        std::cerr << e.what() << '\n';
        return 1;
    }

    sub.set(zmq::sockopt::subscribe, "");

    while (true) {
        zmq::message_t msg {};
        auto r = sub.recv(msg);
        std::cout << std::string_view{static_cast<const char *>(msg.data()), msg.size()} << '\n';
    }
    return 0;
}
}

int main(int argc, const char ** argv) {
    BOOST_LOG_TRIVIAL(info) << "Hello, world!";

    if (argc < 3) {
        std::cout << "Specify command: pub or sub and then zmq address\n";
        return 1;
    }

    if (std::string_view{argv[1]} == "pub") {
        auto address = argv[2];
        std::cout << "pub mode to " << address << '\n';
        return main_pub(address);
    } else {
        auto address = argv[2];
        std::cout << "sub mode to " << address << '\n';
        return main_sub(address);
    }
}
