#!/bin/bash

# ./build.sh --os=harmonyos --abi arm64-v8a
# ./build.sh --os=harmonyos --abi armeabi-v7a
# ./build.sh --os=harmonyos --abi x86-64

SCRIPT_DIR=$(cd `dirname $0`; pwd)
cd $SCRIPT_DIR && source ../platform_profile 

name="fmt-10.2.1"
repourl="git@github.com:fmtlib/fmt.git"

if ! [ -d $name ]; then
    echo "source code not found, clone from $repourl"
    git clone --branch 10.2.1 $repourl $name
fi
cd $name || exit -1

# -DBUILD_SHARED_LIBS=ON
native_build -DFMT_TEST=OFF $@