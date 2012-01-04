#!/bin/sh

/bin/echo "vvvvvvvvvvvvvvvvvvv  update_chroot.sh vvvvvvvvvvvvvvvvvvvvvv"
uname -a
sudo easy_install -U rosinstall
which gcc
which ccache

apt-get install -y wget git-core mercurial subversion \
    ccache lsb-release ccache cmake libopenmpi-dev \
    libboost-dev gccxml python-empy python-yaml python-setuptools openssl sudo \
    liblog4cxx-dev

/bin/echo "^^^^^^^^^^^^^^^^^^  update_chroot.sh ^^^^^^^^^^^^^^^^^^^^"
