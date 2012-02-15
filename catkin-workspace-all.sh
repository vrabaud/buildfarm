#!/bin/sh -e

./buildfarm/sanity_check.sh

/bin/echo "vvvvvvvvvvvvvvvvvvv  catkin-workspace-all.sh vvvvvvvvvvvvvvvvvvvvvv"

if [ -z "$WORKSPACE" ] ; then
    /bin/echo "Don't see no workspace."
    exit 1
fi

cd $WORKSPACE

sudo sh -c "echo \"deb http://packages.ros.org/ros-shadow-fixed/ubuntu $UBUNTU_DISTRO main\" > /etc/apt/sources.list.d/ros-latest.list"
wget http://packages.ros.org/ros.key -O - | sudo apt-key add -
sudo apt-get update
sudo apt-get install -y libwxgtk2.8-dev ros-fuerte-swig-wx curl libqt4-dev
sudo apt-get install -y python-paramiko python-crypto python-mock
export PATH=/opt/ros/fuerte/bin:$PATH

curl -s https://raw.github.com/willowgarage/catkin/master/test/full.rosinstall > full.rosinstall
./buildfarm/remove_folder_on_change.sh src 1
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


/bin/echo "^^^^^^^^^^^^^^^^^^  catkin-workspace-all.sh ^^^^^^^^^^^^^^^^^^^^"

cd $WORKSPACE
$WORKSPACE/buildfarm/sanity_check.sh
