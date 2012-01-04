#!/bin/bash -ex

TOP=$(cd `dirname $0` ; pwd)
. $TOP/buildfarm_util.sh

assert_set WORKSPACE HOME

/bin/echo "vvvvvvvvvvvvvvvvvvv  dispatch.sh vvvvvvvvvvvvvvvvvvvvvv"



cat > $HOME/.pbuilderrc <<EOF
/bin/echo "******* READING .PBUILDERRC **********"
set -x
sudo mkdir -p /var/cache/pbuilder/ccache
sudo chmod a+w /var/cache/pbuilder/ccache
export CCACHE_DIR="/var/cache/pbuilder/ccache"
export PATH="/usr/lib/ccache:${PATH}"
export WORKSPACE=$WORKSPACE
set +x
EOF


TOP=$(cd `dirname $0` ; /bin/pwd)

JOB_NAME=$1
DISTRO=$2
ARCH=$3

/usr/bin/env

SHORTJOB=$(dirname $1)

/bin/echo "SHORTJOB: $SHORTJOB"

$TOP/create_chroot.sh $DISTRO $ARCH

sudo pbuilder execute \
    --basetgz /var/cache/pbuilder/$DISTRO-$ARCH.tgz \
    --bindmounts "/var/cache/pbuilder/ccache /home" \
    -- $TOP/$SHORTJOB.sh $DISTRO $ARCH

/bin/echo "^^^^^^^^^^^^^^^^^^  dispatch.sh ^^^^^^^^^^^^^^^^^^^^"
