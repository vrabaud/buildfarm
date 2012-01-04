#!/bin/sh -ex

/bin/echo "vvvvvvvvvvvvvvvvvvv  create_chroot.sh vvvvvvvvvvvvvvvvvvvvvv"
IMAGETYPE=$1
DISTRO=$2
ARCH=$3

BASETGZ=/var/cache/pbuilder/$IMAGETYPE.$DISTRO.$ARCH.tgz

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
if [ -e $STAMP ] ; then
    /bin/echo -n "Chroot last updated at:"
    ls -l $STAMP
else
    /bin/echo "Chroot does not exist!"
    exit 1
fi

if [ ! -e $BASETGZ -o $UPDATE -nt $STAMP ] ; then
    /bin/echo "update has been updated, so let's update"
    sudo pbuilder execute \
        --basetgz $BASETGZ \
        --save-after-exec \
        -- $UPDATE $IMAGETYPE

fi

/bin/echo "^^^^^^^^^^^^^^^^^^  create_chroot.sh ^^^^^^^^^^^^^^^^^^^^"
