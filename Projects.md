# 项目清单

项目清单分类方式如下：

1. 以原创项目和开源引入为一级分类；
2. 以项目在云原生的生态位置为二级分类；

## 原创项目

### 编排&管理

负责人： @duguhaotian

| 项目                                       | 版本  | 状态     | 类别           | committer |
| ------------------------------------------ | ----- | -------- | -------------- | --------- |
| [paws](https://gitee.com/openeuler/paws)   | 0     | 孵化中   | 性能分析、混部 | NA        |
| [rubik](https://gitee.com/openeuler/rubik) | 2.0.0 | 已落版本 | 混部           | NA        |

### 运行时

负责人： @duguhaotian @xuxuepeng

| 项目                                                 | 版本  | 状态     | 类别       | committer |
| ---------------------------------------------------- | ----- | -------- | ---------- | --------- |
| [WasmEngine](https://gitee.com/openeuler/WasmEngine) | 0.1.2 | 已落版本 | 容器运行时 | NA        |

iSulad 项目请参考 [iSulad 相关项目](#isulad)

### 应用定义&开发

负责人： @jianminw

| 项目                                                                     | 版本 | 状态   | 类别                  | committer |
| ------------------------------------------------------------------------ | ---- | ------ | --------------------- | --------- |
| [operator-manager](https://gitee.com/openeuler/operator-manager)         | 2    | 孵化中 | 应用程序定义&镜像构建 | NA        |
| [mcp](https://gitee.com/openeuler/mcp)                                   | 0    | 孵化中 | 多云管理              | NA        |
| [mcp-self-service-vue](https://gitee.com/openeuler/mcp-self-service-vue) | 0    | 孵化中 | 多云管理              | NA        |
| [mcp-vue](https://gitee.com/openeuler/mcp-vue)                           | 0    | 孵化中 | 多云管理              | NA        |
| [ktib](https://gitee.com/openeuler/ktib)                                 | 0    | 孵化中 | 镜像构建              | NA        |

### 监控、分析、跟踪

负责人： @pencc

| 项目                                                         | 版本 | 状态     | 类别     | committer |
| ------------------------------------------------------------ | ---- | -------- | -------- | --------- |
| [Cpds](https://gitee.com/openeuler/Cpds)                     | 1.0  | 已落版本 | 分析     | NA        |
| [cpds-agent](https://gitee.com/openeuler/cpds-agent)         | 1.0  | 已落版本 | Cpds组件 | NA        |
| [cpds-analyzer](https://gitee.com/openeuler/cpds-analyzer)   | 1.0  | 已落版本 | Cpds组件 | NA        |
| [cpds-dashboard](https://gitee.com/openeuler/cpds-dashboard) | 1.0  | 已落版本 | Cpds组件 | NA        |
| [cpds-detector](https://gitee.com/openeuler/cpds-detector)   | 1.0  | 已落版本 | Cpds组件 | NA        |
| [KubeHawk](https://gitee.com/openeuler/KubeHawk)             | 0    | 孵化中   | 跟踪监控 | NA        |
| [KubeHawkeyes](https://gitee.com/openeuler/KubeHawkeyes)     | 0    | 孵化中   | 跟踪监控 | NA        |

### 安装部署

负责人： @duguhaotian @wonleing

| 项目                                                   | 版本  | 状态     | 类别                   | committer |
| ------------------------------------------------------ | ----- | -------- | ---------------------- | --------- |
| [eggo](https://gitee.com/openeuler/eggo)               | 0.9.4 | 已落版本 | Kubernetes集群一键部署 | NA        |
| [k8s-install](https://gitee.com/openeuler/k8s-install) | 0     | 孵化中   | 安装部署               | NA        |

### 服务提供

负责人： @jianminw  @lu-wei-army

| 项目                                                                           | 版本 | 状态   | 类别                      | committer |
| ------------------------------------------------------------------------------ | ---- | ------ | ------------------------- | --------- |
| [openeuler-docker-images](https://gitee.com/openeuler/openeuler-docker-images) | 0    | 已落版本 | openEuler官方容器镜像管理 | NA        |

### 容器OS

负责人： @yangzhao_kl @wonleing

| 项目                                                             | 版本   | 状态     | 备注                                    | committer                                     |
| ---------------------------------------------------------------- | ------ | -------- | --------------------------------------- | --------------------------------------------- |
| [NestOS](https://gitee.com/openeuler/NestOS)                     | 0      | 已落版本 | 从Fedora CoreOS衍生出来的云底座操作系统 | NA                                            |
| [nestos-assembler](https://gitee.com/openeuler/nestos-assembler) | 0      | 已落版本 | NestOS组件                              | NA                                            |
| [nestos-config](https://gitee.com/openeuler/nestos-config)       | 0      | 已落版本 | NestOS组件                              | NA                                            |
| [nestos-installer](https://gitee.com/openeuler/nestos-installer) | 0.16.0 | 已落版本 | NestOS组件                              | NA                                            |
| [nestos-kernel](https://gitee.com/openeuler/nestos-kernel)       | 0      | 已落版本 | NestOS组件                              | NA                                            |
| [nestos-website](https://gitee.com/openeuler/nestos-website)     | 0      | 已落版本 | NestOS组件                              | NA                                            |
| [KubeOS](https://gitee.com/openeuler/KubeOS)                     | 1.0.3  | 已落版本 | 由K8s进行生命周期管理的云原生OS         | [@li-yuanrong](https://gitee.com/li-yuanrong) |
| [KubeMate](https://gitee.com/openeuler/KubeMate)                 | 0      | 孵化中   | 云原生 OS 运维                          | NA                                            |

### 依赖组件

负责人： @duguhaotian @xuxuepeng

| 项目                                                                     | 版本  | 状态     | 备注             | committer |
| ------------------------------------------------------------------------ | ----- | -------- | ---------------- | --------- |
| [ptcr](https://gitee.com/openeuler/ptcr)                                 | 0     | 孵化中   | 容器性能测试工具 | NA        |
| [kata_integration](https://gitee.com/openeuler/kata_integration)         | 1.0.0 | 已落版本 | kata构建工程     | NA        |
| [yunyi](https://gitee.com/openeuler/yunyi)                               | 0     | 孵化中   | 缓存管理中间件   | NA        |
| [resaware_nri_plugins](https://gitee.com/openeuler/resaware_nri_plugins) | 0.0.1 | 已落版本 | 容器资源管理     | NA        |

----------

## 开源引入项目

### 编排&管理

负责人： @weibaohui  @xuxuepeng  @zmr_2020

| 项目                                                     | 版本   | 状态     | 类别          | committer                             |
| -------------------------------------------------------- | ------ | -------- | ------------- | ------------------------------------- |
| [kubernetes](https://gitee.com/src-openeuler/kubernetes) | 1.25.3 | 已落版本 | 调度&编排     | NA                                    |
| [etcd](https://gitee.com/src-openeuler/etcd)             | 3.4.14 | 已落版本 | 协调&服务发现 | [@jxy_git](https://gitee.com/jxy_git) |
| [coredns](https://gitee.com/src-openeuler/coredns)       | 1.7.0  | 已落版本 | 协调&服务发现 | NA                                    |

### 运行时

负责人： @xuxuepeng @gaodaweiky @zmr_2020

| 项目                                                                                       | 版本         | 状态     | 类别                  | committer                                       |
| ------------------------------------------------------------------------------------------ | ------------ | -------- | --------------------- | ----------------------------------------------- |
| [kuasar](https://gitee.com/src-openeuler/kuasar)                                           | 0.1.0        | 已落版本 | 统一容器运行时        | NA                                              |
| [docker](https://gitee.com/src-openeuler/docker)                                           | 18.09.0      | 已落版本 | 容器引擎              | [@zhangsong234](https://gitee.com/zhangsong234) |
| [moby](https://gitee.com/src-openeuler/moby)                                               | 20.10.24     | 已落版本 | 容器引擎              | NA                                              |
| [containerd](https://gitee.com/src-openeuler/containerd)                                   | 1.6.22       | 已落版本 | 容器运行时            | [@zhangsong234](https://gitee.com/zhangsong234) |
| [runc](https://gitee.com/src-openeuler/runc)                                               | 1.1.8        | 已落版本 | 容器运行时            | [@zhangsong234](https://gitee.com/zhangsong234) |
| [kata-containers](https://gitee.com/src-openeuler/kata-containers)                         | 2.1.0/1.11.1 | 已落版本 | 容器运行时            | NA                                              |
| [libnetwork](https://gitee.com/src-openeuler/libnetwork)                                   | 0.8.0-dev    | 已落版本 | Docker网络组件        | NA                                              |
| [containernetworking-plugins](https://gitee.com/src-openeuler/containernetworking-plugins) | 1.2.0        | 已落版本 | CNI容器网络           | NA                                              |
| [cri-o](https://gitee.com/src-openeuler/cri-o)                                             | 1.23.2       | 已落版本 | 容器运行时            | NA                                              |
| [cri-tools](https://gitee.com/src-openeuler/cri-tools)                                     | 1.24.2       | 已落版本 | 引擎CRI工具           | NA                                              |
| [gvisor](https://gitee.com/src-openeuler/gvisor)                                           | 20220425.0   | 引入中   | 容器运行时            | NA                                              |
| [crun](https://gitee.com/src-openeuler/crun)                                               | 1.8.1        | 已落版本 | 容器运行时            | NA                                              |
| [catatonit](https://gitee.com/src-openeuler/catatonit)                                     | 0.1.7        | 已落版本 | 容器运行时            | NA                                              |
| [podman](https://gitee.com/src-openeuler/podman)                                           | 4.5.1        | 已落版本 | 应用程序定义&镜像构建 | NA                                              |

### 应用定义&开发

负责人： @jianminw @wonleing

| 项目                                                             | 版本   | 状态     | 类别                  | committer |
| ---------------------------------------------------------------- | ------ | -------- | --------------------- | --------- |
| [docker-compose](https://gitee.com/src-openeuler/docker-compose) | 1.22.0 | 已落版本 | 应用程序定义&镜像构建 | NA        |
| [skopeo](https://gitee.com/src-openeuler/skopeo)                 | 1.8.0  | 已落版本 | 应用程序定义&镜像构建 | NA        |
| [kubevirt](https://gitee.com/src-openeuler/kubevirt)             | 0.54.0 | 引入中   | 应用程序定义&镜像构建 | NA        |
| [buildah](https://gitee.com/src-openeuler/buildah)               | 1.26.1 | 已落版本 | 镜像构建              | NA        |
| [umoci](https://gitee.com/src-openeuler/umoci)                   | 0.4.7  | 已落版本 | 镜像管理工具          | NA        |

### 监控、分析、跟踪

负责人： @yangzhao_kl @gaodaweiky

| 项目                                                                     | 版本   | 状态     | 类别         | committer                             |
| ------------------------------------------------------------------------ | ------ | -------- | ------------ | ------------------------------------- |
| [prometheus](https://gitee.com/src-openeuler/prometheus)                 | 2.53.3 | 已落版本 | 监控分析跟踪 | [@jxy_git](https://gitee.com/jxy_git) |
| [promu](https://gitee.com/src-openeuler/promu)                           | 0.17.0 | 已落版本 | 监控分析跟踪 | [@jxy_git](https://gitee.com/jxy_git) |
| [cadvisor](https://gitee.com/src-openeuler/cadvisor)                     | 0.37.0 | 已落版本 | 监控分析跟踪 | [@jxy_git](https://gitee.com/jxy_git) |
| [alertmanager](https://gitee.com/src-openeuler/alertmanager)             | 0.27.0 | 已落版本 | 监控分析跟踪 | [@jxy_git](https://gitee.com/jxy_git) |
| [node_exporter](https://gitee.com/src-openeuler/node_exporter)           | 1.8.1  | 已落版本 | 监控分析跟踪 | [@jxy_git](https://gitee.com/jxy_git) |
| [virt-what](https://gitee.com/src-openeuler/virt-what)                   | 1.25   | 已落版本 | 监控分析跟踪 | NA                                    |
| [gluster_exporter](https://gitee.com/src-openeuler/gluster_exporter)     | 0.2.7  | 引入中   | 监控分析跟踪 | [@jxy_git](https://gitee.com/jxy_git) |
| [haproxy_exporter](https://gitee.com/src-openeuler/haproxy_exporter)     | 0.15.0 | 引入中   | 监控分析跟踪 | [@jxy_git](https://gitee.com/jxy_git) |
| [influxdb_exporter](https://gitee.com/src-openeuler/influxdb_exporter)   | 0.11.5 | 引入中   | 监控分析跟踪 | [@jxy_git](https://gitee.com/jxy_git) |
| [memcached_exporter](https://gitee.com/src-openeuler/memcached_exporter) | 0.14.4 | 引入中   | 监控分析跟踪 | [@jxy_git](https://gitee.com/jxy_git) |
| [pushgateway](https://gitee.com/src-openeuler/pushgateway)               | 1.9.0  | 已落版本 | 监控分析跟踪 | [@jxy_git](https://gitee.com/jxy_git) |
| [blackbox_exporter](https://gitee.com/src-openeuler/blackbox_exporter)   | 0.25.0 | 已落版本 | 监控分析跟踪 | [@jxy_git](https://gitee.com/jxy_git) |
| [mysqld_exporter](https://gitee.com/src-openeuler/mysqld_exporter)       | 0.15.1 | 引入中   | 监控分析跟踪 | [@jxy_git](https://gitee.com/jxy_git) |
| [redis_exporter](https://gitee.com/src-openeuler/redis_exporter)         | 1.66.0 | 引入中   | 监控分析跟踪 | [@jxy_git](https://gitee.com/jxy_git) |

### 服务提供

负责人： @jianminw @lu-wei-army

| 项目                                                                   | 版本  | 状态     | 类别               | committer |
| ---------------------------------------------------------------------- | ----- | -------- | ------------------ | --------- |
| [harbor](https://gitee.com/src-openeuler/harbor)                       | 2.4.1 | 引入中   | 容器镜像仓库       | NA        |
| [containers-common](https://gitee.com/src-openeuler/containers-common) | 1     | 已落版本 | 自动化&配置        | NA        |
| [awscli](https://gitee.com/src-openeuler/awscli)                       |       | 引入中   | 亚马逊网络服务接口 | NA        |

### 依赖组件

负责人： @weibaohui @lu-wei-army @zmr_2020

| 项目                                                                                           | 版本     | 状态     | 备注                   | committer |
| ---------------------------------------------------------------------------------------------- | -------- | -------- | ---------------------- | --------- |
| [protobuf](https://gitee.com/src-openeuler/protobuf)                                           | 3.19.6   | 已落版本 | iSulad依赖             | NA        |
| [busybox](https://gitee.com/src-openeuler/busybox)                                             | 1.36.1   | 已落版本 | 容器镜像依赖           | NA        |
| [docker-client-java](https://gitee.com/src-openeuler/docker-client-java)                       | 8.11.7   | 已落版本 | 依赖组件               | NA        |
| [container-selinux](https://gitee.com/src-openeuler/container-selinux)                         | 2.163    | 已落版本 | docker配套selinux策略  | NA        |
| [jboss-parent](https://gitee.com/src-openeuler/jboss-parent)                                   | 39       | 已落版本 | 依赖组件               | NA        |
| [libevhtp](https://gitee.com/src-openeuler/libevhtp)                                           | 1.2.18   | 已落版本 | iSulad依赖             | NA        |
| [libcgroup](https://gitee.com/src-openeuler/libcgroup)                                         | 3.1.0    | 已落版本 | 容器依赖               | NA        |
| [afterburn](https://gitee.com/src-openeuler/afterburn)                                         | 5.4.2    | 已落版本 | NestOS依赖             | NA        |
| [butane](https://gitee.com/src-openeuler/butane)                                               | 0.14.0   | 已落版本 | NestOS依赖             | NA        |
| [console-login-helper-messages](https://gitee.com/src-openeuler/console-login-helper-messages) | 0.21.3   | 已落版本 | NestOS依赖             | NA        |
| [dumb-init](https://gitee.com/src-openeuler/dumb-init)                                         | 1.2.5    | 已落版本 | NestOS依赖             | NA        |
| [fuse-overlayfs](https://gitee.com/src-openeuler/fuse-overlayfs)                               | 1.12     | 已落版本 | NestOS依赖             | NA        |
| [fuse-sshfs](https://gitee.com/src-openeuler/fuse-sshfs)                                       | 3.7.3    | 已落版本 | NestOS依赖             | NA        |
| [libslirp](https://gitee.com/src-openeuler/libslirp)                                           | 4.7.0    | 已落版本 | NestOS依赖             | NA        |
| [libvarlink](https://gitee.com/src-openeuler/libvarlink)                                       | 23       | 已落版本 | NestOS依赖             | NA        |
| [netavark](https://gitee.com/src-openeuler/netavark)                                           | 1.0.10   | 已落版本 | NestOS依赖             | NA        |
| [slirp4netns](https://gitee.com/src-openeuler/slirp4netns)                                     | 1.2.0    | 已落版本 | NestOS依赖             | NA        |
| [ssh-key-dir](https://gitee.com/src-openeuler/ssh-key-dir)                                     | 0.1.4    | 已落版本 | NestOS依赖             | NA        |
| [stalld](https://gitee.com/src-openeuler/stalld)                                               | 1.16     | 已落版本 | NestOS依赖             | NA        |
| [toolbox](https://gitee.com/src-openeuler/toolbox)                                             | 0.0.99   | 已落版本 | NestOS依赖             | NA        |
| [WALinuxAgent](https://gitee.com/src-openeuler/WALinuxAgent)                                   | 2.9.0    | 已落版本 | NestOS依赖             | NA        |
| [zchunk](https://gitee.com/src-openeuler/zchunk)                                               | 1.3.2    | 已落版本 | NestOS依赖             | NA        |
| [zincati](https://gitee.com/src-openeuler/zincati)                                             | 0.0.24   | 已落版本 | NestOS依赖             | NA        |
| [zram-generator](https://gitee.com/src-openeuler/zram-generator)                               | 1.1.2    | 已落版本 | NestOS依赖             | NA        |
| [bats](https://gitee.com/src-openeuler/bats)                                                   | 1.9.0    | 已落版本 | bash依赖兼容性测试框架 | NA        |
| [calico](https://gitee.com/src-openeuler/calico)                                               | 0        | 引入中   | K8s容器网络            | NA        |
| [parallel](https://gitee.com/src-openeuler/parallel)                                           | 20230622 | 已落版本 | 并行计算工具           | NA        |
| [python-kubernetes](https://gitee.com/src-openeuler/python-kubernetes)                         | 25.3.0   | 已落版本 | python版本的K8s客户端  | NA        |
| [ShellCheck](https://gitee.com/src-openeuler/ShellCheck)                                       | 0        | 引入中   | 格式化工具             | NA        |
| [virtiofsd](https://gitee.com/src-openeuler/virtiofsd)                                         | 1.10.1   | 已落版本 | 虚拟化文件共享         | NA        |
| [OpenTofu](https://gitee.com/src-openeuler/opentofu)                                           | 1.6.2    | 已落版本 | 管理基础设施           | NA        |
| [ollama](https://gitee.com/src-openeuler/ollama)                                               | 0        | 引入中   | 大模型运行框架         | NA        |
| [gradio](https://gitee.com/src-openeuler/gradio)                                               | 0        | 已落版本 | 大模型管理 UI 库       | NA        |

## 相关项目

### iSulad

由 [iSulad SIG](https://gitee.com/openeuler/community/tree/master/sig/iSulad) 负责

| 项目                                                   | 版本  | 状态     | 类别                    | committer |
| ------------------------------------------------------ | ----- | -------- | ----------------------- | --------- |
| [iSulad](https://gitee.com/openeuler/iSulad)           | 2.1.4 | 已落版本 | 容器引擎                | NA        |
| [lcr](https://gitee.com/openeuler/lcr)                 | 2.1.3 | 已落版本 | 容器运行时              | NA        |
| [clibcni](https://gitee.com/openeuler/clibcni)         | 2.1.0 | 已落版本 | iSulad网络组件          | NA        |
| [isula-build](https://gitee.com/openeuler/isula-build) | 0.9.6 | 已落版本 | 应用程序定义&镜像构建   | NA        |
| [lxc](https://gitee.com/src-openeuler/lxc)             | 5.0.2 | 已落版本 | 容器运行时              | NA        |
| [iSulad-img](https://gitee.com/openeuler/iSulad-img)   | 2.0.1 | 已清退   | iSulad 1.x 镜像管理工具 | NA        |

### 说明

| 组件状态 | 说明                                                                     |
| -------- | ------------------------------------------------------------------------ |
| 已落版本 | 该组件已落openEuler发行版本                                              |
| 引入中   | 该组件已在openEuler建仓且代码正在从上游社区引入，待进入openEuler发行版本 |
| 孵化中   | 该组件由CloudNative SIG所孵化，待进入openEuler发行版                     |
| 已建仓   | 该组件在openEuler中已建仓，尚需从上游社区引入源码. Help wanted~          |
| 待引入   | 该组件有需求，但尚未在openEuler中建仓                                    |
| 已清退   | 该组件已不适用，并且从openEuler版本删除，仓库被归档                      |
