# Project list

The project list is categorized as follows:

1. Original projects and upstream-integrated projects are the first-level categories;
2. Use the ecological position of the project in cloud native as the secondary classification;

## Original projects

### Orchestration & Management

Maintainers: @duguhaotian

| Project                                    | Version | State      | Category             | Committer |
| ------------------------------------------ | ------- | ---------- | -------------------- | --------- |
| [paws](https://gitee.com/openeuler/paws)   | 0       | Incubating | Performance analysis | NA        |
| [rubik](https://gitee.com/openeuler/rubik) | 2.0.0   | Introduced | Hybrid deployment    | NA        |

### Container Runtime

Maintainers: @duguhaotian @xuxuepeng

| Project                                              | Version | State      | Category          | Committer |
| ---------------------------------------------------- | ------- | ---------- | ----------------- | --------- |
| [WasmEngine](https://gitee.com/openeuler/WasmEngine) | 0.1.2   | Introduced | Container runtime | NA        |

For projects related to iSulad, refer to [iSulad Related Projects](#isulad)

### App Definition & Development

Maintainers: @jianminw

| Project                                                                  | Version | State      | Category                             | Committer |
| ------------------------------------------------------------------------ | ------- | ---------- | ------------------------------------ | --------- |
| [operator-manager](https://gitee.com/openeuler/operator-manager)         | 2       | Incubating | Application Definition & Image Build | NA        |
| [mcp](https://gitee.com/openeuler/mcp)                                   | 0       | Incubating | Multi-cloud management               | NA        |
| [mcp-self-service-vue](https://gitee.com/openeuler/mcp-self-service-vue) | 0       | Incubating | Multi-cloud management               | NA        |
| [mcp-vue](https://gitee.com/openeuler/mcp-vue)                           | 0       | Incubating | Multi-cloud management               | NA        |
| [ktib](https://gitee.com/openeuler/ktib)                                 | 0       | Incubating | Image Build                          | NA        |

### Observability & Analysis & Tracking

Maintainers: @pencc

| Project                                                      | Version | State      | Category                 | Committer |
| ------------------------------------------------------------ | ------- | ---------- | ------------------------ | --------- |
| [Cpds](https://gitee.com/openeuler/Cpds)                     | 1.0     | Introduced | Analysis                 | NA        |
| [cpds-agent](https://gitee.com/openeuler/cpds-agent)         | 1.0     | Introduced | Cpds components          | NA        |
| [cpds-analyzer](https://gitee.com/openeuler/cpds-analyzer)   | 1.0     | Introduced | Cpds components          | NA        |
| [cpds-dashboard](https://gitee.com/openeuler/cpds-dashboard) | 1.0     | Introduced | Cpds components          | NA        |
| [cpds-detector](https://gitee.com/openeuler/cpds-detector)   | 1.0     | Introduced | Cpds components          | NA        |
| [KubeHawk](https://gitee.com/openeuler/KubeHawk)             | 0       | Incubating | Observability & Tracking | NA        |
| [KubeHawkeyes](https://gitee.com/openeuler/KubeHawkeyes)     | 0       | Incubating | Observability & Tracking | NA        |

### Installation & Deployment

Maintainers: @duguhaotian @wonleing

| Project                                                | Version | State      | Category                             | Committer |
| ------------------------------------------------------ | ------- | ---------- | ------------------------------------ | --------- |
| [eggo](https://gitee.com/openeuler/eggo)               | 0.9.4   | Introduced | Kubernetes deployment by one command | NA        |
| [k8s-install](https://gitee.com/openeuler/k8s-install) | 0       | Incubating | Installation & Deployment            | NA        |

### Provisioning

Maintainers: @jianminw  @lu-wei-army

| Project                                                                        | Version | State      | Category                                      | Committer |
| ------------------------------------------------------------------------------ | ------- | ---------- | --------------------------------------------- | --------- |
| [openeuler-docker-images](https://gitee.com/openeuler/openeuler-docker-images) | 0       | Introduced | openEuler Official container image management | NA        |

### ContainerOS

Maintainers: @yangzhao_kl @wonleing

| Project                                                          | Version | State      | Category                               | Committer                                     |
| ---------------------------------------------------------------- | ------- | ---------- | -------------------------------------- | --------------------------------------------- |
| [NestOS](https://gitee.com/openeuler/NestOS)                     | 0       | Introduced | A cloudify OS drivied from CoreOS      | NA                                            |
| [nestos-assembler](https://gitee.com/openeuler/nestos-assembler) | 0       | Introduced | NestOS components                      | NA                                            |
| [nestos-config](https://gitee.com/openeuler/nestos-config)       | 0       | Introduced | NestOS components                      | NA                                            |
| [nestos-installer](https://gitee.com/openeuler/nestos-installer) | 0.16.0  | Introduced | NestOS components                      | NA                                            |
| [nestos-kernel](https://gitee.com/openeuler/nestos-kernel)       | 0       | Introduced | NestOS components                      | NA                                            |
| [nestos-website](https://gitee.com/openeuler/nestos-website)     | 0       | Introduced | NestOS components                      | NA                                            |
| [KubeOS](https://gitee.com/openeuler/KubeOS)                     | 1.0.3   | Introduced | A Kubernetes OS simplifies OS updating | [@li-yuanrong](https://gitee.com/li-yuanrong) |
| [KubeMate](https://gitee.com/openeuler/KubeMate)                 | 0       | Incubating | OS Operations                          | NA                                            |

### Dependent Component

Maintainers: @duguhaotian @xuxuepeng

| Project                                                                  | Version | State      | Category                            | Committer |
| ------------------------------------------------------------------------ | ------- | ---------- | ----------------------------------- | --------- |
| [ptcr](https://gitee.com/openeuler/ptcr)                                 | 0       | Incubating | Container performance testing tools | NA        |
| [kata_integration](https://gitee.com/openeuler/kata_integration)         | 0       | Introduced | Kata Build Project                  | NA        |
| [yunyi](https://gitee.com/openeuler/yunyi)                               | 0       | Incubating | Data Caching Middleware             | NA        |
| [resaware_nri_plugins](https://gitee.com/openeuler/resaware_nri_plugins) | 0.0.1   | Introduced | Allocation of Container Resources   | NA        |

----------

## Upstream-integrated

### Orchestration & Management

Maintainers: @weibaohui  @xuxuepeng  @zmr_2020

| Project                                                  | Version | State      | Category                         | Committer |
| -------------------------------------------------------- | ------- | ---------- | -------------------------------- | --------- |
| [kubernetes](https://gitee.com/src-openeuler/kubernetes) | 1.25.3  | Introduced | Scheduling & Orchestration       | NA        |
| [etcd](https://gitee.com/src-openeuler/etcd)             | 3.4.14  | Introduced | Coordination & Service Discovery | NA        |
| [coredns](https://gitee.com/src-openeuler/coredns)       | 1.7.0   | Introduced | Coordination & Service Discovery | NA        |

### Container Runtime

Maintainers: @xuxuepeng @gaodaweiky @zmr_2020

| Project                                                                                    | Version      | State       | Category                             | Committer                                       |
| ------------------------------------------------------------------------------------------ | ------------ | ----------- | ------------------------------------ | ----------------------------------------------- |
| [kuasar](https://gitee.com/src-openeuler/kuasar)                                           | 0.1.0        | Introduced  | Unified Container runtime            | NA                                              |
| [lxc](https://gitee.com/src-openeuler/lxc)                                                 | 5.0.2        | Introduced  | Container runtime                    | NA                                              |
| [docker](https://gitee.com/src-openeuler/docker)                                           | 18.09.0      | Introduced  | Container engine                     | [@zhangsong234](https://gitee.com/zhangsong234) |
| [moby](https://gitee.com/src-openeuler/moby)                                               | 20.10.24     | Introduced  | Container engine                     | NA                                              |
| [containerd](https://gitee.com/src-openeuler/containerd)                                   | 1.6.22       | Introduced  | Container runtime                    | [@zhangsong234](https://gitee.com/zhangsong234) |
| [runc](https://gitee.com/src-openeuler/runc)                                               | 1.1.8        | Introduced  | Container runtime                    | [@zhangsong234](https://gitee.com/zhangsong234) |
| [kata-containers](https://gitee.com/src-openeuler/kata-containers)                         | 2.1.0/1.11.1 | Introduced  | Container runtime                    | NA                                              |
| [libnetwork](https://gitee.com/src-openeuler/libnetwork)                                   | 0.8.0-dev    | Introduced  | Docker network components            | NA                                              |
| [containernetworking-plugins](https://gitee.com/src-openeuler/containernetworking-plugins) | 1.2.0        | Introduced  | CNI                                  | NA                                              |
| [cri-o](https://gitee.com/src-openeuler/cri-o)                                             | 1.23.2       | Introduced  | Container runtime                    | NA                                              |
| [cri-tools](https://gitee.com/src-openeuler/cri-tools)                                     | 1.24.2       | Introduced  | CRI tools                            | NA                                              |
| [gvisor](https://gitee.com/src-openeuler/gvisor)                                           | 20220425.0   | Introducing | Container runtime                    | NA                                              |
| [crun](https://gitee.com/src-openeuler/crun)                                               | 1.8.1        | Introduced  | Container runtime                    | NA                                              |
| [catatonit](https://gitee.com/src-openeuler/catatonit)                                     | 0.1.7        | Introduced  | Container runtime                    | NA                                              |
| [podman](https://gitee.com/src-openeuler/podman)                                           | 4.5.1        | Introduced  | Application Definition & Image Build | NA                                              |

### App Definition & Development

Maintainers: @jianminw @wonleing

| Project                                                          | Version | State       | Category                             | Committer |
| ---------------------------------------------------------------- | ------- | ----------- | ------------------------------------ | --------- |
| [docker-compose](https://gitee.com/src-openeuler/docker-compose) | 1.22.0  | Introduced  | Application Definition & Image Build | NA        |
| [skopeo](https://gitee.com/src-openeuler/skopeo)                 | 1.8.0   | Introduced  | Application Definition & Image Build | NA        |
| [kubevirt](https://gitee.com/src-openeuler/kubevirt)             | 0.54.0  | Introducing | Application Definition & Image Build | NA        |
| [buildah](https://gitee.com/src-openeuler/buildah)               | 1.26.1  | Introduced  | Image build tool                     | NA        |
| [umoci](https://gitee.com/src-openeuler/umoci)                   | 0.4.7   | Introduced  | Image management tool                | NA        |

### Observability & Analysis

Maintainers: @yangzhao_kl @gaodaweiky

| Project                                                                  | Version | State       | Category   | Committer |
| ------------------------------------------------------------------------ | ------- | ----------- | ---------- | --------- |
| [prometheus](https://gitee.com/src-openeuler/prometheus)                 | 2.46.0  | Introduced  | Monitoring | NA        |
| [promu](https://gitee.com/src-openeuler/promu)                           | 0.15.0  | Introduced  | Monitoring | NA        |
| [cadvisor](https://gitee.com/src-openeuler/cadvisor)                     | 0.37.0  | Introduced  | Monitoring | NA        |
| [alertmanager](https://gitee.com/src-openeuler/alertmanager)             | 0.26.0  | Introduced  | Monitoring | NA        |
| [node_exporter](https://gitee.com/src-openeuler/node_exporter)           | 1.0.1   | Introduced  | Monitoring | NA        |
| [virt-what](https://gitee.com/src-openeuler/virt-what)                   | 1.25    | Introduced  | Monitoring | NA        |
| [gluster_exporter](https://gitee.com/src-openeuler/gluster_exporter)     | 0.2.7   | Introducing | Monitoring | NA        |
| [haproxy_exporter](https://gitee.com/src-openeuler/haproxy_exporter)     | 0.15.0  | Introducing | Monitoring | NA        |
| [influxdb_exporter](https://gitee.com/src-openeuler/influxdb_exporter)   | 0.11.5  | Introducing | Monitoring | NA        |
| [memcached_exporter](https://gitee.com/src-openeuler/memcached_exporter) | 0.14.2  | Introducing | Monitoring | NA        |
| [pushgateway](https://gitee.com/src-openeuler/pushgateway)               | 1.4.1   | Introduced  | Monitoring | NA        |
| [blackbox_exporter](https://gitee.com/src-openeuler/blackbox_exporter)   | 0.24.0  | Introduced  | Monitoring | NA        |
| [mysqld_exporter](https://gitee.com/src-openeuler/mysqld_exporter)       | 0.15.1  | Introducing | Monitoring | NA        |
| [redis_exporter](https://gitee.com/src-openeuler/redis_exporter)         | 1.56.0  | Introducing | Monitoring | NA        |

### Provisioning

Maintainers: @jianminw @lu-wei-army

| Project                                                                | Version | State       | Category                                                                | Committer |
| ---------------------------------------------------------------------- | ------- | ----------- | ----------------------------------------------------------------------- | --------- |
| [harbor](https://gitee.com/src-openeuler/harbor)                       | 0.4.1   | Introducing | Container Registry                                                      | NA        |
| [containers-common](https://gitee.com/src-openeuler/containers-common) | 1       | Introduced  | Automation & Configuration                                              | NA        |
| [awscli](https://gitee.com/src-openeuler/awscli)                       |         | Introducing | awscli provides a unified command line interface to Amazon Web Services | NA        |

### Dependent Component

Maintainers: @weibaohui @lu-wei-army @zmr_2020

| Project                                                                                        | Version  | State       | Category                                        | Committer |
| ---------------------------------------------------------------------------------------------- | -------- | ----------- | ----------------------------------------------- | --------- |
| [protobuf](https://gitee.com/src-openeuler/protobuf)                                           | 3.19.6   | Introduced  | iSulad dependencies                             | NA        |
| [busybox](https://gitee.com/src-openeuler/busybox)                                             | 1.36.1   | Introduced  | Container image dependencies                    | NA        |
| [docker-client-java](https://gitee.com/src-openeuler/docker-client-java)                       | 8.11.7   | Introduced  | Dependent Component                             | NA        |
| [container-selinux](https://gitee.com/src-openeuler/container-selinux)                         | 2.163    | Introduced  | Docker Selinux Policy                           | NA        |
| [jboss-parent](https://gitee.com/src-openeuler/jboss-parent)                                   | 39       | Introduced  | Dependent Component                             | NA        |
| [libevhtp](https://gitee.com/src-openeuler/libevhtp)                                           | 1.2.18   | Introduced  | iSulad dependencies                             | NA        |
| [libcgroup](https://gitee.com/src-openeuler/libcgroup)                                         | 3.1.0    | Introduced  | Container dependencies                          | NA        |
| [afterburn](https://gitee.com/src-openeuler/afterburn)                                         | 5.4.2    | Introduced  | NestOS dependencies                             | NA        |
| [butane](https://gitee.com/src-openeuler/butane)                                               | 0.14.0   | Introduced  | NestOS dependencies                             | NA        |
| [console-login-helper-messages](https://gitee.com/src-openeuler/console-login-helper-messages) | 0.21.3   | Introduced  | NestOS dependencies                             | NA        |
| [dumb-init](https://gitee.com/src-openeuler/dumb-init)                                         | 1.2.5    | Introduced  | NestOS dependencies                             | NA        |
| [fuse-overlayfs](https://gitee.com/src-openeuler/fuse-overlayfs)                               | 1.12     | Introduced  | NestOS dependencies                             | NA        |
| [fuse-sshfs](https://gitee.com/src-openeuler/fuse-sshfs)                                       | 3.7.3    | Introduced  | NestOS dependencies                             | NA        |
| [libslirp](https://gitee.com/src-openeuler/libslirp)                                           | 4.7.0    | Introduced  | NestOS dependencies                             | NA        |
| [libvarlink](https://gitee.com/src-openeuler/libvarlink)                                       | 23       | Introduced  | NestOS dependencies                             | NA        |
| [netavark](https://gitee.com/src-openeuler/netavark)                                           | 1.0.10   | Introduced  | NestOS dependencies                             | NA        |
| [slirp4netns](https://gitee.com/src-openeuler/slirp4netns)                                     | 1.2.0    | Introduced  | NestOS dependencies                             | NA        |
| [ssh-key-dir](https://gitee.com/src-openeuler/ssh-key-dir)                                     | 0.1.4    | Introduced  | NestOS dependencies                             | NA        |
| [stalld](https://gitee.com/src-openeuler/stalld)                                               | 1.16     | Introduced  | NestOS dependencies                             | NA        |
| [toolbox](https://gitee.com/src-openeuler/toolbox)                                             | 0.0.99   | Introduced  | NestOS dependencies                             | NA        |
| [WALinuxAgent](https://gitee.com/src-openeuler/WALinuxAgent)                                   | 2.9.0    | Introduced  | NestOS dependencies                             | NA        |
| [zchunk](https://gitee.com/src-openeuler/zchunk)                                               | 1.3.2    | Introduced  | NestOS dependencies                             | NA        |
| [zincati](https://gitee.com/src-openeuler/zincati)                                             | 0.0.24   | Introduced  | NestOS dependencies                             | NA        |
| [zram-generator](https://gitee.com/src-openeuler/zram-generator)                               | 1.1.2    | Introduced  | NestOS dependencies                             | NA        |
| [bats](https://gitee.com/src-openeuler/bats)                                                   | 1.9.0    | Introduced  | bash dependency compatibility testing framework | NA        |
| [calico](https://gitee.com/src-openeuler/calico)                                               | 0        | Introducing | K8s CNI plugin                                  | NA        |
| [parallel](https://gitee.com/src-openeuler/parallel)                                           | 20230622 | Introduced  | Parallel computing tools                        | NA        |
| [python-kubernetes](https://gitee.com/src-openeuler/python-kubernetes)                         | 25.3.0   | Introduced  | K8s python client                               | NA        |
| [ShellCheck](https://gitee.com/src-openeuler/ShellCheck)                                       | 0        | Introducing | Formatting tools                                | NA        |
| [virtiofsd](https://gitee.com/src-openeuler/virtiofsd)                                         | 1.10.1   | Introduced  | Virtio-fs                                       | NA        |
| [OpenTofu](https://gitee.com/src-openeuler/opentofu)                                           | 1.6.2    | Introduced  | OSS tool of infrastructure                      | NA        |
| [ollama](https://gitee.com/src-openeuler/ollama)                                               | 0        | Introducing | Get up and running with LLM                     | NA        |
| [gradio](https://gitee.com/src-openeuler/gradio)                                               | 0        | Introduced  | UI Python library for machine learning models   | NA        |

## Related Projects

### iSulad

Maintained by [iSulad SIG](https://gitee.com/openeuler/community/tree/master/sig/iSulad)

| Project                                                | Version | State      | Category                             | Committer |
| ------------------------------------------------------ | ------- | ---------- | ------------------------------------ | --------- |
| [iSulad](https://gitee.com/openeuler/iSulad)           | 2.1.4   | Introduced | Container engine                     | NA        |
| [lcr](https://gitee.com/openeuler/lcr)                 | 2.1.3   | Introduced | Container runtime                    | NA        |
| [clibcni](https://gitee.com/openeuler/clibcni)         | 2.1.0   | Introduced | iSulad network components            | NA        |
| [isula-build](https://gitee.com/openeuler/isula-build) | 0.9.6   | Introduced | Application Definition & Image Build | NA        |
| [lxc](https://gitee.com/src-openeuler/lxc)             | 5.0.2   | Introduced | Container runtime                    | NA        |
| [iSulad-img](https://gitee.com/openeuler/iSulad-img)   | 2.0.1   | Removed    | iSulad 1.x Image Management Tool     | NA        |

### Note

| State       | Remarks                                                                                                                                    |
| ----------- | ------------------------------------------------------------------------------------------------------------------------------------------ |
| Introduced  | The component has been introduced into the openEuler distribution.                                                                         |
| Introducing | The project has been created in openEuler and the code is introducing from upstream repository, and introducing to openEuler distribution. |
| Incubating  | The project is incubating by CloudNative SIG and under heavy developing. Not introduced to openEuler release yet.                          |
| Created     | The project is created in openEuler but no any code is introduced from upstream repostitory, which is help wanted.                         |
| Requested   | The project is requested by not introduced yet in the openEuler.                                                                           |
| Removed     | This project is no longer applicable and has been removed from the openEuler and the repository is archived                                |
