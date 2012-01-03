#!/bin/sh

DISTRO=$1
ARCH=$2

BASETGZ=$DISTRO-$ARCH.tgz

if [ ! -f $BASETGZ ] ; then
    sudo pbuilder --create \
        --distribution $DISTRO \
        --architecture $ARCH \
        --basetgz $BASETGZ \
        --debootstrapopts --variant=buildd \
        --components "main universe multiverse" \
        --extrapackages "lsb-release ccache cmake libopenmpi-dev libboost-dev gccxml python-empy python-yaml python-setuptools openssl"
else
    sudo pbuilder execute \
        --basetgz $BASETGZ \
        -- $WORKSPACE/buildfarm/update_chroot.sh
fi

