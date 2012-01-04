#!/bin/sh -ex

/bin/echo "vvvvvvvvvvvvvvvvvvv  catkin_multiconf.sh vvvvvvvvvvvvvvvvvvvvvv"

if [ -z "$WORKSPACE" ] ; then
    /bin/echo "Don't see no workspace."
    exit 1
fi

cd $WORKSPACE

curl -s https://raw.github.com/willowgarage/catkin/master/test/test.rosinstall > test.rosinstall
rosinstall -n src test.rosinstall

cd src
rm -f CMakeLists.txt
ln -s catkin/toplevel.cmake CMakeLists.txt
cd ..
rm -rf build
mkdir build
cd build
cmake ../src
export ROS_TEST_RESULTS_DIR=$WORKSPACE/build/test_results
make
make -i test
$WORKSPACE/build/env.sh $WORKSPACE/src/ros/tools/rosunit/scripts/clean_junit_xml.py
make install DESTDIR=$(/bin/pwd)/DESTDIR


/bin/echo "^^^^^^^^^^^^^^^^^^  catkin_multiconf.sh ^^^^^^^^^^^^^^^^^^^^"
