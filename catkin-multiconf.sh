#!/bin/sh -x

/bin/echo "vvvvvvvvvvvvvvvvvvv  catkin_multiconf.sh vvvvvvvvvvvvvvvvvvvvvv"

if [ -n "$WORKSPACE" ] ; then
    /bin/echo "Don't see no workspace."
    exit 1
fi

cd $WORKSPACE

/usr/bin/env
which gcc
gcc --version
ccache -s
lsb_release -a
mount
ls -l /var/cache/pbuilder/ccache
ls -l /var/cache/pbuilder

cat > main.cpp <<EOF
#include <iostream>
int main(int, char**) { std::cout << "$(date)\n"; }
EOF
ccache -s | grep link
gcc -o main main.cpp -lstdc++
ccache -s | grep link
./main

rm -rf test.rosinstall*
wget https://raw.github.com/willowgarage/catkin/master/test/test.rosinstall
rm -rf src
rosinstall -n src test.rosinstall
cd src
rm -f CMakeLists.txt
ln -s catkin/toplevel.cmake CMakeLists.txt
cd ..
rm -rf build
mkdir build
cd build
cmake ../src
cat CMakeCache.txt
export ROS_TEST_RESULTS_DIR=$WORKSPACE/build/test_results
make -i test
$WORKSPACE/build/env.sh $WORKSPACE/src/ros/tools/rosunit/scripts/clean_junit_xml.py
make install DESTDIR=$(/bin/pwd)/DESTDIR


/bin/echo "^^^^^^^^^^^^^^^^^^  catkin_multiconf.sh ^^^^^^^^^^^^^^^^^^^^"
