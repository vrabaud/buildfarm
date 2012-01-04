/bin/echo "vvvvvvvvvvvvvvvvvvv  dispatch.sh vvvvvvvvvvvvvvvvvvvvvv"

export WORKSPACE

if [ -z "$WORKSPACE" ] ; then
    /bin/echo "Uh, workspace not set."
    exit 1
fi

[[ $JOB_NAME =~ ([^\.]+)\.([^\.]+)\.([^\.]+)\.([^\.]+) ]]
SCRIPT=${BASH_REMATCH[1]}
IMAGETYPE=${BASH_REMATCH[2]}
UBUNTU_DISTRO=${BASH_REMATCH[3]}
ARCH=${BASH_REMATCH[4]}

/bin/echo <<EOF
SCRIPT=$SCRIPT
IMAGETYPE=$IMAGETYPE
UBUNTU_DISTRO=$UBUNTU_DISTRO
ARCH=$ARCH
EOF

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
#!/bin/bash -x
/bin/echo "vvvvvvvvvvvvvvvvvvv  pbuilder-env.sh vvvvvvvvvvvvvvvvvvvvvv"
export CCACHE_DIR="/var/cache/pbuilder/ccache"
export PATH="/usr/lib/ccache:${PATH}"
export WORKSPACE=$WORKSPACE
export UBUNTU_DISTRO=$UBUNTU_DISTRO
export ARCH=$ARCH
export IMAGETYPE=$IMAGETYPE
pwd
ls -l
cd $WORKSPACE
ls -l
exec $WORKSPACE/"\$@"
EOF

chmod 755 pbuilder-env.sh

TOP=$(cd `dirname $0` ; /bin/pwd)

/usr/bin/env

$WORKSPACE/buildfarm/create_chroot.sh $IMAGETYPE $UBUNTU_DISTRO $ARCH


sudo pbuilder execute \
    --basetgz /var/cache/pbuilder/$IMAGETYPE.$UBUNTU_DISTRO.$ARCH.tgz \
    --bindmounts "/var/cache/pbuilder/ccache /home" \
    --inputfile $WORKSPACE/buildfarm/$SCRIPT.sh \
    -- $WORKSPACE/pbuilder-env.sh $SCRIPT.sh

/bin/echo "^^^^^^^^^^^^^^^^^^  dispatch.sh ^^^^^^^^^^^^^^^^^^^^"
