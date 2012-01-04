/bin/echo "vvvvvvvvvvvvvvvvvvv  dispatch.sh vvvvvvvvvvvvvvvvvvvvvv"

export WORKSPACE

if [ -z "$WORKSPACE" ] ; then
    /bin/echo "Uh, workspace not set."
    exit 1
fi

#
#  update buildfarm utils
#
cd $WORKSPACE

if [ -d buildfarm ] ; then
  cd buildfarm
  git clean -dfx
  git reset --hard HEAD
  git pull
  cd ..
else
  git clone git://github.com/willowgarage/buildfarm.git
fi

. ./buildfarm/buildfarm_util.sh

export > env


sudo mkdir -p /var/cache/pbuilder/ccache
sudo chmod a+w /var/cache/pbuilder/ccache

cat > pbuilder-env.sh <<EOF
/bin/echo "vvvvvvvvvvvvvvvvvvv  pbuilder-env.sh vvvvvvvvvvvvvvvvvvvvvv"
set -x
export CCACHE_DIR="/var/cache/pbuilder/ccache"
export PATH="/usr/lib/ccache:${PATH}"
export WORKSPACE=$WORKSPACE
export UBUNTU_DISTRO=$UBUNTU_DISTRO
export ARCH=$ARCH
cd $WORKSPACE
exec "$@"
EOF


TOP=$(cd `dirname $0` ; /bin/pwd)

/usr/bin/env

SHORTJOB=$(dirname $JOB_NAME)

/bin/echo "SHORTJOB: $SHORTJOB"

$TOP/create_chroot.sh $UBUNTU_DISTRO $ARCH

sudo pbuilder execute \
    --basetgz /var/cache/pbuilder/$UBUNTU_DISTRO-$ARCH.tgz \
    --bindmounts "/var/cache/pbuilder/ccache /home" \
    --inputfile $JOB_NAME.sh \
    -- $WORKSPACE/pbuilder-env.sh $JOB_NAME.sh

/bin/echo "^^^^^^^^^^^^^^^^^^  dispatch.sh ^^^^^^^^^^^^^^^^^^^^"
