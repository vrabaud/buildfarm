#!/bin/sh

/bin/echo "vvvvvvvvvvvvvvvvvvv  update_chroot.sh vvvvvvvvvvvvvvvvvvvvvv"
uname -a
sudo easy_install -U rosinstall
which gcc
which ccache
apt-get install wget

/bin/echo "^^^^^^^^^^^^^^^^^^  update_chroot.sh ^^^^^^^^^^^^^^^^^^^^"
