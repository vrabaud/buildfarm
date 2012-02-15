#!/bin/bash -eu

# verify existance of arguments
if [ $# -ne 2 ] ; then
  /bin/echo "Missing arguments. Usage: $0 PATH VERSION"
  exit 1
fi
PATH=$1
VERSION=$2

# filename to store version
FILENAME="${PATH/\//_}-version.txt"

# get previous version
PREVIOUS=""
if [ -f $FILENAME ] ; then
  PREVIOUS=`/bin/cat $FILENAME`
fi

# compare versions and clear folder if not equal
if [ "$VERSION" != "$PREVIOUS" ] ; then
  /bin/echo "Removing path '$PATH' due to changed version..."
  /bin/rm -rf $PATH
fi

# store version for comparison in next cycle
echo $VERSION > $FILENAME

