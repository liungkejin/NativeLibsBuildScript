#!/bin/bash

# https://chromium.googlesource.com/libyuv/libyuv 
# ./build.sh --os=android --abi=arm64-v8a --ndk_version=22 --api=21
#

# set -x

LOCAL_DIR=$(pwd)
SCRIPT_DIR=$(cd `dirname $0`; pwd)

cd $SCRIPT_DIR && source ../platform_profile 

name="libyuv"

if ! [ -d $name ]; then
    echo "source code not found, clone from https://chromium.googlesource.com/libyuv/libyuv"
    git clone --branch stable https://chromium.googlesource.com/libyuv/libyuv $name
fi

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

cd $name && native_build $@