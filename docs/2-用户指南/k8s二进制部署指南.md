# openEuler二进制部署K8S

* [集群状态](#集群状态)
* [准备虚拟机](#准备虚拟机)
    * [安装依赖工具](#安装依赖工具)
    * [准备虚拟机磁盘文件](#准备虚拟机磁盘文件)
    * [打开 VNC 防火墙端口](#打开-vnc-防火墙端口)
    * [准备虚拟机配置文件](#准备虚拟机配置文件)
    * [安装虚拟机](#安装虚拟机)
* [部署  Kubernetes 集群](#部署--kubernetes-集群)
    * [环境说明](#环境说明)
    * [安装 Kubernetes 软件包](#安装-kubernetes-软件包)
    * [准备证书](#准备证书)
        * [编译安装 CFSSL](#编译安装-cfssl)
        * [生成根证书](#生成根证书)
        * [生成 admin 账户证书](#生成-admin-账户证书)
        * [生成 service-account 账户证书](#生成-service-account-账户证书)
        * [生成 kube-controller-manager 组件证书](#生成-kube-controller-manager-组件证书)
        * [生成 kube-proxy 证书](#生成-kube-proxy-证书)
        * [生成 kube-scheduler 证书](#生成-kube-scheduler-证书)
        * [生成 kubelet 证书](#生成-kubelet-证书)
        * [生成 kube-apiserver 证书](#生成-kube-apiserver-证书)
        * [生成 etcd 证书（可选）](#生成-etcd-证书可选)
    * [安装 etcd](#安装-etcd)
        * [准备环境](#准备环境)
        * [安装 etcd 二进制](#安装-etcd-二进制)
        * [编写 etcd.service 文件](#编写-etcdservice-文件)
        * [验证基本功能](#验证基本功能)
* [部署控制面组件](#部署控制面组件)
    * [准备所有组件的 kubeconfig](#准备所有组件的-kubeconfig)
        * [kube-proxy](#kube-proxy)
        * [kube-controller-manager](#kube-controller-manager)
        * [kube-scheduler](#kube-scheduler)
        * [admin](#admin)
        * [获得相关 kubeconfig 配置文件](#获得相关-kubeconfig-配置文件)
    * [生成密钥提供者的配置](#生成密钥提供者的配置)
    * [拷贝证书](#拷贝证书)
    * [部署 admin 角色的 RBAC](#部署-admin-角色的-rbac)
    * [部署 api server 服务](#部署-api-server-服务)
        * [编写 apiserver 的 systemd 配置](#编写-apiserver-的-systemd-配置)
    * [部署 controller-manager 服务](#部署-controller-manager-服务)
        * [编写 controller-manager 的 systemd 配置文件](#编写-controller-manager-的-systemd-配置文件)
    * [部署 scheduler 服务](#部署-scheduler-服务)
        * [编写 scheduler 的 systemd 配置文件](#编写-scheduler-的-systemd-配置文件)
    * [使能各组件](#使能各组件)
    * [基本功能验证](#基本功能验证)
* [部署 Node 节点组件](#部署-node-节点组件)
    * [环境准备](#环境准备)
    * [创建 kubeconfig 配置文件](#创建-kubeconfig-配置文件)
    * [拷贝证书](#拷贝证书-1)
    * [CNI 网络配置](#cni-网络配置)
    * [部署 kubelet 服务](#部署-kubelet-服务)
        * [kubelet 依赖的配置文件](#kubelet-依赖的配置文件)
        * [编写 systemd 配置文件](#编写-systemd-配置文件)
    * [部署 kube-proxy](#部署-kube-proxy)
        * [kube-proxy 依赖的配置文件](#kube-proxy-依赖的配置文件)
        * [编写 systemd 配置文件](#编写-systemd-配置文件-1)
    * [启动组件服务](#启动组件服务)
    * [验证集群状态](#验证集群状态)
    * [部署 coredns](#部署-coredns)
        * [编写 coredns 配置文件](#编写-coredns-配置文件)
        * [准备 systemd 的 service 文件](#准备-systemd-的-service-文件)
        * [启动服务](#启动服务)
        * [创建 coredns 的 Service 对象](#创建-coredns-的-service-对象)
        * [创建 coredns 的 endpoint 对象](#创建-coredns-的-endpoint-对象)
        * [确认 coredns 服务](#确认-coredns-服务)
* [运行测试 pod](#运行测试-pod)
    * [配置文件](#配置文件)
    * [启动 pod](#启动-pod)

**声明：本文档仅适用于实验和学习环境，不适用于商用环境**

本文档介绍在 openEuler 操作系统上，通过二进制部署 K8S 集群的一个参考方法。

说明：本文所有操作均使用 `root`权限执行。

## 集群状态

本文所使用的集群状态如下：

- 集群结构：6 个 `openEuler 21.03`系统的虚拟机，3 个 master 和 3 个 node 节点
- 物理机：`openEuler 21.03 `的 `x86/ARM`服务器

## 准备虚拟机


本章介绍使用 virt  manager 安装虚拟机的方法，如果您已经准备好虚拟机，可以跳过本章节。

### 安装依赖工具

安装虚拟机，会依赖相关工具，安装依赖并使能 libvirtd 服务的参考命令如下（如果需要代理，请先配置代理）：

```bash
$ dnf install virt-install virt-manager libvirt-daemon-qemu edk2-aarch64.noarch virt-viewer
$ systemctl start libvirtd
$ systemctl enable libvirtd
```

### 准备虚拟机磁盘文件

```bash
$ dnf install -y qemu-img
$ virsh pool-define-as vmPool --type dir --target /mnt/vm/images/
$ virsh pool-build vmPool
$ virsh pool-start vmPool
$ virsh pool-autostart  vmPool
$ virsh vol-create-as --pool vmPool --name master0.img --capacity 200G --allocation 1G --format qcow2
$ virsh vol-create-as --pool vmPool --name master1.img --capacity 200G --allocation 1G --format qcow2
$ virsh vol-create-as --pool vmPool --name master2.img --capacity 200G --allocation 1G --format qcow2
$ virsh vol-create-as --pool vmPool --name node1.img --capacity 300G --allocation 1G --format qcow2
$ virsh vol-create-as --pool vmPool --name node2.img --capacity 300G --allocation 1G --format qcow2
$ virsh vol-create-as --pool vmPool --name node3.img --capacity 300G --allocation 1G --format qcow2
```

### 打开 VNC 防火墙端口

**方法一**

1. 查询端口

   ```shell
   $ netstat -lntup | grep qemu-kvm
   ```

2. 打开 VNC 的防火墙端口。假设端口从 5900 开始，参考命令如下：

   ```shell
   $ firewall-cmd --zone=public --add-port=5900/tcp
   $ firewall-cmd --zone=public --add-port=5901/tcp
   $ firewall-cmd --zone=public --add-port=5902/tcp
   $ firewall-cmd --zone=public --add-port=5903/tcp
   $ firewall-cmd --zone=public --add-port=5904/tcp
   $ firewall-cmd --zone=public --add-port=5905/tcp
   ```



**方法二**

直接关闭防火墙

```shell
$ systemctl stop firewalld
```


### 准备虚拟机配置文件

创建虚拟机需要虚拟机配置文件。假设配置文件为 master.xml ，以虚拟机 hostname 为 k8smaster0 的节点为例，参考配置如下：

```bash
 cat master.xml

<domain type='kvm'>
    <name>k8smaster0</name>
    <memory unit='GiB'>8</memory>
    <vcpu>8</vcpu>
    <os>
	<type arch='aarch64' machine='virt'>hvm</type>
	<loader readonly='yes' type='pflash'>/usr/share/edk2/aarch64/QEMU_EFI-pflash.raw</loader>
	<nvram>/var/lib/libvirt/qemu/nvram/k8smaster0.fd</nvram>
    </os>
    <features>
	<acpi/>
	<gic version='3'/>
    </features>
    <cpu mode='host-passthrough'>
        <topology sockets='2' cores='4' threads='1'/>
    </cpu>
    <iothreads>1</iothreads>
    <clock offset='utc'/>
    <on_poweroff>destroy</on_poweroff>
    <on_reboot>restart</on_reboot>
    <on_crash>restart</on_crash>
    <devices>
	<emulator>/usr/libexec/qemu-kvm</emulator>
	<disk type='file' device='disk'>
	    <driver name='qemu' type='qcow2' iothread="1"/>
	    <source file='/mnt/vm/images/master0.img'/>
	    <target dev='vda' bus='virtio'/>
	    <boot order='1'/>
	</disk>
	<disk type='file' device='cdrom'>
	    <driver name='qemu' type='raw'/>
	    <source file='/mnt/openEuler-21.03-everything-aarch64-dvd.iso'/>
	    <readonly/>
	    <target dev='sdb' bus='scsi'/>
	    <boot order='2'/>
	</disk>
        <interface type='network'>
           <mac address='52:54:00:00:00:80'/>
           <source network='default'/>
           <model type='virtio'/>
        </interface>
	<console type='pty'/>
        <video>
           <model type='virtio'/>
        </video>
        <controller type='scsi' index='0' model='virtio-scsi'/>
	<controller type='usb' model='ehci'/>
	<input type='tablet' bus='usb'/>
	<input type='keyboard' bus='usb'/>
	<graphics type='vnc' listen='0.0.0.0'/>
    </devices>
    <seclabel type='dynamic' model='dac' relabel='yes'/>
</domain>
```

由于虚拟机相关配置必须唯一，新增虚拟机需要适配修改如下内容，保证虚拟机的唯一性：

- name：虚拟机 hostname，建议尽量小写。例中为 `k8smaster0`
- nvram：nvram的句柄文件路径，需要全局唯一。例中为  `/var/lib/libvirt/qemu/nvram/k8smaster0.fd`
- disk 的 source file：虚拟机磁盘文件路径。例中为  `/mnt/vm/images/master0.img`
- interface 的 mac address：interface 的 mac 地址。例中为 `52:54:00:00:00:80`


### 安装虚拟机

1. 创建并启动虚拟机

   ```shell
   $ virsh define master.xml
   $ virsh start k8smaster0
   ```

2. 获取虚拟机的 VNC 端口号

   ```shell
   $ virsh vncdisplay k8smaster0
   ```

3. 使用虚拟机链接工具，例如 VNC Viewer 远程链接虚拟机，并根据提示依次选择配置，完成系统安装

4. 设置虚拟机 hostname，例如设置为 k8smaster0

   ```shell
   $ hostnamectl set-hostname k8smaster0
   ```

## 部署  Kubernetes 集群


本章介绍部署 Kubernets 集群的方法。

### 环境说明

通过上述虚拟机安装部署，获得如下虚拟机列表：

| HostName   | MAC               | IPv4               |
| ---------- | ----------------- | ------------------ |
| k8smaster0 | 52:54:00:00:00:80 | 192.168.122.154/24 |
| k8smaster1 | 52:54:00:00:00:81 | 192.168.122.155/24 |
| k8smaster2 | 52:54:00:00:00:82 | 192.168.122.156/24 |
| k8snode1   | 52:54:00:00:00:83 | 192.168.122.157/24 |
| k8snode2   | 52:54:00:00:00:84 | 192.168.122.158/24 |
| k8snode3   | 52:54:00:00:00:85 | 192.168.122.159/24 |


### 安装 Kubernetes 软件包


```bash
$ dnf install -y docker conntrack-tools socat
```

EPOL 之后，可以直接通过 dnf 安装 K8S

```bash
$ rpm -ivh kubernetes*.rpm
```


### 准备证书


**声明：本文使用的证书为自签名，不能用于商用环境**

部署集群前，需要生成集群各组件之间通信所需的证书。本文使用开源 CFSSL 作为验证部署工具，以便用户了解证书的配置和集群组件之间证书的关联关系。用户可以根据实际情况选择合适的工具，例如 OpenSSL 。

#### 编译安装 CFSSL

编译安装 CFSSL 的参考命令如下（需要互联网下载权限，需要配置代理的请先完成配置），

```bash
$ wget --no-check-certificate  https://github.com/cloudflare/cfssl/archive/v1.5.0.tar.gz
$ tar -zxf v1.5.0.tar.gz
$ cd cfssl-1.5.0/
$ make -j6
$ cp bin/* /usr/local/bin/
```

#### 生成根证书

编写 CA 配置文件，例如 ca-config.json：

```bash
$ cat ca-config.json | jq
{
  "signing": {
    "default": {
      "expiry": "8760h"
    },
    "profiles": {
      "kubernetes": {
        "usages": [
          "signing",
          "key encipherment",
          "server auth",
          "client auth"
        ],
        "expiry": "8760h"
      }
    }
  }
}
```

编写 CA CSR 文件，例如 ca-csr.json：

```bash
$ cat ca-csr.json  | jq
{
  "CN": "Kubernetes",
  "key": {
    "algo": "rsa",
    "size": 2048
  },
  "names": [
    {
      "C": "CN",
      "L": "HangZhou",
      "O": "openEuler",
      "OU": "WWW",
      "ST": "BinJiang"
    }
  ]
}
```

生成 CA 证书和密钥：
```bash
$ cfssl gencert -initca ca-csr.json | cfssljson -bare ca
```

得到如下证书：

```bash
ca.csr  ca-key.pem  ca.pem
```

#### 生成 admin 账户证书

admin 是 K8S 用于系统管理的一个账户，编写 admin 账户的 CSR 配置，例如 admin-csr.json：
```bash
cat admin-csr.json | jq
{
  "CN": "admin",
  "key": {
    "algo": "rsa",
    "size": 2048
  },
  "names": [
    {
      "C": "CN",
      "L": "HangZhou",
      "O": "system:masters",
      "OU": "Containerum",
      "ST": "BinJiang"
    }
  ]
}
```

生成证书：
```bash
$ cfssl gencert -ca=ca.pem -ca-key=ca-key.pem -config=ca-config.json -profile=kubernetes admin-csr.json | cfssljson -bare admin
```

结果如下：
```bash
admin.csr  admin-key.pem  admin.pem
```

#### 生成 service-account 账户证书

编写 service-account 账户的 CSR 配置文件，例如 service-account-csr.json：
```bash
cat service-account-csr.json | jq
{
  "CN": "service-accounts",
  "key": {
    "algo": "rsa",
    "size": 2048
  },
  "names": [
    {
      "C": "CN",
      "L": "HangZhou",
      "O": "Kubernetes",
      "OU": "openEuler k8s install",
      "ST": "BinJiang"
    }
  ]
}
```

生成证书：
```bash
$ cfssl gencert -ca=ca.pem -ca-key=ca-key.pem -config=ca-config.json -profile=kubernetes service-account-csr.json | cfssljson -bare service-account
```

结果如下：
```bash
service-account.csr  service-account-key.pem  service-account.pem
```

#### 生成 kube-controller-manager 组件证书

编写 kube-controller-manager 的 CSR 配置：
```bash
{
  "CN": "system:kube-controller-manager",
  "key": {
    "algo": "rsa",
    "size": 2048
  },
  "names": [
    {
      "C": "CN",
      "L": "HangZhou",
      "O": "system:kube-controller-manager",
      "OU": "openEuler k8s kcm",
      "ST": "BinJiang"
    }
  ]
}
```

生成证书：
```bash
$ cfssl gencert -ca=ca.pem -ca-key=ca-key.pem -config=ca-config.json -profile=kubernetes kube-controller-manager-csr.json | cfssljson -bare kube-controller-manager
```

结果如下：
```bash
kube-controller-manager.csr  kube-controller-manager-key.pem  kube-controller-manager.pem
```

#### 生成 kube-proxy 证书

编写 kube-proxy 的 CSR 配置：
```bash
{
  "CN": "system:kube-proxy",
  "key": {
    "algo": "rsa",
    "size": 2048
  },
  "names": [
    {
      "C": "CN",
      "L": "HangZhou",
      "O": "system:node-proxier",
      "OU": "openEuler k8s kube proxy",
      "ST": "BinJiang"
    }
  ]
}
```

生成证书：
```bash
$ cfssl gencert -ca=ca.pem -ca-key=ca-key.pem -config=ca-config.json -profile=kubernetes kube-proxy-csr.json | cfssljson -bare kube-proxy
```

结果如下：
```bash
kube-proxy.csr  kube-proxy-key.pem  kube-proxy.pem
```

#### 生成 kube-scheduler 证书

编写 kube-scheduler 的 CSR 配置：
```bash
{
  "CN": "system:kube-scheduler",
  "key": {
    "algo": "rsa",
    "size": 2048
  },
  "names": [
    {
      "C": "CN",
      "L": "HangZhou",
      "O": "system:kube-scheduler",
      "OU": "openEuler k8s kube scheduler",
      "ST": "BinJiang"
    }
  ]
}
```

生成证书：
```bash
$ cfssl gencert -ca=ca.pem -ca-key=ca-key.pem -config=ca-config.json -profile=kubernetes kube-scheduler-csr.json | cfssljson -bare kube-scheduler
```

结果如下：
```bash
kube-scheduler.csr  kube-scheduler-key.pem  kube-scheduler.pem
```

#### 生成 kubelet 证书

由于证书涉及到 kubelet 所在机器的 hostname 和 IP 地址信息，因此每个 node 节点配置不尽相同，所以编写脚本完成，生成脚本如下：
```bash
$ cat node_csr_gen.bash

#!/bin/bash

nodes=(k8snode1 k8snode2 k8snode3)
IPs=("192.168.122.157" "192.168.122.158" "192.168.122.159")

for i in "${!nodes[@]}"; do

cat > "${nodes[$i]}-csr.json" <<EOF
{
  "CN": "system:node:${nodes[$i]}",
  "key": {
    "algo": "rsa",
    "size": 2048
  },
  "names": [
    {
      "C": "CN",
      "L": "HangZhou",
      "O": "system:nodes",
      "OU": "openEuler k8s kubelet",
      "ST": "BinJiang"
    }
  ]
}
EOF

	# generate ca
	echo "generate: ${nodes[$i]} ${IPs[$i]}"
	cfssl gencert -ca=ca.pem -ca-key=ca-key.pem -config=ca-config.json -hostname=${nodes[$i]},${IPs[$i]} -profile=kubernetes ${nodes[$i]}-csr.json | cfssljson -bare ${nodes[$i]}
done
```

说明：如果节点存在多个 IP 或者其他别名，-hostname 可以增加其他的 IP 或者 hostname

结果如下：
```bash
k8snode1.csr       k8snode1.pem       k8snode2-key.pem  k8snode3-csr.json
k8snode1-csr.json  k8snode2.csr       k8snode2.pem      k8snode3-key.pem
k8snode1-key.pem   k8snode2-csr.json  k8snode3.csr      k8snode3.pem
```

CSR 配置信息，以 k8snode1 为例如下：
```bash
$ cat k8snode1-csr.json
{
  "CN": "system:node:k8snode1",
  "key": {
    "algo": "rsa",
    "size": 2048
  },
  "names": [
    {
      "C": "CN",
      "L": "HangZhou",
      "O": "system:nodes",
      "OU": "openEuler k8s kubelet",
      "ST": "BinJiang"
    }
  ]
}
```

注意：由于每个 node 所属的账户组为 `system:node`，因此 CSR 的 CN 字段都为 `system:node` 加上`hostname`。

#### 生成 kube-apiserver 证书

编写 kube api server 的 CSR 配置文件：
```bash
$ cat kubernetes-csr.json | jq
{
  "CN": "kubernetes",
  "key": {
    "algo": "rsa",
    "size": 2048
  },
  "names": [
    {
      "C": "CN",
      "L": "HangZhou",
      "O": "Kubernetes",
      "OU": "openEuler k8s kube api server",
      "ST": "BinJiang"
    }
  ]
}
```

生成证书和密钥：
```bash
cfssl gencert -ca=ca.pem -ca-key=ca-key.pem -config=ca-config.json -hostname=10.32.0.1,192.168.122.154,192.168.122.155,192.168.122.156,127.0.0.1,kubernetes,kubernetes.default,kubernetes.default.svc,kubernetes.default.svc.cluster,kubernetes.svc.cluster.local -profile=kubernetes kubernetes-csr.json | cfssljson -bare kubernetes
```

结果如下：
```bash
kubernetes.csr  kubernetes-key.pem  kubernetes.pem
```

*说明：10.32.0.1 是内部 services 使用的 IP 地址区间，可以设置为其他值，后面启动 apiserver 服务时，会设置该参数。*

#### 生成 etcd 证书（可选）

部署 etcd 有两种方式：
- 在每个 api-server 对应的机器都启动一个 etcd 服务
- 独立部署一个 etcd 集群服务

如果是和 api-server 一起部署，那么直接使用上面生成的 `kubernetes-key.pem` 和  `kubernetes.pem`  证书即可。

如果是独立的etcd集群，那么需要创建证书如下：

编写 etcd 的 CSR 配置：
```bash
cat etcd-csr.json | jq
{
  "CN": "ETCD",
  "key": {
    "algo": "rsa",
    "size": 2048
  },
  "names": [
    {
      "C": "CN",
      "L": "HangZhou",
      "O": "ETCD",
      "OU": "openEuler k8s etcd",
      "ST": "BinJiang"
    }
  ]
}
```

生成证书：
```bash
$ cfssl gencert -ca=ca.pem -ca-key=ca-key.pem -config=ca-config.json -hostname=192.168.122.154,192.168.122.155,192.168.122.156,127.0.0.1 -profile=kubernetes etcd-csr.json | cfssljson -bare etcd
```

*说明：假设 etcd 集群的 IP地址是 192.168.122.154,192.168.122.155,192.168.122.156*

结果如下：
```bash
etcd.csr  etcd-key.pem  etcd.pem
```

### 安装 etcd


#### 准备环境

使能 etcd 使用的端口：
```bash
firewall-cmd --zone=public --add-port=2379/tcp
firewall-cmd --zone=public --add-port=2380/tcp
```

#### 安装 etcd 二进制

当前是通过 rpm 包安装

```
rpm -ivh etcd*.rpm
```

准备目录

```bash
mkdir -p /etc/etcd /var/lib/etcd
cp ca.pem /etc/etcd/
cp kubernetes-key.pem /etc/etcd/
cp kubernetes.pem /etc/etcd/
# 关闭selinux
setenforce 0
# 禁用/etc/etcd/etcd.conf文件的默认配置
# 注释掉即可，例如：ETCD_LISTEN_CLIENT_URLS="http://localhost:2379"
```

#### 编写 etcd.service 文件

以 `k8smaster0 `机器为例：

```bash
$ cat /usr/lib/systemd/system/etcd.service
[Unit]
Description=Etcd Server
After=network.target
After=network-online.target
Wants=network-online.target

[Service]
Type=notify
WorkingDirectory=/var/lib/etcd/
EnvironmentFile=-/etc/etcd/etcd.conf
# set GOMAXPROCS to number of processors
ExecStart=/bin/bash -c "ETCD_UNSUPPORTED_ARCH=arm64 /usr/bin/etcd --name=k8smaster0 --cert-file=/etc/etcd/kubernetes.pem --key-file=/etc/etcd/kubernetes-key.pem --peer-cert-file=/etc/etcd/kubernetes.pem --peer-key-file=/etc/etcd/kubernetes-key.pem --trusted-ca-file=/etc/etcd/ca.pem --peer-trusted-ca-file=/etc/etcd/ca.pem --peer-client-cert-auth --client-cert-auth --initial-advertise-peer-urls https://192.168.122.154:2380 --listen-peer-urls https://192.168.122.154:2380 --listen-client-urls https://192.168.122.154:2379,https://127.0.0.1:2379 --advertise-client-urls https://192.168.122.154:2379 --initial-cluster-token etcd-cluster-0 --initial-cluster k8smaster0=https://192.168.122.154:2380,k8smaster1=https://192.168.122.155:2380,k8smaster2=https://192.168.122.156:2380 --initial-cluster-state new --data-dir /var/lib/etcd"

Restart=always
RestartSec=10s
LimitNOFILE=65536

[Install]
WantedBy=multi-user.target
```

**注意:**

- arm64上面需要增加启动设置`ETCD_UNSUPPORTED_ARCH=arm64`；
- 由于本文把etcd和k8s control部署在相同机器，所以使用了`kubernetes.pem`和`kubernetes-key.pem`证书来启动；
- ca证书，在整个部署流程里面使用了一个，etcd可以生成自己的ca，然后用自己的ca签名其他证书，但是需要在apiserver访问etcd的client用该ca签名的证书；
- `initial-cluster`需要把所有部署etcd的配置加上；
- 为了提高etcd的存储效率，可以使用ssd硬盘的目录，作为`data-dir`；

启动服务

```bash
$ systemctl enable etcd
$ systemctl start etcd
```

然后，依次部署其他机器即可。

#### 验证基本功能

```bash
$  ETCDCTL_API=3 etcdctl -w table endpoint status --endpoints=https://192.168.122.155:2379,https://192.168.122.156:2379,https://192.168.122.154:2379   --cacert=/etc/etcd/ca.pem   --cert=/etc/etcd/kubernetes.pem   --key=/etc/etcd/kubernetes-key.pem
+------------------------------+------------------+---------+---------+-----------+------------+-----------+------------+--------------------+--------+
|           ENDPOINT           |        ID        | VERSION | DB SIZE | IS LEADER | IS LEARNER | RAFT TERM | RAFT INDEX | RAFTAPPLIED INDEX | ERRORS |
+------------------------------+------------------+---------+---------+-----------+------------+-----------+------------+--------------------+--------+
| https://192.168.122.155:2379 | b50ec873e253ebaa |  3.4.14 |  262 kB |     false |      false |       819 |         21 |           21 |        |
| https://192.168.122.156:2379 | e2b0d126774c6d02 |  3.4.14 |  262 kB |      true |      false |       819 |         21 |           21 |        |
| https://192.168.122.154:2379 | f93b3808e944c379 |  3.4.14 |  328 kB |     false |      false |       819 |         21 |           21 |        |
+------------------------------+------------------+---------+---------+-----------+------------+-----------+------------+--------------------+--------+
```

## 部署控制面组件


### 准备所有组件的 kubeconfig

#### kube-proxy

```bash
$ kubectl config set-cluster openeuler-k8s --certificate-authority=/etc/kubernetes/pki/ca.pem --embed-certs=true --server=https://192.168.122.154:6443 --kubeconfig=kube-proxy.kubeconfig
$ kubectl config set-credentials system:kube-proxy --client-certificate=/etc/kubernetes/pki/kube-proxy.pem --client-key=/etc/kubernetes/pki/kube-proxy-key.pem --embed-certs=true --kubeconfig=kube-proxy.kubeconfig
$ kubectl config set-context default --cluster=openeuler-k8s --user=system:kube-proxy --kubeconfig=kube-proxy.kubeconfig
$ kubectl config use-context default --kubeconfig=kube-proxy.kubeconfig
```

#### kube-controller-manager

```bash
$ kubectl config set-cluster openeuler-k8s --certificate-authority=/etc/kubernetes/pki/ca.pem --embed-certs=true --server=https://127.0.0.1:6443 --kubeconfig=kube-controller-manager.kubeconfig
$ kubectl config set-credentials system:kube-controller-manager --client-certificate=/etc/kubernetes/pki/kube-controller-manager.pem --client-key=/etc/kubernetes/pki/kube-controller-manager-key.pem --embed-certs=true --kubeconfig=kube-controller-manager.kubeconfig
$ kubectl config set-context default --cluster=openeuler-k8s --user=system:kube-controller-manager --kubeconfig=kube-controller-manager.kubeconfig
$ kubectl config use-context default --kubeconfig=kube-controller-manager.kubeconfig
```

#### kube-scheduler

```bash
$ kubectl config set-cluster openeuler-k8s --certificate-authority=/etc/kubernetes/pki/ca.pem --embed-certs=true --server=https://127.0.0.1:6443 --kubeconfig=kube-scheduler.kubeconfig
$ kubectl config set-credentials system:kube-scheduler --client-certificate=/etc/kubernetes/pki/kube-scheduler.pem --client-key=/etc/kubernetes/pki/kube-scheduler-key.pem --embed-certs=true --kubeconfig=kube-scheduler.kubeconfig
$ kubectl config set-context default  --cluster=openeuler-k8s --user=system:kube-scheduler --kubeconfig=kube-scheduler.kubeconfig
$ kubectl config use-context default --kubeconfig=kube-scheduler.kubeconfig
```

#### admin

```bash
$ kubectl config set-cluster openeuler-k8s --certificate-authority=/etc/kubernetes/pki/ca.pem --embed-certs=true --server=https://127.0.0.1:6443 --kubeconfig=admin.kubeconfig
$ kubectl config set-credentials admin --client-certificate=/etc/kubernetes/pki/admin.pem --client-key=/etc/kubernetes/pki/admin-key.pem --embed-certs=true --kubeconfig=admin.kubeconfig
$ kubectl config set-context default --cluster=openeuler-k8s --user=admin --kubeconfig=admin.kubeconfig
$ kubectl config use-context default --kubeconfig=admin.kubeconfig
```

#### 获得相关 kubeconfig 配置文件

```bash
admin.kubeconfig kube-proxy.kubeconfig  kube-controller-manager.kubeconfig  kube-scheduler.kubeconfig
```

### 生成密钥提供者的配置

api-server 启动时需要提供一个密钥对`--encryption-provider-config=/etc/kubernetes/pki/encryption-config.yaml`，本文通过 urandom 生成一个：

```bash
$ cat generate.bash
#!/bin/bash

ENCRYPTION_KEY=$(head -c 32 /dev/urandom | base64)

cat > encryption-config.yaml <<EOF
kind: EncryptionConfig
apiVersion: v1
resources:
  - resources:
      - secrets
    providers:
      - aescbc:
          keys:
            - name: key1
              secret: ${ENCRYPTION_KEY}
      - identity: {}
EOF
# api-server启动配置 --encryption-provider-config=/etc/kubernetes/pki/encryption-config.yaml
```

### 拷贝证书

本文把所有组件使用的证书、密钥以及配置统一放到`/etc/kubernetes/pki/`目录下。

```bash
# 准备证书目录
$ mkdir -p /etc/kubernetes/pki/
$ ls /etc/kubernetes/pki/
admin-key.pem  encryption-config.yaml              kube-proxy-key.pem     kubernetes.pem             service-account-key.pem
admin.pem      kube-controller-manager-key.pem     kube-proxy.kubeconfig  kube-scheduler-key.pem     service-account.pem
ca-key.pem     kube-controller-manager.kubeconfig  kube-proxy.pem         kube-scheduler.kubeconfig
ca.pem         kube-controller-manager.pem         kubernetes-key.pem     kube-scheduler.pem
```

### 部署 admin 角色的 RBAC

使能 admin role
```bash
$ cat admin_cluster_role.yaml
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  annotations:
    rbac.authorization.kubernetes.io/autoupdate: "true"
  labels:
    kubernetes.io/bootstrapping: rbac-defaults
  name: system:kube-apiserver-to-kubelet
rules:
  - apiGroups:
      - ""
    resources:
      - nodes/proxy
      - nodes/stats
      - nodes/log
      - nodes/spec
      - nodes/metrics
    verbs:
      - "*"

# 使能admin role
$ kubectl apply --kubeconfig admin.kubeconfig -f admin_cluster_role.yaml
```

绑定 admin role
```bash
$ cat admin_cluster_rolebind.yaml
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: system:kube-apiserver
  namespace: ""
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: system:kube-apiserver-to-kubelet
subjects:
  - apiGroup: rbac.authorization.k8s.io
    kind: User
    name: kubernetes

# 绑定admin role
$ kubectl apply --kubeconfig admin.kubeconfig -f admin_cluster_rolebind.yaml
```

### 部署 api server 服务

修改 apiserver 的 etc 配置文件：
```bash
$ cat /etc/kubernetes/apiserver
KUBE_ADVERTIS_ADDRESS="--advertise-address=192.168.122.154"
KUBE_ALLOW_PRIVILEGED="--allow-privileged=true"
KUBE_AUTHORIZATION_MODE="--authorization-mode=Node,RBAC"
KUBE_ENABLE_ADMISSION_PLUGINS="--enable-admission-plugins=NamespaceLifecycle,NodeRestriction,LimitRanger,ServiceAccount,DefaultStorageClass,ResourceQuota"
KUBE_SECURE_PORT="--secure-port=6443"
KUBE_ENABLE_BOOTSTRAP_TOKEN_AUTH="--enable-bootstrap-token-auth=true"
KUBE_ETCD_CAFILE="--etcd-cafile=/etc/kubernetes/pki/ca.pem"
KUBE_ETCD_CERTFILE="--etcd-certfile=/etc/kubernetes/pki/kubernetes.pem"
KUBE_ETCD_KEYFILE="--etcd-keyfile=/etc/kubernetes/pki/kubernetes-key.pem"
KUBE_ETCD_SERVERS="--etcd-servers=https://192.168.122.154:2379,https://192.168.122.155:2379,https://192.168.122.156:2379"
KUBE_CLIENT_CA_FILE="--client-ca-file=/etc/kubernetes/pki/ca.pem"
KUBE_KUBELET_CERT_AUTH="--kubelet-certificate-authority=/etc/kubernetes/pki/ca.pem"
KUBE_KUBELET_CLIENT_CERT="--kubelet-client-certificate=/etc/kubernetes/pki/kubernetes.pem"
KUBE_KUBELET_CLIENT_KEY="--kubelet-client-key=/etc/kubernetes/pki/kubernetes-key.pem"
KUBE_KUBELET_HTTPS="--kubelet-https=true"
KUBE_PROXY_CLIENT_CERT_FILE="--proxy-client-cert-file=/etc/kubernetes/pki/kube-proxy.pem"
KUBE_PROXY_CLIENT_KEY_FILE="--proxy-client-key-file=/etc/kubernetes/pki/kube-proxy-key.pem"
KUBE_TLS_CERT_FILE="--tls-cert-file=/etc/kubernetes/pki/kubernetes.pem"
KUBE_TLS_PRIVATE_KEY_FILE="--tls-private-key-file=/etc/kubernetes/pki/kubernetes-key.pem"
KUBE_SERVICE_CLUSTER_IP_RANGE="--service-cluster-ip-range=10.32.0.0/16"
KUBE_SERVICE_ACCOUNT_ISSUER="--service-account-issuer=https://kubernetes.default.svc.cluster.local"
KUBE_SERVICE_ACCOUNT_KEY_FILE="--service-account-key-file=/etc/kubernetes/pki/service-account.pem"
KUBE_SERVICE_ACCOUNT_SIGN_KEY_FILE="--service-account-signing-key-file=/etc/kubernetes/pki/service-account-key.pem"
KUBE_SERVICE_NODE_PORT_RANGE="--service-node-port-range=30000-32767"
KUB_ENCRYPTION_PROVIDER_CONF="--encryption-provider-config=/etc/kubernetes/pki/encryption-config.yaml"
KUBE_REQUEST_HEADER_ALLOWED_NAME="--requestheader-allowed-names=front-proxy-client"
KUBE_REQUEST_HEADER_EXTRA_HEADER_PREF="--requestheader-extra-headers-prefix=X-Remote-Extra-"
KUBE_REQUEST_HEADER_GROUP_HEADER="--requestheader-group-headers=X-Remote-Group"
KUBE_REQUEST_HEADER_USERNAME_HEADER="--requestheader-username-headers=X-Remote-User"
KUBE_API_ARGS=""
```

所有apiserver的配置都`/etc/kubernetes/config`文件中定义，然后在后面的service文件中直接使用即可。

大部分配置都是比较固定的，部分需要注意：

- `--service-cluster-ip-range`该地址需要和后面的设置的`clusterDNS`需要一致；

#### 编写 apiserver 的 systemd 配置

```bash
cat /usr/lib/systemd/system/kube-apiserver.service
[Unit]
Description=Kubernetes API Server
Documentation=https://kubernetes.io/docs/reference/generated/kube-apiserver/
After=network.target
After=etcd.service

[Service]
EnvironmentFile=-/etc/kubernetes/config
EnvironmentFile=-/etc/kubernetes/apiserver
ExecStart=/usr/bin/kube-apiserver \
	    $KUBE_ADVERTIS_ADDRESS \
	    $KUBE_ALLOW_PRIVILEGED \
	    $KUBE_AUTHORIZATION_MODE \
	    $KUBE_ENABLE_ADMISSION_PLUGINS \
 	    $KUBE_SECURE_PORT \
	    $KUBE_ENABLE_BOOTSTRAP_TOKEN_AUTH \
	    $KUBE_ETCD_CAFILE \
	    $KUBE_ETCD_CERTFILE \
	    $KUBE_ETCD_KEYFILE \
	    $KUBE_ETCD_SERVERS \
	    $KUBE_CLIENT_CA_FILE \
	    $KUBE_KUBELET_CERT_AUTH \
	    $KUBE_KUBELET_CLIENT_CERT \
	    $KUBE_KUBELET_CLIENT_KEY \
	    $KUBE_PROXY_CLIENT_CERT_FILE \
	    $KUBE_PROXY_CLIENT_KEY_FILE \
	    $KUBE_TLS_CERT_FILE \
	    $KUBE_TLS_PRIVATE_KEY_FILE \
	    $KUBE_SERVICE_CLUSTER_IP_RANGE \
	    $KUBE_SERVICE_ACCOUNT_ISSUER \
	    $KUBE_SERVICE_ACCOUNT_KEY_FILE \
	    $KUBE_SERVICE_ACCOUNT_SIGN_KEY_FILE \
	    $KUBE_SERVICE_NODE_PORT_RANGE \
	    $KUBE_LOGTOSTDERR \
	    $KUBE_LOG_LEVEL \
	    $KUBE_API_PORT \
	    $KUBELET_PORT \
	    $KUBE_ALLOW_PRIV \
	    $KUBE_SERVICE_ADDRESSES \
	    $KUBE_ADMISSION_CONTROL \
	    $KUB_ENCRYPTION_PROVIDER_CONF \
	    $KUBE_REQUEST_HEADER_ALLOWED_NAME \
	    $KUBE_REQUEST_HEADER_EXTRA_HEADER_PREF \
	    $KUBE_REQUEST_HEADER_GROUP_HEADER \
	    $KUBE_REQUEST_HEADER_USERNAME_HEADER \
	    $KUBE_API_ARGS
Restart=on-failure
Type=notify
LimitNOFILE=65536

[Install]
WantedBy=multi-user.target
```

### 部署 controller-manager 服务

修改 controller-manager 配置文件：
```bash
$ cat /etc/kubernetes/controller-manager
KUBE_BIND_ADDRESS="--bind-address=127.0.0.1"
KUBE_CLUSTER_CIDR="--cluster-cidr=10.200.0.0/16"
KUBE_CLUSTER_NAME="--cluster-name=kubernetes"
KUBE_CLUSTER_SIGNING_CERT_FILE="--cluster-signing-cert-file=/etc/kubernetes/pki/ca.pem"
KUBE_CLUSTER_SIGNING_KEY_FILE="--cluster-signing-key-file=/etc/kubernetes/pki/ca-key.pem"
KUBE_KUBECONFIG="--kubeconfig=/etc/kubernetes/pki/kube-controller-manager.kubeconfig"
KUBE_LEADER_ELECT="--leader-elect=true"
KUBE_ROOT_CA_FILE="--root-ca-file=/etc/kubernetes/pki/ca.pem"
KUBE_SERVICE_ACCOUNT_PRIVATE_KEY_FILE="--service-account-private-key-file=/etc/kubernetes/pki/service-account-key.pem"
KUBE_SERVICE_CLUSTER_IP_RANGE="--service-cluster-ip-range=10.32.0.0/24"
KUBE_USE_SERVICE_ACCOUNT_CRED="--use-service-account-credentials=true"
KUBE_CONTROLLER_MANAGER_ARGS="--v=2"
```

#### 编写 controller-manager 的 systemd 配置文件

```bash
$ cat /usr/lib/systemd/system/kube-controller-manager.service
[Unit]
Description=Kubernetes Controller Manager
Documentation=https://kubernetes.io/docs/reference/generated/kube-controller-manager/

[Service]
EnvironmentFile=-/etc/kubernetes/config
EnvironmentFile=-/etc/kubernetes/controller-manager
ExecStart=/usr/bin/kube-controller-manager \
	    $KUBE_BIND_ADDRESS \
	    $KUBE_LOGTOSTDERR \
	    $KUBE_LOG_LEVEL \
	    $KUBE_CLUSTER_CIDR \
	    $KUBE_CLUSTER_NAME \
	    $KUBE_CLUSTER_SIGNING_CERT_FILE \
	    $KUBE_CLUSTER_SIGNING_KEY_FILE \
	    $KUBE_KUBECONFIG \
	    $KUBE_LEADER_ELECT \
	    $KUBE_ROOT_CA_FILE \
	    $KUBE_SERVICE_ACCOUNT_PRIVATE_KEY_FILE \
	    $KUBE_SERVICE_CLUSTER_IP_RANGE \
	    $KUBE_USE_SERVICE_ACCOUNT_CRED \
	    $KUBE_CONTROLLER_MANAGER_ARGS
Restart=on-failure
LimitNOFILE=65536

[Install]
WantedBy=multi-user.target
```

### 部署 scheduler 服务

修改 scheduler 配置文件：
```bash
$ cat /etc/kubernetes/scheduler
KUBE_CONFIG="--kubeconfig=/etc/kubernetes/pki/kube-scheduler.kubeconfig"
KUBE_AUTHENTICATION_KUBE_CONF="--authentication-kubeconfig=/etc/kubernetes/pki/kube-scheduler.kubeconfig"
KUBE_AUTHORIZATION_KUBE_CONF="--authorization-kubeconfig=/etc/kubernetes/pki/kube-scheduler.kubeconfig"
KUBE_BIND_ADDR="--bind-address=127.0.0.1"
KUBE_LEADER_ELECT="--leader-elect=true"
KUBE_SCHEDULER_ARGS=""
```

#### 编写 scheduler 的 systemd 配置文件

```bash
$ cat /usr/lib/systemd/system/kube-scheduler.service
[Unit]
Description=Kubernetes Scheduler Plugin
Documentation=https://kubernetes.io/docs/reference/generated/kube-scheduler/

[Service]
EnvironmentFile=-/etc/kubernetes/config
EnvironmentFile=-/etc/kubernetes/scheduler
ExecStart=/usr/bin/kube-scheduler \
	    $KUBE_LOGTOSTDERR \
	    $KUBE_LOG_LEVEL \
	    $KUBE_CONFIG \
	    $KUBE_AUTHENTICATION_KUBE_CONF \
	    $KUBE_AUTHORIZATION_KUBE_CONF \
	    $KUBE_BIND_ADDR \
	    $KUBE_LEADER_ELECT \
	    $KUBE_SCHEDULER_ARGS
Restart=on-failure
LimitNOFILE=65536

[Install]
WantedBy=multi-user.target
```

### 使能各组件

```bash
$ systemctl enable kube-controller-manager kube-scheduler kube-proxy
$ systemctl restart kube-controller-manager kube-scheduler kube-proxy
```

### 基本功能验证

```bash
$ curl --cacert /etc/kubernetes/pki/ca.pem https://192.168.122.154:6443/version
{
  "major": "1",
  "minor": "20",
  "gitVersion": "v1.20.2",
  "gitCommit": "faecb196815e248d3ecfb03c680a4507229c2a56",
  "gitTreeState": "archive",
  "buildDate": "2021-03-02T07:26:14Z",
  "goVersion": "go1.15.7",
  "compiler": "gc",
  "platform": "linux/arm64"
}
```

## 部署 Node 节点组件



本章节仅以`k8snode1`节点为例。

### 环境准备

```bash
# 内网需要配置代理
$ dnf install -y docker iSulad conntrack-tools socat containernetworking-plugins
$ swapoff -a
$ mkdir -p /etc/kubernetes/pki/
$ mkdir -p /etc/cni/net.d
$ mkdir -p /opt/cni
# 删除默认kubeconfig
$ rm /etc/kubernetes/kubelet.kubeconfig

## 使用isulad作为运行时 ########
# 配置iSulad
cat  /etc/isulad/daemon.json
{
        "registry-mirrors": [
                "docker.io"
        ],
        "insecure-registries": [
                "k8s.gcr.io",
                "quay.io"
        ],
        "pod-sandbox-image": "k8s.gcr.io/pause:3.2",# pause类型
        "network-plugin": "cni", # 置空表示禁用cni网络插件则下面两个路径失效， 安装插件后重启isulad即可
        "cni-bin-dir": "/usr/libexec/cni/",
        "cni-conf-dir": "/etc/cni/net.d",
}

# 在iSulad环境变量中添加代理，下载镜像
cat /usr/lib/systemd/system/isulad.service
[Service]
Type=notify
Environment="HTTP_PROXY=http://name:password@proxy:8080"
Environment="HTTPS_PROXY=http://name:password@proxy:8080"

# 重启iSulad并设置为开机自启
systemctl daemon-reload
systemctl restart isulad


## 如果使用docker作为运行时 ########
$ dnf install -y docker
# 如果需要代理的环境，可以给docker配置代理，新增配置文件http-proxy.conf，并编写如下内容，替换name，password和proxy-addr为实际的配置。
$ cat /etc/systemd/system/docker.service.d/http-proxy.conf
[Service]
Environment="HTTP_PROXY=http://name:password@proxy-addr:8080"
$ systemctl daemon-reload
$ systemctl restart docker
```

### 创建 kubeconfig 配置文件

对各节点依次如下操作创建配置文件：

```bash
$ kubectl config set-cluster openeuler-k8s \
    --certificate-authority=/etc/kubernetes/pki/ca.pem \
    --embed-certs=true \
    --server=https://192.168.122.154:6443 \
    --kubeconfig=k8snode1.kubeconfig

$ kubectl config set-credentials system:node:k8snode1 \
    --client-certificate=/etc/kubernetes/pki/k8snode1.pem \
    --client-key=/etc/kubernetes/pki/k8snode1-key.pem \
    --embed-certs=true \
    --kubeconfig=k8snode1.kubeconfig

$ kubectl config set-context default \
    --cluster=openeuler-k8s \
    --user=system:node:k8snode1 \
    --kubeconfig=k8snode1.kubeconfig

$ kubectl config use-context default --kubeconfig=k8snode1.kubeconfig
```

**注：修改k8snode1为对应节点名**

### 拷贝证书

和控制面一样，所有证书、密钥和相关配置都放到`/etc/kubernetes/pki/`目录。

```bash
$ ls /etc/kubernetes/pki/
ca.pem                 k8snode1.kubeconfig  kubelet_config.yaml     kube-proxy-key.pem     kube-proxy.pem
k8snode1-key.pem  k8snode1.pem         kube_proxy_config.yaml  kube-proxy.kubeconfig
```

### CNI 网络配置

先通过 containernetworking-plugins 作为 kubelet 使用的 cni 插件，后续可以引入 calico，flannel 等插件，增强集群的网络能力。

```bash
# 桥网络配置
$ cat /etc/cni/net.d/10-bridge.conf
{
  "cniVersion": "0.3.1",
  "name": "bridge",
  "type": "bridge",
  "bridge": "cnio0",
  "isGateway": true,
  "ipMasq": true,
  "ipam": {
    "type": "host-local",
    "subnet": "10.244.0.0/16",
    "gateway": "10.244.0.1"
  },
  "dns": {
    "nameservers": [
      "10.244.0.1"
    ]
  }
}

# 回环网络配置
$ cat /etc/cni/net.d/99-loopback.conf
{
    "cniVersion": "0.3.1",
    "name": "lo",
    "type": "loopback"
}
```

### 部署 kubelet 服务

#### kubelet 依赖的配置文件

```bash
$ cat /etc/kubernetes/pki/kubelet_config.yaml
kind: KubeletConfiguration
apiVersion: kubelet.config.k8s.io/v1beta1
authentication:
  anonymous:
    enabled: false
  webhook:
    enabled: true
  x509:
    clientCAFile: /etc/kubernetes/pki/ca.pem
authorization:
  mode: Webhook
clusterDNS:
- 10.32.0.10
clusterDomain: cluster.local
runtimeRequestTimeout: "15m"
tlsCertFile: "/etc/kubernetes/pki/k8snode1.pem"
tlsPrivateKeyFile: "/etc/kubernetes/pki/k8snode1-key.pem"
```

**注意：clusterDNS 的地址为：10.32.0.10，必须和之前设置的 service-cluster-ip-range 一致**

#### 编写 systemd 配置文件

```bash
$ cat /usr/lib/systemd/system/kubelet.service
[Unit]
Description=kubelet: The Kubernetes Node Agent
Documentation=https://kubernetes.io/docs/
Wants=network-online.target
After=network-online.target

[Service]
ExecStart=/usr/bin/kubelet \
	--config=/etc/kubernetes/pki/kubelet_config.yaml \
	--network-plugin=cni \
	--pod-infra-container-image=k8s.gcr.io/pause:3.2 \
	--kubeconfig=/etc/kubernetes/pki/k8snode1.kubeconfig \
	--register-node=true \
	--hostname-override=k8snode1 \
	--cni-bin-dir="/usr/libexec/cni/" \
	--v=2

Restart=always
StartLimitInterval=0
RestartSec=10

[Install]
WantedBy=multi-user.target
```

**注意：如果使用isulad作为runtime，需要增加如下配置**

```bash
--container-runtime=remote \
--container-runtime-endpoint=unix:///var/run/isulad.sock \
```

### 部署 kube-proxy

#### kube-proxy 依赖的配置文件

```bash
cat /etc/kubernetes/pki/kube_proxy_config.yaml
kind: KubeProxyConfiguration
apiVersion: kubeproxy.config.k8s.io/v1alpha1
clientConnection:
  kubeconfig: /etc/kubernetes/pki/kube-proxy.kubeconfig
clusterCIDR: 10.244.0.0/16
mode: "iptables"
```

#### 编写 systemd 配置文件

```bash
$ cat /usr/lib/systemd/system/kube-proxy.service
[Unit]
Description=Kubernetes Kube-Proxy Server
Documentation=https://kubernetes.io/docs/reference/generated/kube-proxy/
After=network.target

[Service]
EnvironmentFile=-/etc/kubernetes/config
EnvironmentFile=-/etc/kubernetes/proxy
ExecStart=/usr/bin/kube-proxy \
	    $KUBE_LOGTOSTDERR \
	    $KUBE_LOG_LEVEL \
	    --config=/etc/kubernetes/pki/kube_proxy_config.yaml \
	    --hostname-override=k8snode1 \
	    $KUBE_PROXY_ARGS
Restart=on-failure
LimitNOFILE=65536

[Install]
WantedBy=multi-user.target
```

### 启动组件服务

```bash
$ systemctl enable kubelet kube-proxy
$ systemctl start kubelet kube-proxy
```

其他节点依次部署即可。

### 验证集群状态

等待几分钟，使用如下命令查看node状态：

```bash
$ kubectl get nodes --kubeconfig /etc/kubernetes/pki/admin.kubeconfig
NAME            STATUS   ROLES    AGE   VERSION
k8snode1   Ready    <none>   17h   v1.20.2
k8snode2   Ready    <none>   19m   v1.20.2
k8snode3   Ready    <none>   12m   v1.20.2
```

### 部署 coredns

coredns可以部署到node节点或者master节点，本文这里部署到节点`k8snode1`。

#### 编写 coredns 配置文件

```bash
$ cat /etc/kubernetes/pki/dns/Corefile
.:53 {
    errors
    health {
      lameduck 5s
    }
    ready
    kubernetes cluster.local in-addr.arpa ip6.arpa {
      pods insecure
      endpoint https://192.168.122.154:6443
      tls /etc/kubernetes/pki/ca.pem /etc/kubernetes/pki/admin-key.pem /etc/kubernetes/pki/admin.pem
      kubeconfig /etc/kubernetes/pki/admin.kubeconfig default
      fallthrough in-addr.arpa ip6.arpa
    }
    prometheus :9153
    forward . /etc/resolv.conf {
      max_concurrent 1000
    }
    cache 30
    loop
    reload
    loadbalance
}
```

说明：

- 监听53端口；
- 设置kubernetes插件配置：证书、kube api的URL；

#### 准备 systemd 的 service 文件

```bash
cat /usr/lib/systemd/system/coredns.service
[Unit]
Description=Kubernetes Core DNS server
Documentation=https://github.com/coredns/coredns
After=network.target

[Service]
ExecStart=bash -c "KUBE_DNS_SERVICE_HOST=10.32.0.10 coredns -conf /etc/kubernetes/pki/dns/Corefile"

Restart=on-failure
LimitNOFILE=65536

[Install]
WantedBy=multi-user.target
```

#### 启动服务

```bash
$ systemctl enable coredns
$ systemctl start coredns
```

#### 创建 coredns 的 Service 对象

```bash
$ cat coredns_server.yaml
apiVersion: v1
kind: Service
metadata:
  name: kube-dns
  namespace: kube-system
  annotations:
    prometheus.io/port: "9153"
    prometheus.io/scrape: "true"
  labels:
    k8s-app: kube-dns
    kubernetes.io/cluster-service: "true"
    kubernetes.io/name: "CoreDNS"
spec:
  clusterIP: 10.32.0.10
  ports:
  - name: dns
    port: 53
    protocol: UDP
  - name: dns-tcp
    port: 53
    protocol: TCP
  - name: metrics
    port: 9153
    protocol: TCP
```

#### 创建 coredns 的 endpoint 对象

```bash
$ cat coredns_ep.yaml
apiVersion: v1
kind: Endpoints
metadata:
  name: kube-dns
  namespace: kube-system
subsets:
  - addresses:
      - ip: 192.168.122.157
    ports:
      - name: dns-tcp
        port: 53
        protocol: TCP
      - name: dns
        port: 53
        protocol: UDP
      - name: metrics
        port: 9153
        protocol: TCP
```

#### 确认 coredns 服务

```bash
# 查看service对象
$ kubectl get service -n kube-system kube-dns
NAME       TYPE        CLUSTER-IP   EXTERNAL-IP   PORT(S)                  AGE
kube-dns   ClusterIP   10.32.0.10   <none>        53/UDP,53/TCP,9153/TCP   51m
# 查看endpoint对象
$ kubectl get endpoints -n kube-system kube-dns
NAME       ENDPOINTS                                                    AGE
kube-dns   192.168.122.157:53,192.168.122.157:53,192.168.122.157:9153   52m
```

## 运行测试 pod


### 配置文件

```bash
$ cat nginx.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-deployment
  labels:
    app: nginx
spec:
  replicas: 3
  selector:
    matchLabels:
      app: nginx
  template:
    metadata:
      labels:
        app: nginx
    spec:
      containers:
      - name: nginx
        image: nginx:1.14.2
        ports:
        - containerPort: 80
```

### 启动 pod

通过kubectl命令运行nginx。

```bash
$ kubectl apply -f nginx.yaml
deployment.apps/nginx-deployment created
$ kubectl get pods
NAME                                READY   STATUS    RESTARTS   AGE
nginx-deployment-66b6c48dd5-6rnwz   1/1     Running   0          33s
nginx-deployment-66b6c48dd5-9pq49   1/1     Running   0          33s
nginx-deployment-66b6c48dd5-lvmng   1/1     Running   0          34s
```
