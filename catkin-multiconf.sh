#!/bin/sh -x

/bin/echo "vvvvvvvvvvvvvvvvvvv  catkin_multiconf.sh vvvvvvvvvvvvvvvvvvvvvv"

cd $WORKSPACE

/usr/bin/env
which gcc
gcc --version
ccache -s
lsb_release -a

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
