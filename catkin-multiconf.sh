#!/bin/sh -x

cd $WORKSPACE

export CCACHE_DIR=$WORKSPACE/ccache
ccache -s
rm -rf $WORKSPACE/bin
mkdir $WORKSPACE/bin
for comp in c++ g++ gcc
do
    ln -s /usr/bin/ccache $WORKSPACE/bin/$comp
done
export PATH=$WORKSPACE/bin:$PATH
which gcc
which g++
which c++

/usr/bin/env

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


