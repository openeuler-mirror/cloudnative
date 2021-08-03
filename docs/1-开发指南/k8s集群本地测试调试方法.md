# k8s集群本地调试、测试方法
## 部署集群

本教程是通过`kubeadm`一键式部署k8s集群，如果想通过二进制部署集群，请参考：https://docs.openeuler.org/zh/docs/21.03/docs/Kubernetes/Kubernetes.html

### 组件信息

- OS：openEuler **21.03**
- Kubernetes：**1.20.2**
- Docker：**18.9.0**
- iSulad: **2.0.8**

yum 源地址：https://repo.openeuler.org/openEuler-21.03/

**NOTE：**需保证**版本配套一致**，即所有组件均出自**同一OS版本**，此处为**openEuler 21.03**

### 集群规划

| 角色    | IP              | 组件/镜像                                                    |
| ------- | --------------- | ------------------------------------------------------------ |
| master  | 192.168.100.101 | kubeadm，kube-apiserver，kube-controller-manager，kube-scheduler，kubelet，etcd |
| worker1 | 192.168.100.201 | kubelet，kube-proxy                                          |
| worker2 | 192.168.100.202 | kubelet，kube-proxy                                          |
| worker3 | 192.168.100.203 | kubelet，kube-proxy                                          |

### 环境准备

默认已有虚拟机环境（虚拟机镜像获取地址）。

```bash
# 关闭防火墙
systemctl stop firewalld
systemctl disable firewalld

# 禁用selinux
setenforce 0

# 网络配置，开启相应的转发机制
cat >> /etc/sysctl.d/k8s.conf <<EOF
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
net.ipv4.ip_forward = 1
vm.swappiness=0
EOF

# 生效规则
modprobe br_netfilter
sysctl -p /etc/sysctl.d/k8s.conf

# 查看是否生效
cat /proc/sys/net/bridge/bridge-nf-call-ip6tables
1
cat /proc/sys/net/bridge/bridge-nf-call-iptables
1

# 关闭系统swap
swapoff -a

# 设置hostname
hostnamectl set-hostname master（worker1、worker2、worker3）

# 配置hosts文件
cat >> /etc/hosts << EOF
192.168.100.101 master
192.168.100.201 worker1
192.168.100.202 worker2
192.168.100.203 worker3
EOF

# 同步时钟，选择可以访问的NTP服务器即可
ntpdate cn.pool.ntp.org
```

>  以上操作需要在**所有节点**执行

### 配置容器引擎

k8s可以对接多种CRI，以下操作用户可以**二选一**。

本文中使用Docker作为对接k8s的CRI。

#### 配置iSulad

```bash
# 安装iSulad
yum install -y iSulad
# 配置iSulad
cat  /etc/isulad/daemon.json
{
        "registry-mirrors": [
                "docker.io"
        ],
        "insecure-registries": [
                "k8s.gcr.io",
                "quay.io"，
                "hub.oepkgs.net"
        ],
        "pod-sandbox-image": "k8s.gcr.io/pause:3.2",	# pause镜像设置
        "network-plugin": "cni", # 置空表示禁用cni网络插件则下面两个路径失效，安装插件后重启isulad即可
        "cni-bin-dir": "/opt/cni/bin",
        "cni-conf-dir": "/etc/cni/net.d",
}

# 如果不能直接访问外网，则需要配置proxy，否则不需要
cat /usr/lib/systemd/system/isulad.service
[Service]
Type=notify
Environment="HTTP_PROXY=http://..."
Environment="HTTPS_PROXY=http://..."

# 重启iSulad并设置为开机自启
systemctl daemon-reload && systemctl restart isulad
```

> 以上操作需要在**所有节点**执行

#### 配置Docker

```bash
# 先安装docker
yum install -y docker
# 为docker添加insecure registry
cat /etc/sysconfig/docker
INSECURE_REGISTRY="--insecure-registry k8s.gcr.io --insecure-registry quay.io --insecure-registry hub.oepkgs.net"

# 如果不能直接访问外网，则需要配置proxy，否则不需要
cat /etc/systemd/system/docker.service.d/http-proxy.conf
[Service]
Environment="HTTP_PROXY=http://..."
Environment="HTTPS_PROXY=http://..."
Environment="http_proxy=http://..."
Environment="https_proxy=http://..."
Environment="NO_PROXY=..."

# 重启docker
systemctl daemon-reload && systemctl restart docker
```

> 以上操作需要在**所有节点**执行

### 安装k8s组件

```bash
# cri-tools 网络工具
# x86
wget --no-check-certificate https://github.com/kubernetes-sigs/cri-tools/releases/download/v1.20.0/crictl-v1.20.0-linux-amd64.tar.gz
tar zxvf crictl-v1.19.0-linux-amd64.tar.gz -C /usr/local/bin
# arm
wget --no-check-certificate https://github.com/kubernetes-sigs/cri-tools/releases/download/v1.20.0/crictl-v1.20.0-linux-arm64.tar.gz
tar zxvf crictl-v1.20.0-linux-arm64.tar.gz -C /usr/local/bin

# cni 网络插件
# x86
wget --no-check-certificate https://github.com/containernetworking/plugins/releases/download/v0.9.0/cni-plugins-linux-amd64-v0.9.0.tgz
mkdir -p /opt/cni/bin
tar -zxvf cni-plugins-linux-amd64-v0.9.0.tgz -C /opt/cni/bin
# arm
wget --no-check-certificate https://github.com/containernetworking/plugins/releases/download/v0.9.0/cni-plugins-linux-arm64-v0.9.0.tgz
mkdir -p /opt/cni/bin
tar -zxvf cni-plugins-linux-arm64-v0.9.0.tgz -C /opt/cni/bin

# 安装k8s组件
# 注意：如果全部使用openEuler-21.03版本，可以支持直接yum安装
# master节点执行
yum install kubernetes-master kubernetes-kubeadm kubernetes-client kubernetes-kubelet
# worker节点执行
yum install kubernetes-node kubernetes-kubelet  kubernetes-kubeadm
# 开机启动kubelet
systemctl enable kubelet --now
```

> 以上操作需要在**所有节点**执行

### 部署master节点

```bash
# 注意，init之前需要取消系统环境中的proxy
unset `env | grep -iE "tps?_proxy" | cut -d= -f1`
env | grep proxy

# 使用kubeadm init
kubeadm init  --kubernetes-version v1.20.2 --pod-network-cidr=10.244.0.0/16 --upload-certs
# 如果想使用iSulad + k8s，则可以在上面命令最后添加 --cri-socket=/var/run/isulad.sock
# 默认k8s组件镜像是gcr.k8s.io，可以使用--image-repository=xxx 来使用自定义镜像仓库地址（测试自己的k8s镜像）

# 注意这里的pod-network-cidr网段不能和宿主机的网段重复，否则网络不通
# 如果配置HA master，那么就需要一台机器init，然后剩余master kubeadm join
# 如果配置LB的话，需要在init的时候就添加--control-plane-endpoint "LB_DNS:LB_PORT"
# 上传证书--upload-certs
# 先init再配置网络
Your Kubernetes control-plane has initialized successfully!

To start using your cluster, you need to run the following as a regular user:

  mkdir -p $HOME/.kube
  sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
  sudo chown $(id -u):$(id -g) $HOME/.kube/config

You should now deploy a pod network to the cluster.
Run "kubectl apply -f [podnetwork].yaml" with one of the options listed at:
  https://kubernetes.io/docs/concepts/cluster-administration/addons/

Then you can join any number of worker nodes by running the following on each as root:
...

# 根据提示执行
mkdir -p $HOME/.kube
cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
chown $(id -u):$(id -g) $HOME/.kube/config
# 这个命令复制了admin.conf（kubeadm帮我们自动初始化好的kubectl配置文件）
# 这里包含了认证信息等相关信息的非常重要的一些配置。

# 重置（如果init出现问题可以重置）
kubeadm reset  重置
# 如果出现 Unable to read config path "/etc/kubernetes/manifests"
mkdir -p /etc/kubernetes/manifests

# 配置calico网络插件
kubectl apply -f https://docs.projectcalico.org/manifests/calico.yaml
# 查看节点及状态
kubectl get nodes
# 此时为Ready状态
$ kubectl get node
NAME        STATUS   ROLES                  AGE     VERSION
master      Ready    control-plane,master   6d16h   v1.20.2
```

### node加入集群

```bash
# 获取加入集群的口令
# master节点上执行并复制结果
kubeadm token create --print-join-command

# 获取到口令之后，在三个node节点分别执行刚才的得到的结果
kubeadm join 192.168.100.101:6443 --token 3ir18d.24rci52l2cnpwtsm     --discovery-token-ca-cert-hash sha256:ce0601d14a81547447fb3a17c3631d245f32aa0f12d97cb09429845f4fed064a

# 回到master节点，可以查看集群信息
$ kubectl get node
NAME        STATUS   ROLES                  AGE     VERSION
master      Ready    control-plane,master   6d16h   v1.20.2
worker1     Ready    <none>                 6d22h   v1.20.2
worker2     Ready    <none>                 6d16h   v1.20.2
worker3     Ready    <none>                 6d21h   v1.20.2

# 查看集群信息
$ kubectl cluster-info
Kubernetes control plane is running at https://192.168.100.101:6443
KubeDNS is running at https://192.168.100.101:6443/api/v1/namespaces/kube-system/services/kube-dns:dns/proxy

To further debug and diagnose cluster problems, use 'kubectl cluster-info dump'.

```

## k8s ETE测试

kubernetes 的e2e测试：

1. 实现测试套件，需要利用基于Ginkgo/Gomega的E2E Framework， 以及client-go
2. 利用kubetest创建并启动一个测试集群，或者使用现有集群
3. 在测试集群中运行E2E测试套，使用kubetest、go test  ginkgo命令均可，本文使用kubetest，默认连接到/root/.kube/config或者设定环境变量：export KUBECONFIG=/etc/kubernetes/admin.conf
4. **本地集群数量推荐：1 master、2 node(最少)**
5. kubetest执行机器为master

### 安装kubetest

```bash
# 开启go mod
export GO111MODULE=on
export GONOSUMDB=on
go get -u -v k8s.io/test-infra/kubetest

# 如果 go mod下载依赖包失败，尝试如下方法
mkdir -p $GOPATH/src/k8s.io
git clone https://github.com/kubernetes/test-infra.git
# 生成$GOPATH/bin/kubetest二进制
go install k8s.io/test-infra/kubetest
# 如果出错：
# [root@master1 kubernetes]# go install k8s.io/test-infra/kubetest
# go: extracting cloud.google.com/go v0.38.0
# go: extracting cloud.google.com/go/storage v1.12.0
# build k8s.io/test-infra/kubetest: cannot load cloud.google.com/go/storage: ambiguous import: found cloud.google.com/go/storage in multiple modules:
#        cloud.google.com/go v0.66.0 (/home/GOWORK/pkg/mod/cloud.google.com/go@v0.38.0/storage)
#        cloud.google.com/go/storage v1.12.0 (/home/GOWORK/pkg/mod/cloud.google.com/go/storage@v1.12.0)
# 解决：
go mod tidy
```

### kubetest测试

测试前，先构建一下kubernetes的ete框架, 确保编译通过：

```bash
cd $GOPATH/src/k8s.io/kubernetes
go install ./test/e2e
```

构建kubernetes、启动一个集群、运行测试、清理，依次使用如下命令完成，需在kubernetes仓库根目录下执行：

kubetest --build --up --test --down

可仅执行其中一部分：

```bash
# 构建，编译生成相关二进制文件如kubectl kubelet kubeadm  ...
kubetest --build

ls _output/local/bin/linux/arm64/
apiextensions-apiserver  conversion-gen  defaulter-gen  e2e.test  genkubedocs  genswaggertypedocs  ginkgo   go-bindata  kubeadm         kube-controller-manager  kubelet   kube-proxy      linkcheck  openapi-gen
_artifacts               deepcopy-gen    e2e_node.test  gendocs   genman       genyaml             go2make  go-runner   kube-apiserver  kubectl                  kubemark  kube-scheduler  mounter

# 执行一致性测试（conformance test)
export KUBECONFIG=$HOME/admin.conf
export KUBERNETES_CONFORMANCE_TEST=true
kubetest --test --test_args="--kubeconfig=/root/.kube/config kubetest" --test_args="--ginkgo.focus=\[Conformance\]"  --provider=local --dump /home/kubelogs --timeout 2h

# 执行本地local已有k8s单节点测试
kubetest --test --test_args="--host=https://$本机IP:6443 --kubeconfig=/root/.kube/config kubetest" --provider=local --timeout 2h

# 跳过指定的测试
kubetest --test --test_args="--ginkgo.skip=Pods.*env"

# 指定云提供商
kubetest --provider=aws --build --up --test --down

# 针对临时集群调用kubectl
kubetest -ctl='get events'
kubetest -ctl='delete pod foobar'

# 清理
kubetest --down
```

### sonobuoy测试

```bash
# 使用sonobuoy进行测试
# 安装二进制 x86
wget --no-check-certificate https://github.com/vmware-tanzu/sonobuoy/releases/download/v0.20.0/sonobuoy_0.20.0_linux_amd64.tar.gz
# 安装二进制 arm
wget --no-check-certificate https://github.com/vmware-tanzu/sonobuoy/releases/download/v0.20.0/sonobuoy_0.20.0_linux_arm64.tar.gz
# 下载必要镜像
sonobuoy images pull
# 运行测试
sonobuoy run
# 查看测试状态
sonobuoy status
# 获取日志
sonobuoy logs
# 保存结果
sonobuoy retrieve
# 分析结果
sonobuoy results xxx.tar.gz # 这个xxx.tar.gz是retrieve输出的结果
# 清除测试
sonobuoy delete --all # 不加--all不会删除namespace
# 如果运行run的时候出错，多半是没有delete干净，比如ns，可以查看下是否有它的ns
kubectl get ns | grep sonobuoy # 如果有，可以使用上面的sonobuoy delete --all或者kubectl delete ns sonobuoy
```

### 错误

4. FAIL: We need at least two pods to be created butall nodes are already heavily utilized, so preemption tests cannot be run

    增加node节点，最少2个

    重新运行用例

    ```bash
    kubetest --test --test_args="--kubeconfig=/root/.kube/config kubetest" --test_args="--ginkgo.focus=SchedulerPreemption"  --provider=local --dump /home/kubelogs
    ```

5. should provide DNS for pods for Subdomain [Conformance] [It]

    网络问题，建议在公网环境测试

6. should be able to deny custom resource creation, update and deletion [Conformance] [It]

    未知

7. e2e test failed with AdmissionWebhook
    change network plugin from flannel to calico, the test passed!

    使用calico代替flannel插件

    > https://github.com/vmware-tanzu/sonobuoy/issues/1084

8. should provide DNS for pods for Subdomain

    Unable to read wheezy_udp@dns-test-service from pod

    > https://github.com/kubernetes/kubernetes/issues/72985
    >
    > http://3ms.huawei.com/km/blogs/details/5715567#preview_attachment_box_5715567
    >
    > http://3ms.huawei.com/km/blogs/details/5158985

> 更多错误查询可参考：
>
> [Verify Your Kubernetes Clusters with Upstream e2e Tests](https://events19.linuxfoundation.org/wp-content/uploads/2017/11/Verify-Your-Kubernetes-Clusters-with-Upstream-e2e-Tests-Kenichi-Omichi-NEC.pdf)

### 清理

如果使用本地集群进行反复测试，需周期性手动清理：

```bash
rm -rf /var/run/kubernetes  删除k8s生成的凭证文件
iptables -F 清空kube-proxy 生成的iptables规则
```
