#!/bin/bash -ex

echo "$*"
id
/usr/bin/env

./buildfarm/sanity_check.sh

/bin/echo "vvvvvvvvvvvvvvvvvvv  catkin-install-per-stack.sh vvvvvvvvvvvvvvvvvvvvvv"

if [ -z "$WORKSPACE" ] ; then
    /bin/echo "Don't see no workspace."
    exit 1
fi

cd $WORKSPACE

sudo sh -c "echo \"deb http://packages.ros.org/ros-shadow-fixed/ubuntu $UBUNTU_DISTRO main\" > /etc/apt/sources.list.d/ros-latest.list"
wget http://packages.ros.org/ros.key -O - | sudo apt-key add -
sudo apt-get update
sudo apt-get install -y libwxgtk2.8-dev ros-fuerte-swig-wx curl
export PATH=/opt/ros/fuerte/bin:$PATH

curl -s https://raw.github.com/willowgarage/catkin/master/test/full.rosinstall > full.rosinstall
rosinstall -n src full.rosinstall

rm -rf SCRATCH
mkdir SCRATCH
./src/catkin/test/incremental_by_stack_build.sh src SCRATCH

/bin/echo "^^^^^^^^^^^^^^^^^^  catkin-install-per-stack.sh ^^^^^^^^^^^^^^^^^^^^"
