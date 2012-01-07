#!/bin/sh -e

./buildfarm/sanity_check.sh

/bin/echo "vvvvvvvvvvvvvvvvvvv  gbp-3rdparty.sh vvvvvvvvvvvvvvvvvvvvvv"

if [ -z "$WORKSPACE" ] ; then
    /bin/echo "Don't see no workspace."
    exit 1
fi

cd $WORKSPACE

PKG=$1

git clone git://github.com/wg-debs/$PKG.git src
mkdir build
cd build
cmake ../src -DCMAKE_INSTALL_PREFIX=/opt/ros/fuerte
make
make install

/bin/echo "^^^^^^^^^^^^^^^^^^  gbp-3rdparty.sh ^^^^^^^^^^^^^^^^^^^^"

./buildfarm/sanity_check.sh
