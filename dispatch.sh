#!/bin/sh

JOB_NAME=$1
DISTRO=$2
ARCH=$3

/usr/bin/env

SHORTJOB=$(dirname $1)

/bin/echo "SHORTJOB: $SHORTJOB"

./$SHORTJOB.sh $DISTRO $ARCH

