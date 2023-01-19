# 基础镜像构建脚本

### 一、使用方法

要安装基础镜像rootfs包的软件包，需要提前设置好软件包的`yum`源，用户可以在官方镜像源`https://repo.huaweicloud.com/openeuler`找到需要的`yum`源。用户可以运行脚本

```
# ./basic_image_build.sh openeuler-version openeuler-arch imagename
```

其中`openeuler-version`和`openeuler-arch`是要构建基础镜像的版本和架构，`imagename`是打包`rootfs`的名字

`openeuler-version`支持以下版本

- 20.03-LTS
- 20.03-LTS-SP1
- 20.03-LTS-SP2
- 20.03-LTS-SP3
- 20.09
- 21.03
- 21.09
- 22.03-LTS
- 22.03-LTS-SP1
- 22.09

`openeuler-arch`支持以下架构

- x86_64
- aarch64

运行该命令，可以在当前目录下得到生成的`rootfs tarball`—`imagename.img.xz`，导入该`tarball`，就可以使用该基础镜像。

### 二、使用示例

```
# ./basic_image_build.sh 22.03-LTS x86_64 openeuler_22.03_x84_64
```

在当前脚本目录下生成`rootfs tarball`

```
openeuler_22.03_x84_64.img.xz
```

导入该`tarball`，使用该基础镜像

```
# docker import openeuler_22.03_x84_64.img.xz openeuler_22.03_x84_64
```

```
# docker run -it openeuler_22.03_x84_64 /bin/bash
[root@a3c5acb18e67 /]#
```