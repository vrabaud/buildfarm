#!/bin/bash -ex

if [ ! -e buildfarm/.git ]
then
    git clone git://github.com/willowgarage/buildfarm.git
fi

if [ ! -e catkin/.git ]
then
    git clone git://github.com/willowgarage/catkin.git
fi

PATH=`pwd`/catkin/bin:$PATH

./buildfarm/sanity_check.sh

echo "vvvvvvvvvvvvvvvvvvv  catkin-workspace-all.sh vvvvvvvvvvvvvvvvvvvvvv"

if [ -z "$WORKSPACE" ] ; then
    /bin/echo "Don't see no workspace."
    exit 1
fi


distro_url=https://raw.github.com/willowgarage/rosdistro/master/fuerte.yaml
curl -s $distro_url > distro.yaml

deburls=$(python -c "import yaml; print '\n'.join([x['url'] for x in yaml.load(open('distro.yaml'))])")
cd $WORKSPACE

for x in $deburls
do
    dirname=$(basename ${x%.git})
    if [ -e $dirname/.git ]
    then
	(cd $dirname && git pull)
    else
	git clone $x $dirname
    fi
done


catkin-build-debs-of-workspace

