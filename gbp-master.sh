#!/bin/sh -e

./buildfarm/sanity_check.sh

/bin/echo "vvvvvvvvvvvvvvvvvvv  gbp-3rdparty.sh vvvvvvvvvvvvvvvvvvvvvv"

if [ -z "$WORKSPACE" ] ; then
    /bin/echo "Don't see no workspace."
    exit 1
fi

cd $WORKSPACE

PKG=$1

exit 0

curl -s https://raw.github.com/willowgarage/catkin/master/test/full.rosinstall > full.rosinstall
rosinstall -n src full.rosinstall

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


/bin/echo "^^^^^^^^^^^^^^^^^^  gbp-3rdparty.sh ^^^^^^^^^^^^^^^^^^^^"

./buildfarm/sanity_check.sh
