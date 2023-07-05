# Install Kubernetes Cluster with KubeAdm tool

## Install a container runtime
Here will go for containerd runtime

### Install and configure prerequisites
#### Forwarding IPv4 and letting iptables see bridged traffic
https://kubernetes.io/docs/setup/production-environment/container-runtimes/#forwarding-ipv4-and-letting-iptables-see-bridged-traffic


#### Configure cgroup Driver

There are two cgroup drivers available:
1. cgroupfs
2. systemd

> How to know your system is using `systemd` or `cgroupfs`?

Run this command
```
ps -p 1
```

#### [Configuring systemd cgroup driver for containerd runtime](https://kubernetes.io/docs/setup/production-environment/container-runtimes/#containerd-systemd)


## [Installing kubeadm, kubelet and kubectl](https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/install-kubeadm/#installing-kubeadm-kubelet-and-kubectl)

## [Creating a cluster with kubeadm](https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/create-cluster-kubeadm/)

In master Node:

Use the master interface IP
```
Kubeadm init --pod-network-cidr=10.244.0.0/16 --apiserver-advertise-address=xxx.xxx.xxx.xxx
```

```
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/conf
sudo chown $(id -u):$(id -g) $HOME/.kube/config
```
