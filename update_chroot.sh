#!/bin/sh -x

echo "+++++++++++++++++++ $0 +++++++++++++++"
uname -a
sudo easy_install -U rosinstall
which gcc
which ccache