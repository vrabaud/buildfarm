#!/bin/sh

/bin/echo "vvvvvvvvvvvvvvvvvvv  update_chroot.sh vvvvvvvvvvvvvvvvvvvvvv"
/bin/echo $*

uname -a
sudo easy_install -U rosinstall
which gcc
which ccache

sudo apt-get install ccache wget curl sudo

case $1 in
    fat)
        apt-get install -y wget git-core mercurial subversion \
            ccache lsb-release ccache cmake libopenmpi-dev \
            libboost-dev gccxml python-empy python-yaml python-setuptools \
            openssl sudo liblog4cxx10-dev
        ;;
esac


/bin/echo "^^^^^^^^^^^^^^^^^^  update_chroot.sh ^^^^^^^^^^^^^^^^^^^^"
