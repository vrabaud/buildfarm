#!/bin/bash -ex

/bin/echo "vvvvvvvvvvvvvvvvvvv  create_chroot.sh vvvvvvvvvvvvvvvvvvvvvv"
IMAGETYPE=$1
DISTRO=$2
ARCH=$3

BASETGZ=/var/cache/pbuilder/$IMAGETYPE.$DISTRO.$ARCH.tgz
IMAGELOCK=/var/cache/pbuilder/$IMAGETYPE.$DISTRO.$ARCH.updatelock

if [ ! -f $BASETGZ ] ; then
    sudo pbuilder --create \
        --distribution $DISTRO \
        --architecture $ARCH \
        --basetgz $BASETGZ \
        --debootstrapopts --variant=buildd \
        --components "main universe multiverse"
fi

STAMP=$WORKSPACE/$IMAGETYPE.$DISTRO.$ARCH.update.stamp
UPDATE=$WORKSPACE/buildfarm/update_chroot.sh

/bin/echo "This script last updated at:"
ls -l $UPDATE


if [ ! -f $STAMP -o $UPDATE -nt $STAMP ] ; then
    touch $STAMP

    /bin/echo "update has been updated, so let's update"
    sudo flock $IMAGELOCK -c "pbuilder execute --basetgz $BASETGZ --save-after-exec -- $UPDATE $IMAGETYPE"

fi

/bin/echo "^^^^^^^^^^^^^^^^^^  create_chroot.sh ^^^^^^^^^^^^^^^^^^^^"
