#!/bin/bash

### Usage
### ./build.sh --os=android --abi=armeabi-v7a
### ./build.sh --os=android --abi=arm64-v8a

SCRIPT_DIR=$(cd `dirname $0`; pwd)
cd $SCRIPT_DIR && source ../platform_profile 

parse_arguments "$@"
# echo "${ALL_BUILD_ARGS[@]}"
# echo "${BUILD_ARG_OS}"
# exit

if [[ -z "$BUILD_ARG_SOURCE_DIR" ]]; then
    name="insightface"
    repourl="git@github.com:deepinsight/insightface.git"

    if ! [ -d $name ]; then
        echo "source code not found, clone from $repourl"
        git clone $repourl $name

        name="$name/cpp-package/inspireface"
        cd $name
        git clone --recurse-submodules https://github.com/HyperInspire/3rdparty.git
    else
        name="$name/cpp-package/inspireface"
    fi

    [[ -d $name ]] || exit -1

    # 如果没有指定源代码目录，则使用默认目录
    BUILD_ARG_SOURCE_DIR="$SCRIPT_DIR/$name"
    ALL_BUILD_ARGS+=("--source=$BUILD_ARG_SOURCE_DIR")
fi

OPENCV_DIR="$SCRIPT_DIR/../opencv/opencv-4.9.0/build_install/$BUILD_ARG_OS/$BUILD_ARG_ABI/lib/cmake/opencv4"
if ! [[ -d "${OPENCV_DIR}" ]]; then
    echo "${OPENCV_DIR} not exists!"
    exit -1
fi

## 编译静态库，需要两个.a, 一个是 libInsipreFace.a, 一个是 libMNN.a (cpp-package/inspireface/build/$OS/$ABI/3rdparty/MNN/libMNN.a)
native_build "${ALL_BUILD_ARGS[@]}" -DCMAKE_BUILD_TYPE=Release \
        -DISF_BUILD_WITH_SAMPLE=OFF \
        -DISF_BUILD_WITH_TEST=OFF \
        -DISF_ENABLE_BENCHMARK=OFF \
        -DISF_ENABLE_USE_LFW_DATA=OFF \
        -DISF_ENABLE_TEST_EVALUATION=OFF \
        -DISF_BUILD_SHARED_LIBS=OFF \
        -DOpenCV_DIR=${OPENCV_DIR}