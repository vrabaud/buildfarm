#!/bin/bash -x

which gcc
gcc --version

which ccache
ccache -s

cat > main.cpp <<EOF
#include <iostream>
int main(int, char**) { std::cout << "$(date)\n"; }
EOF
ccache -s | grep link
gcc -o main main.cpp -lstdc++
ccache -s | grep link
./main

