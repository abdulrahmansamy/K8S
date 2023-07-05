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

###### How to know your system is using systemd or cgroupfs?
Run this command
```
ps -p 1
```

##### [systemd cgroup driver](https://kubernetes.io/docs/setup/production-environment/container-runtimes/#containerd-systemd)
