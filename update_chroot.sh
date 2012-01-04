#!/bin/sh

/bin/echo "vvvvvvvvvvvvvvvvvvv  update_chroot.sh vvvvvvvvvvvvvvvvvvvvvv"
uname -a
sudo easy_install -U rosinstall
which gcc
which ccache
apt-get install -y wget git-core mercurial subversion ccache

/bin/echo "^^^^^^^^^^^^^^^^^^  update_chroot.sh ^^^^^^^^^^^^^^^^^^^^"
