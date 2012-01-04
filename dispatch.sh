export WORKSPACE

if [ -z "$WORKSPACE" ] ; then
    /bin/echo "Uh, workspace not set."
    exit 1
fi

echo $HOME

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

assert_set WORKSPACE HOME

/bin/echo "vvvvvvvvvvvvvvvvvvv  dispatch.sh vvvvvvvvvvvvvvvvvvvvvv"

export > env


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

/usr/bin/env

SHORTJOB=$(dirname $JOB_NAME)

/bin/echo "SHORTJOB: $SHORTJOB"

$TOP/create_chroot.sh $UBUNTU_DISTRO $ARCH

sudo pbuilder execute \
    --basetgz /var/cache/pbuilder/$UBUNTU_DISTRO-$ARCH.tgz \
    --bindmounts "/var/cache/pbuilder/ccache /home" \
    -- $TOP/$SHORTJOB.sh $UBUNTU_DISTRO $ARCH

/bin/echo "^^^^^^^^^^^^^^^^^^  dispatch.sh ^^^^^^^^^^^^^^^^^^^^"
