#!/bin/bash -eu
set -o errexit

/bin/echo `which gcc` :: `gcc --version`
/bin/echo `which ccache` :: `ccache -s`
/bin/echo `which curl` :: `curl --version`
/bin/echo `which rosinstall` :: `rosinstall --version`

cat > main.cpp <<EOF
#include <iostream>
int main(int, char**) { std::cout << "$(date)\n"; }
EOF
gcc -o main main.cpp -lstdc++
./main
