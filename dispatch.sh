#!/bin/sh

TOP=$(cd `dirname $0` ; /bin/pwd)

JOB_NAME=$1
DISTRO=$2
ARCH=$3

/usr/bin/env

SHORTJOB=$(dirname $1)

/bin/echo "SHORTJOB: $SHORTJOB"

cd $TOP
./create_chroot.sh $UBUNTU_DISTRO $ARCH
./$SHORTJOB.sh $DISTRO $ARCH

