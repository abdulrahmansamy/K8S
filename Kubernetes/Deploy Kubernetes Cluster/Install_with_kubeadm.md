# Install Kubernetes Cluster with KubeAdm tool

## 1. Install a container runtime
Here we will go with `containerd` runtime:

### Install and configure prerequisites
#### Forwarding IPv4 and letting iptables see bridged traffic
[Forwarding IPv4 and letting iptables see bridged traffic](https://kubernetes.io/docs/setup/production-environment/container-runtimes/#forwarding-ipv4-and-letting-iptables-see-bridged-traffic)

Execute the below mentioned instructions:
```
cat <<EOF | sudo tee /etc/modules-load.d/k8s.conf
overlay
br_netfilter
EOF

sudo modprobe overlay
sudo modprobe br_netfilter

# sysctl params required by setup, params persist across reboots
cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-iptables  = 1
net.bridge.bridge-nf-call-ip6tables = 1
net.ipv4.ip_forward                 = 1
EOF

# Apply sysctl params without reboot
sudo sysctl --system
```
Verify that the `br_netfilter`, `overlay` modules are loaded by running the following commands:
```
lsmod | grep br_netfilter
lsmod | grep overlay
```
Verify that the `net.bridge.bridge-nf-call-iptables`, `net.bridge.bridge-nf-call-ip6tables`, and `net.ipv4.ip_forward` system variables are set to `1` in your `sysctl` config by running the following command:
```
sysctl net.bridge.bridge-nf-call-iptables net.bridge.bridge-nf-call-ip6tables net.ipv4.ip_forward
```
#### Configure cgroup Driver

There are two cgroup drivers available:
1. cgroupfs
2. systemd

> How to know your system is using `systemd` or `cgroupfs`?

Run this command
```
ps -p 1
```

[Configuring systemd cgroup driver for containerd runtime](https://kubernetes.io/docs/setup/production-environment/container-runtimes/#containerd-systemd)

To use the systemd cgroup driver in /etc/containerd/config.toml with runc, set:
```
[plugins."io.containerd.grpc.v1.cri".containerd.runtimes.runc]
  [plugins."io.containerd.grpc.v1.cri".containerd.runtimes.runc.options]
    SystemdCgroup = true
```


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