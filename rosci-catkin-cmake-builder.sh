set -ex
tmpdir=`mktemp -d`

APT_GET_DEPS="python-setuptools python-yaml python-pip libgtest-dev mercurial subversion git-core cmake build-essential"
# Stuff that doesn't change much
PIP_STATIC_DEPS="nose mock coverage"
# Stuff that changes a lot (install with -U)
PIP_DEPS="rospkg rosdep"
MANUAL_PY_DEP_HG_URIS="https://kforge.ros.org/rosrelease/rosci"

for p in $APT_GET_DEPS; do
  sudo apt-get install -y $p > /dev/null
done

for p in $PIP_STATIC_DEPS; do
  sudo pip install $p > /dev/null
done

for p in $PIP_DEPS; do
  sudo pip install -U $p > /dev/null
done

for u in $MANUAL_PY_DEP_HG_URIS; do
  cd $tmpdir
  hg clone $u `basename $u`
  cd `basename $u`
  sudo python setup.py install
done

# Ignore error on init; it might have already happened.
sudo rosdep init || true
rosdep update

# install the stack.yaml Depends
wget $STACK_YAML_URL -O $tmpdir/stack.yaml
APT_DEPENDENCIES=`rosci-catkin-depends $tmpdir/stack.yaml $ROSDISTRO_NAME $OS_NAME $OS_PLATFORM`
sudo apt-get install -y $APT_DEPENDENCIES

## bootstrap env
. /opt/ros/$ROSDISTRO_NAME/setup.sh

# catkin-specific stuff
#
rm -rf $WORKSPACE/build
mkdir -p $WORKSPACE/build
cd $WORKSPACE/build && cmake $WORKSPACE/$STACK_NAME
cd $WORKSPACE/build && make
if cd $WORKSPACE/build && make test; then echo "tests passed"; fi

sudo rm -rf $tmpdir
