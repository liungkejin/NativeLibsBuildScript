#!/bin/bash

# https://chromium.googlesource.com/libyuv/libyuv 
# ./build.sh --os=android --abi=arm64-v8a --ndk_version=22 --api=21
# ./build.sh --os=harmonyos --abi=arm64-v8a

# set -x

SCRIPT_DIR=$(cd `dirname $0`; pwd)
cd $SCRIPT_DIR && source ../platform_profile 

name="libyuv-stable"
repourl="https://chromium.googlesource.com/libyuv/libyuv"

if ! [ -d $name ]; then
    echo "source code not found, clone from $repourl"
    git clone --branch stable $repourl $name
fi
cd $name || exit -1

# 对于 arm64-v8a 架构.
# 如果出现 
# clang++: error: the clang compiler does not support '-march=armv8-a+dotprod+i8mm'
# 或
# clang++: error: the clang compiler does not support '-march=armv9-a+sve2'
#
# 则是因为 clang 的版本过低, 即使用的 ndk version 过低, 需要升级 ndk version. 
# 支持 '-march=armv8-a+dotprod+i8mm' 的最低 ndk version 为 '22.1.7171670'
# 支持 '-march=armv9-a+sve2' 的最低 ndk version 为 'r24'
# 或者下载老版本
# git clone --branch stable https://chromium.googlesource.com/libyuv/libyuv $name

native_build $@