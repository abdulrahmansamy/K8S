# Control plan upgrade

## Master Node upgrade:

run these commands on Master node

```
kubectl drain controlplane --ignore-daemonsets

apt-get upgrade -y kubeadm=1.27.0-00
apt-get upgrade -y kubelet=1.27.0-00  --allow-change-held-packages

kubeadm upgrade apply v1.27.0



systemctl daemon-reload
systemctl restart kubelet

kubectl uncordon controlplane
```

## Worker Nodes upgrade:

### Drain the worker node from any running pods
At Master node run this:
```
Kubectl drain worker01 --ignore-daemonsets
```

At the worker node run the following:
### Upgrade the kubeadm and kubelet packages

```
apt-get upgrade -y kubeadm=1.27.0-00 kubelet=1.27.0-00  --allow-change-held-packages
```

### Apply the Upgrades, and update the node configuration:
```
kubeadm upgrade node config --kubelet-version v1.27.0
kubeadm upgrade node
```

### Restart Kubelet service
```
systemctl daemon-reload
systemctl restart kubelet
```

### Enable worker node Scheduling 
At Master node run this:
```
kubectl uncordon worker01
```