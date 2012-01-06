#!/bin/sh -ex

/bin/echo "vvvvvvvvvvvvvvvvvvv  update_chroot.sh vvvvvvvvvvvvvvvvvvvvvv"
/bin/echo $*
id

apt-get install -y python-setuptools ccache wget curl curl-ssl sudo

easy_install -U rosinstall

git config --global user.name  "Willow Garage Package Ranch Bot"
git config --global user.email "pkgranchbot@willowgarage.com"

case $1 in
    fat)
        apt-get install -y wget git-core mercurial subversion \
            ccache lsb-release ccache cmake libopenmpi-dev \
            libboost-dev libboost-all-dev python-all \
            gccxml python-empy python-yaml python-nose \
            openssl sudo liblog4cxx10-dev libgtest-dev libbz2-dev
        ;;
esac


/bin/echo "^^^^^^^^^^^^^^^^^^  update_chroot.sh ^^^^^^^^^^^^^^^^^^^^"
