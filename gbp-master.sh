#!/bin/sh -e

$WORKSPACE/buildfarm/sanity_check.sh

/bin/echo "vvvvvvvvvvvvvvvvvvv  gbp-3rdparty.sh vvvvvvvvvvvvvvvvvvvvvv"

if [ -z "$WORKSPACE" ] ; then
    /bin/echo "Don't see no workspace."
    exit 1
fi

cd $WORKSPACE

PKG=$1

if [ ! -d src ] ; then
    git clone git://github.com/wg-debs/$PKG.git src
else
    cd src
    git clean -dfx
    git reset --hard HEAD
    git pull
    cd ..
fi

rm -rf build
mkdir build
cd build
cmake ../src -DCMAKE_INSTALL_PREFIX=/opt/ros/fuerte
make
make install

/bin/echo "^^^^^^^^^^^^^^^^^^  gbp-3rdparty.sh ^^^^^^^^^^^^^^^^^^^^"

$WORKSPACE/buildfarm/sanity_check.sh
