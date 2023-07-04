# RKE installation on openstack Cloud:
- [ ] Create three machines for masters
- [ ] Create three machines for workers
- [ ] Create one machine for jumbhost

## In jumbhost
- [ ] Update hosts file

```
192.168.0.3	jumbhost01.cluster.local	jumbhost01 jh1
192.168.0.4	master01.cluster.local	master01 sm1
192.168.0.5	master02.cluster.local	master02 sm2
192.168.0.6	master03.cluster.local	master03 sm3
192.168.0.7	worker01.cluster.local	worker01 sw1
192.168.0.8	worker02.cluster.local	worker02 sw2
192.168.0.9	worker03.cluster.local	worker03 sw3

```

- [ ] Run this script:
[RKE_Installation.sh](https://github.com/abdulrahmansamy/k8s/blob/180d46ed9cca9b2200a802e1b4f5c63f90f2dac3/RKE_Installation.sh)


## CSI cinder plugin

https://github.com/kubernetes/cloud-provider-openstack/blob/master/docs/cinder-csi-plugin/using-cinder-csi-plugin.md

manifists:
https://github.com/kubernetes/cloud-provider-openstack/tree/master/manifests/cinder-csi-plugin

```
$ more cloud.conf 

[Global]
username = 
password = 
domain-name = 
auth-url = https://api-********.com/identity/v3
tenant-id = a9***************************2d7

```

## StorageClass

### Apply this storage class:

```
more storageclass.yaml 

apiVersion: storage.k8s.io/v1
kind: StorageClass
metadata:
  name: cinder-storageclass
  annotations:
    storageclass.kubernetes.io/is-default-class: "true"

```


## Nginx ingress Controller
Follow these instructions:
https://kubernetes.github.io/ingress-nginx/deploy/#bare-metal-clusters

## MetalLB
### Installation
```
kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.13.5/config/manifests/metallb-native.yaml
```

##### Reference: https://metallb.universe.tf/installation/

### Configuration
```
apiVersion: metallb.io/v1beta1
kind: IPAddressPool
metadata:
  name: metallb-pool
  namespace: metallb-system
spec:
  addresses:
  - 192.168.2.240-192.168.2.250
```

##### Reference: https://metallb.universe.tf/configuration/

### Allow address pairs for metal lb
```
neutron port-update 75f6f1ac-104c-4509-ac6b-ac21637d583f  --allowed_address_pairs list=true type=dict ip_address=192.168.2.240 ip_address=192.168.2.241 ip_address=192.168.2.242 ip_address=192.168.2.243 ip_address=192.168.2.244 ip_address=192.168.2.245 ip_address=192.168.2.246 ip_address=192.168.2.247 ip_address=192.168.2.248 ip_address=192.168.2.249 ip_address=192.168.2.250

openstack port show 75f6f1ac-104c-4509-ac6b-ac21637d583f
```






