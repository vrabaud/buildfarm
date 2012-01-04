#!/bin/sh -x

DISTRO=$1
ARCH=$2

BASETGZ=/var/cache/pbuilder/$DISTRO-$ARCH.tgz

if [ ! -f $BASETGZ ] ; then
    sudo pbuilder --create \
        --distribution $DISTRO \
        --architecture $ARCH \
        --basetgz $BASETGZ \
        --debootstrapopts --variant=buildd \
        --components "main universe multiverse" \
        --extrapackages "lsb-release ccache cmake libopenmpi-dev libboost-dev gccxml python-empy python-yaml python-setuptools openssl sudo"
fi

UPDATE=$WORKSPACE/buildfarm/update_chroot.sh
STAMP=$WORKSPACE/update_chroot.sh.stamp

if [ -e $STAMP ] ; then
    /bin/echo -n "Chroot last updated at:"
    cat $STAMP
fi

if [ $STAMP -ot $UPDATE ] ; then
    /bin/echo "update has been updated, so let's update"
    date > $STAMP
    sudo pbuilder execute \
        --basetgz $BASETGZ \
        --save-after-exec \
        --bindmount /home \
        -- $UPDATE
fi

