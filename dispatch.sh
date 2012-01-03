#!/bin/sh -ex

TOP=$(cd `dirname $0` ; /bin/pwd)

JOB_NAME=$1
DISTRO=$2
ARCH=$3

/usr/bin/env

SHORTJOB=$(dirname $1)

/bin/echo "SHORTJOB: $SHORTJOB"

$TOP/create_chroot.sh $UBUNTU_DISTRO $ARCH
$TOP/$SHORTJOB.sh $DISTRO $ARCH

