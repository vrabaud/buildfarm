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

curl -s https://raw.github.com/willowgarage/catkin/master/test/full.rosinstall > full.rosinstall
rosinstall -n src full.rosinstall

rm -rf SCRATCH
mkdir SCRATCH
./src/catkin/test/incremental_by_stack_build.sh src SCRATCH

/bin/echo "^^^^^^^^^^^^^^^^^^  catkin-install-per-stack.sh ^^^^^^^^^^^^^^^^^^^^"
