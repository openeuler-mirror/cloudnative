# openeuler/distroless镜像脚本构建
## 一、openeuler/distroless：static镜像

构建`openeuler/distroless：static`的`rootfs`包见`static/static_image_build.sh`脚本，该镜像只安装四个包，静态编译(不需要`glibc`支持)的应用可以使用该镜像进行构建。

```
setup
filesystem
tzdata
ca-certificates
```

新增`nologin`用户`nonroot`方便使用非`root`用户。

## 二、openeuler/distroless：base镜像

构建`openeuler/distroless：base`的`rootfs`包见`base/basic_image_build.sh`脚本，该镜像在`static`镜像的基础，另外装了3个包，大多数应用可以使用该镜像进行构建。

```
glibc
openssl-libs
openssl
```

## 三、openeuler/distroless：debug镜像

构建`openeuler/distroless：debug`的`rootfs`包见`debug/debug_image_build.sh`脚本，该镜像在`base`镜像的基础，增加了`busybox`的命令工具。

## 四、openeuler/distroless：python3镜像
构建`openeuler/distroless：python3`的`rootfs`包见`python3/python3_image_build.sh`脚本，该镜像在`base`镜像的基础，增加了`python3`和它的依赖。
```
libxcrypt
python3
glibc-common
zlib
sqlite
readline
xz-libs
ncurses-libs
libffi
bzip2
expat
libnsl2
libtirpc
e2fsprogs
krb5-libs
keyutils-libs
libselinux
pcre2
```

## 五、使用方法

用户可以运行脚本

构建`static`镜像

```
# ./static_image_build.sh openeuler-version openeuler-arch imagename
```

构建`base`镜像

```
# ./base_image_build.sh openeuler-version openeuler-arch imagename
```

其中`openeuler-version`和`openeuler-arch`是要构建`distroless`镜像的版本和架构，`imagename`是打包`rootfs`的名字

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

运行该命令，可以在当前目录下得到生成的`rootfs tarball`—`imagename.img.xz`，导入该`tarball`，就可以使用该`distroless`镜像。