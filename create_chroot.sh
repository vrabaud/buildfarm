#!/bin/sh

DISTRO=$1
ARCH=$2
VARIANT=$3

BASETGZ=$DISTRO-$ARCH-$VARIANT.tgz

sudo pbuilder --create \
    --distribution $DISTRO \
    --architecture $ARCH \
    --basetgz $BASETGZ \
    --debootstrapopts --variant=buildd \
    --components "main universe multiverse" \
    --extrapackages "lsb-release ccache cmake libopenmpi-dev libboost-dev gccxml python-empy python-yaml python-setuptools openssl"

