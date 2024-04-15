# NativeLibsBuildScript
提供常见开源(C/C++)库针对 Android/HarmonyOS 等平台的一键编译脚本

## 使用方法

打开 platform_profile

配置 android sdk 和 默认 ndk 版本

```shell
# 定义Android sdk路径 和 默认 ndk 版本
export ANDROID_SDK_PATH="$HOME/Workspace/Android/sdk"
export ANDROID_NDK_VERSION_DEFAULT="22.1.7171670"
```

配置 harmonyos sdk路径

```shell
# 定义 harmony sdk路径
export HMOS_SDK_PATH="$HOME/Workspace/Huawei/sdk/HarmonyOS-NEXT-DP1"
```

platform_profile 中定义了3个函数

### android_cmake

```shell
echo "Usage:"
echo "  android_cmake -h|--help"
echo "  android_cmake [cmake-args]"
echo "  android_cmake --ndk-version=21 --abi=arm64-v8a --api=21 --stl=c++_shared [other-cmake-args]"
echo "    --ndk-version: ndk的版本号(可以只写主版本, 如22) 如果不指定，则默认为 \${ANDROID_NDK_VERSION_DEFAULT}, 如果指定的版本不存在，则返回错误"
echo "    --abi: 指定abi，支持的值有 armeabi-v7a, arm64-v8a, x86-64, x86"
echo "    --api: 指定api等级"
echo "    --stl: 指定stl库，支持的值有 c++_shared, c++_static, system, none. 不指定默认为c++_shared"
```

### hmos_cmake

```shell
echo "Usage:"
echo "  hmos_cmake --help|-h"
echo "  hmos_cmake [cmake-args]"
echo "  hmos_cmake --abi=armeabi-v7a|arm64-v8a|x86-64|x86 --stl=c++_shared|c++_static [cmake-args]"
echo "    --abi: armeabi-v7a|arm64-v8a|x86-64|x86 必须指定"
echo "    --stl: c++_shared, c++_static 默认为c++_shared"
```

### native_build

```shell
echo "Usage:"
echo "  native_build -h|--help"
echo "  native_build --os=android --abi=armeabi-v7a --api=21 --stl=c++_shared --source=/path/to/source [other-cmake-args]"
echo "  native_build --os=android --abi=arm64-v8a --source=/path/to/source --clean"
echo "     --os:  android, harmonyos. 如果没有指定，则默认为localos，即本地系统"
echo "     --abi: armeabi-v7a, arm64-v8a, x86, x86_64  必须指定"
echo "     --api: android api level 只有在os为android时有效，如果没有指定，则默认为21"
echo "     --ndk-version: android ndk version 只有在os为android时有效，只需要指定主版本号即可，如果没有指定，则默认为ANDROID_NDK_VERSION_DEFAULT"
echo "     --stl: c++_shared, c++_static, 只有在os为android和harmonyos时有效，如果没有指定，则默认为c++_shared"
echo "     --source: 源码地址，只可以是本地路径, 如果没有指定，则默认为当前路径"
echo "     [other-cmake-args]: 其他的cmake参数"
echo "     --clean: 清除编译目录"
echo "编译目录为 source/build/{os}/{abi}"
echo "安装目录为 source/build_install/{os}/{abi}"
```

此函数实际执行了下面的命令

```shell
cmake ${source_dir} && cmake --build . && cmake --install . --prefix ${install_dir}
```

### 例子

```shell
source ../platform_profile

native_build --os=android --abi=arm64-v8a --api=21 --source=./opencv \
        -DBUILD_SHARED_LIBS=OFF \
        -DANDROID_CPP_FEATURES="rtti exceptions" \
        -DWITH_CUDA=OFF \
        -DWITH_MATLAB=OFF \
        -DBUILD_opencv_java=OFF \
        -DBUILD_ANDROID_PROJECTS=OFF \
        -DBUILD_ANDROID_EXAMPLES=OFF \
        -DBUILD_DOCS=OFF \
        -DBUILD_PERF_TESTS=OFF \
        -DBUILD_TESTS=OFF 
```