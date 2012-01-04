#!/bin/sh -ex

/bin/echo "vvvvvvvvvvvvvvvvvvv  catkin-installed-per-stack.sh vvvvvvvvvvvvvvvvvvvvvv"

cat $HOME/.pbuilderrc

if [ -z "$WORKSPACE" ] ; then
    /bin/echo "Don't see no workspace."
    exit 1
fi

cd $WORKSPACE

rm -f test.rosinstall*
wget https://raw.github.com/willowgarage/catkin/master/test/test.rosinstall
rosinstall -n src test.rosinstall

rm -rf SCRATCH
mkdir SCRATCH
./src/catkin/test/incremental_by_stack_build.sh src SCRATCH

/bin/echo "^^^^^^^^^^^^^^^^^^  catkin-installed-per-stack.sh ^^^^^^^^^^^^^^^^^^^^"
