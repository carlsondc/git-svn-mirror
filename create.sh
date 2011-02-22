#!/bin/sh
set -x
if [ $# -lt 2 ]
then
    echo "Usage: $0 src dest [extra git svn clone options]"
    echo "Frequently used options: --stdlayout, -r revisionStart:revisionEnd"
    exit 1
fi

src=$1
shift 1
dest=$1
shift 1

git svn clone $@ --prefix=svn/ $src $dest 
#$(dirname $0)/synch.sh $dest
