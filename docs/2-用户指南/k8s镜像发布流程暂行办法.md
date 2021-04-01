# k8s镜像发布流程暂行办法

## 背景

openEuler中尚不存在k8s组件容器镜像，为了保证一致性以及可溯源，需要提供**基于openEuler**的k8s组件容器镜像。

受限于openEuler发布流程，开发者需要一个快速迭代、自主可控的镜像发布地址以供开发、调试。

## 阶段性解决方案

鉴于以上多种问题以及交付流程约束，CloudNative SIG 制定了以下暂行办法：

k8s组件容器镜像由openEuler基础镜像为base进行打包制作，并推送到`hub.oepkgs.net`中的个人仓用作开源爱好者、开发者进行k8s集群的构建以及调试，**暂不进入 openEuler release 版本**。未来组件正式发布之后会在此发布，期间有新的组件镜像加入也会[在此发布](https://hub.oepkgs.net/)。
