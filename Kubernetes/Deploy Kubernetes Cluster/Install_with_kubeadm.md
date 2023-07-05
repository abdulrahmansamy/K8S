# Install Kubernetes Cluster with KubeAdm tool

## 1. Install a container runtime
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


## 2. [Installing kubeadm, kubelet and kubectl](https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/install-kubeadm/#installing-kubeadm-kubelet-and-kubectl)

## 3. [Creating a cluster with kubeadm](https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/create-cluster-kubeadm/)

In Master Node:

Use the master node interface IP
```
Kubeadm init --pod-network-cidr=10.244.0.0/16 --apiserver-advertise-address=xxx.xxx.xxx.xxx
```
Then: 
```
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/conf
sudo chown $(id -u):$(id -g) $HOME/.kube/config
```

#### Deploy a pod network

https://kubernetes.io/docs/concepts/cluster-administration/addons/

##### Deploy `Weave Net` pod

https://www.weave.works/docs/net/latest/kubernetes/kube-addon/

```
kubectl apply -f https://github.com/weaveworks/weave/releases/download/v2.8.1/weave-daemonset-k8s.yaml
```

If you do set the `--cluster-cidr` option on kube-proxy, make sure it matches the `IPALLOC_RANGE` given to Weave Net, Manually editing the YAML file of the `weave net` daemonset:
```
      containers:
        - name: weave
          env:
            - name: IPALLOC_RANGE
              value: 10.244.0.0/16
```


## 4. Join the work