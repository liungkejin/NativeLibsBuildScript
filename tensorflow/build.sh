#!/bin/bash

### Usage
### ./build.sh --os=android --abi=armeabi-v7a
### ./build.sh --os=android --abi=arm64-v8a

SCRIPT_DIR=$(cd `dirname $0`; pwd)
cd $SCRIPT_DIR && source ../platform_profile 

parse_arguments "$@"

if [[ -z "$BUILD_ARG_SOURCE_DIR" ]]; then
    name="tensorflow-2.18.0"
    repourl="git@github.com:tensorflow/tensorflow.git"

    if ! [ -d $name ]; then
        echo "source code not found, clone from $repourl"
        git clone --branch v2.18.0 $repourl $name
    fi

    [[ -d $name ]] || exit -1

    # 如果没有指定源代码目录，则使用默认目录
    BUILD_ARG_SOURCE_DIR="$SCRIPT_DIR/$name/tensorflow/lite"
    ALL_BUILD_ARGS+=("--source=$BUILD_ARG_SOURCE_DIR")
fi

# 替换 protobuf 的版本，90b73ac3f0b10320315c2ca0d03a5a9b095d2f66 改为 v5.29.2
# $BUILD_ARG_SOURCE_DIR/tools/cmake/modules/protobuf.cmake
sed -i '' 's/90b73ac3f0b10320315c2ca0d03a5a9b095d2f66/v5.29.2/g' "$BUILD_ARG_SOURCE_DIR/tools/cmake/modules/protobuf.cmake"

# 如果需要编译动态库
# 修改 DBUILD_SHARED_LIBS=ON
native_build -DCMAKE_VERBOSE_MAKEFILE:BOOL=ON \
    -DTFLITE_HOST_TOOLS_DIR=$SCRIPT_DIR/$name/tensorflow/lite/tools/cmake/native_tools/flatbuffers/build_install/harmonyos/arm64-v8a/bin \
    -DTFLITE_BUILD_TESTS=ON \
    -DTFLITE_ENABLE_XNNPACK=OFF \
    -DTFLITE_ENABLE_NNAPI=OFF \
    -DTFLITE_ENABLE_GPU=OFF \
    -DBUILD_SHARED_LIBS=ON \
    "${ALL_BUILD_ARGS[@]}"