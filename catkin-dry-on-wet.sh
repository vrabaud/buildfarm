#!/bin/sh -e

./buildfarm/sanity_check.sh

/bin/echo "vvvvvvvvvvvvvvvvvvv  catkin-workspace-all.sh vvvvvvvvvvvvvvvvvvvvvv"

if [ -z "$WORKSPACE" ] ; then
    /bin/echo "Don't see no workspace."
    exit 1
fi

cd $WORKSPACE

curl -s https://raw.github.com/willowgarage/catkin/master/test/full.rosinstall > full.rosinstall
# temporary: protect against kforge auth errors
cmd="rosinstall -n --delete-changed-uris src full.rosinstall"
$cmd
#while ! $cmd; do echo "Trying again..." ; done

cd src
rm -f CMakeLists.txt
ln -s catkin/toplevel.cmake CMakeLists.txt
cd ..
rm -rf build
mkdir build
cd build
DESTDIR=$WORKSPACE/install
cmake -DCMAKE_INSTALL_PREFIX=$DESTDIR ../src
#export ROS_TEST_RESULTS_DIR=$WORKSPACE/build/test_results
make
#make -i test
#$WORKSPACE/build/env.sh $WORKSPACE/src/ros/tools/rosunit/scripts/clean_junit_xml.py
make install

cd ..
rm -rf dry_land/*
mkdir -p dry_land
cd dry_land
curl -s https://raw.github.com/willowgarage/catkin/master/test/unstable/desktop-overlay.rosinstall > desktop-overlay.rosinstall
curl -s https://raw.github.com/willowgarage/catkin/master/test/unstable/extras.rosinstall > extras.rosinstall
# temporary: protect against kforge auth errors
cmd="rosinstall -n --delete-changed-uris . $DESTDIR desktop-overlay.rosinstall extras.rosinstall"
echo $cmd
ls -la $DESTDIR
cat $DESTDIR/.rosinstall
$cmd
#while ! $cmd; do echo "Trying again..." ; done
curl -s https://raw.github.com/willowgarage/catkin/master/test/unstable/perception_pcl-unstable-build-fix.diff > perception_pcl-unstable-build-fix.diff 
patch -d perception_pcl -p0 < perception_pcl-unstable-build-fix.diff
. setup.bash
. $DESTDIR/setup.bash
rosmake -a -k


/bin/echo "^^^^^^^^^^^^^^^^^^  catkin-workspace-all.sh ^^^^^^^^^^^^^^^^^^^^"

cd $WORKSPACE
$WORKSPACE/buildfarm/sanity_check.sh
