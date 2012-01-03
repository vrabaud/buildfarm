#!/bin/sh -e

ENVFILE=$WORKSPACE/init_ccache.env

cat > $ENVFILE <<EOF
export PATH=$WORKSPACE/bin:$PATH
export CCACHE_DIR=$WORKSPACE/ccache
EOF

. $ENVFILE

/bin/echo $ENVFILE

exec > $WORKSPACE/$0.log
exec 2>&1

rm -rf $WORKSPACE/bin
mkdir $WORKSPACE/bin
for comp in c++ g++ gcc
do
    ln -s /usr/bin/ccache $WORKSPACE/bin/$comp
done
export PATH=$WORKSPACE/bin:$PATH
hash gcc
hash g++
hash c++

which gcc
gcc --version
ccache -s




