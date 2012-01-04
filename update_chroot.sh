#!/bin/sh -x

/bin/echo "+++++++++++++++++++ $0 +++++++++++++++"
uname -a
sudo easy_install -U rosinstall
which gcc
which ccache

/bin/echo "Done updating chroot."