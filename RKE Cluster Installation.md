
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

### StorageClass

Apply this storage class:

```
more storageclass.yaml 

apiVersion: storage.k8s.io/v1
kind: StorageClass
metadata:
  name: cinder-storageclass
  annotations:
    storageclass.kubernetes.io/is-default-class: "true"

```

#
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

## allow address pairs for metal lb
```
neutron port-update 75f6f1ac-104c-4509-ac6b-ac21637d583f  --allowed_address_pairs list=true type=dict ip_address=192.168.2.240 ip_address=192.168.2.241 ip_address=192.168.2.242 ip_address=192.168.2.243 ip_address=192.168.2.244 ip_address=192.168.2.245 ip_address=192.168.2.246 ip_address=192.168.2.247 ip_address=192.168.2.248 ip_address=192.168.2.249 ip_address=192.168.2.250

openstack port show 75f6f1ac-104c-4509-ac6b-ac21637d583f
```




