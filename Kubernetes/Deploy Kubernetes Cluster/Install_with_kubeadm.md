# Install Kubernetes Cluster with KubeAdm tool

## 1. Install a container runtime
Here will go with containerd runtime

### 1.1. Install and configure prerequisites
#### 1.1.1. Forwarding IPv4 and letting iptables see bridged traffic
[Forwarding IPv4 and letting iptables see bridged traffic](https://kubernetes.io/docs/setup/production-environment/container-runtimes/#forwarding-ipv4-and-letting-iptables-see-bridged-traffic)



#### 1.1.2. Configure cgroup Driver

There are two cgroup drivers available:
1. cgroupfs
2. systemd

> How to know your system is using `systemd` or `cgroupfs`?

Run this command
```
ps -p 1
```

[Configuring systemd cgroup driver for containerd runtime](https://kubernetes.io/docs/setup/production-environment/container-runtimes/#containerd-systemd)


## 2. Installing kubeadm, kubelet and kubectl
At all Nodes: 
[Installing kubeadm, kubelet and kubectl](https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/install-kubeadm/#installing-kubeadm-kubelet-and-kubectl)

## 3. Creating a cluster with kubeadm
At Master Node:
[Creating a cluster with kubeadm](https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/create-cluster-kubeadm/)

In Master Node:

Use the master node interface IP
```
IP_ADDR=$(ip addr show eth0 | grep -oP '(?<=inet\s)\d+(\.\d+){3}')
kubeadm init --apiserver-cert-extra-sans=controlplane --apiserver-advertise-address $IP_ADDR --pod-network-cidr=10.244.0.0/16
```
Then: 
```
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/conf
sudo chown $(id -u):$(id -g) $HOME/.kube/conf
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



## 4. Join the Worker Nodes

At the worker nodes, Apply this:
```
kubeadm join 192.28.231.3:6443 --token y9kfuu.2qdhnpmy6akt7gyj \
        --discovery-token-ca-cert-hash sha256:65a9894b7dfb4103e6a4d74209ac6f96c7f41eec0f969ef3aede9322153a2b6f
```