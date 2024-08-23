#!/bin/bash

### Usage
### ./build.sh --os=android --abi=armeabi-v7a
### ./build.sh --os=android --abi=arm64-v8a

SCRIPT_DIR=$(cd `dirname $0`; pwd)
cd $SCRIPT_DIR && source ../platform_profile 

parse_arguments "$@"

if [[ -z "$BUILD_ARG_SOURCE_DIR" ]]; then
    name="opencv-4.9.0"
    repourl="git@github.com:opencv/opencv.git"

    if ! [ -d $name ]; then
        echo "source code not found, clone from $repourl"
        git clone --branch 4.9.0 $repourl $name
    fi

    [[ -d $name ]] || exit -1

    # 如果没有指定源代码目录，则使用默认目录
    BUILD_ARG_SOURCE_DIR="$SCRIPT_DIR/$name"
    ALL_BUILD_ARGS+=("--source=$BUILD_ARG_SOURCE_DIR")
fi

# 如果需要编译动态库
# 修改 DBUILD_SHARED_LIBS=ON
native_build -DBUILD_SHARED_LIBS=OFF \
        -DANDROID_CPP_FEATURES="rtti exceptions" \
        -D WITH_CUDA=OFF \
        -D WITH_MATLAB=OFF \
        -D BUILD_opencv_java=OFF \
        -D BUILD_ANDROID_PROJECTS=OFF \
        -D BUILD_ANDROID_EXAMPLES=OFF \
        -D BUILD_DOCS=OFF \
        -D BUILD_PERF_TESTS=OFF \
        -D BUILD_TESTS=OFF "${ALL_BUILD_ARGS[@]}"