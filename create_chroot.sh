#!/bin/sh -x

/bin/echo "vvvvvvvvvvvvvvvvvvv  create_chroot.sh vvvvvvvvvvvvvvvvvvvvvv"
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
STAMP=/var/cache/pbuilder/$DISTRO-$ARCH.update_chroot.sh.stamp

if [ -e $STAMP ] ; then
    /bin/echo -n "Chroot last updated at:"
    ls -l $STAMP
fi

if [ -n $STAMP -o $STAMP -ot $UPDATE ] ; then
    /bin/echo "update has been updated, so let's update"
    sudo /bin/
    date > $STAMP
    sudo pbuilder execute \
        --basetgz $BASETGZ \
        --save-after-exec \
        --bindmounts /home \
        -- $UPDATE
fi

/bin/echo "^^^^^^^^^^^^^^^^^^  create_chroot.sh ^^^^^^^^^^^^^^^^^^^^"
