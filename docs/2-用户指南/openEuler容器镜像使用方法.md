# openEuler 容器镜像使用方法

## 总览

openEuler **基础容器镜像**随着[版本发布](https://openeuler.org/zh/download/), 用户可以通过下载`tarball`的方式获取镜像.

同时, 容器镜像仓库 **[hub.oepkgs.net](https://hub.oepkgs.net/harbor/projects/10/repositories/openeuler)** 也会同步上传容器基础镜像供用户进行拉取.

截止目前(2021-08-20), 已经有五个版本基础容器镜像:

| 版本                                                         | 类别       | 生命周期 | 发布时间   |
| ------------------------------------------------------------ | ---------- | -------- | ---------- |
| [openEuler 20.03 LTS](https://repo.openeuler.org/openEuler-20.03-LTS/) | 标准发行版 | 4 Year   | 2020-03-26 |
| [openEuler 20.09](https://repo.openeuler.org/openEuler-20.09/docker_img/) | 创新发行版 | 6 Month  | 2020-09-29 |
| [openEuler-20.03-LTS-SP1](https://repo.openeuler.org/openEuler-20.03-LTS-SP1/docker_img/) | 补丁版本   | 4 Year   | 2021-03-27 |
| [openEuler-21.03](https://repo.openeuler.org/openEuler-21.03/docker_img/) | 创新发行版 | 6 Month  | 2021-04-01 |
| [openEuler-20.03-LTS-SP2](https://repo.openeuler.org/openEuler-20.03-LTS-SP2/docker_img/) | 补丁版本   | 4 Year   | 2021-07-14 |

## 使用

### Tarball 方式导入

用户可以通过下载 tarball 的方式获取镜像(如上方表格链接), 之后使用`isula(or docker) load -i openEuler-docker.aarch64.tar.xz`的方式导入基础镜像

### 镜像仓库拉取

容器镜像仓库 **[hub.oepkgs.net](https://hub.oepkgs.net/harbor/projects/10/repositories/openeuler)** 已经同步上传容器基础镜像供用户进行拉取, **不同版本镜像通过`tag`来区分**

| 版本                    | tag           | 镜像名称                                         |
| ----------------------- | ------------- | ------------------------------------------------ |
| openEuler 20.03 LTS     | 20.03-lts     | hub.oepkgs.net/openeuler/openeuler:20.03-lts     |
| openEuler 20.09         | 20.09         | hub.oepkgs.net/openeuler/openeuler:20.09         |
| openEuler-20.03-LTS-SP1 | 20.03-lts-sp1 | hub.oepkgs.net/openeuler/openeuler:20.03-lts-sp1 |
| openEuler-21.03         | 21.03         | hub.oepkgs.net/openeuler/openeuler:21.03         |
| openEuler-20.03-LTS-SP2 | 20.03-lts-sp2 | hub.oepkgs.net/openeuler/openeuler:20.03-lts-sp2 |
| ...                     | ...           |                                                  |

用户可以通过以下方式拉取对应版本的镜像

```bash
$ isula pull hub.oepkgs.net/openeuler/openeuler:<tag>
or
$ docker pull hub.oepkgs.net/openeuler/openeuler:<tag>
```

## 说明

### 架构支持

基础镜像支持异构场景, 即不同架构下拉取对应架构的镜像, 用户无需关心对应架构即可拉取主机对应架构下的镜像

目前支持架构:

- amd64(x86_64)
- arm64(aarch64)

### Tag 命名规则

发行版本号加类别, 连接符号为`-`

如发行版`openEuler-20.03-LTS-SP1`:

- 发行版本号: `20.03`
- 类别: `lts-sp1`
- Tag : `20.03-lts-sp1`

创新版本无需增加类别, 如创新版本`openEuler-20.09`:

- 发行版本号: `20.09`
- 类别: NA
- Tag: `20.09`


