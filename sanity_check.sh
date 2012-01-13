#!/bin/bash -eu
set -o errexit

gcc --version
ccache -s
which curl
which rosinstall

cat > main.cpp <<EOF
#include <iostream>
int main(int, char**) { std::cout << "$(date)\n"; }
EOF
gcc -o main main.cpp -lstdc++
./main
