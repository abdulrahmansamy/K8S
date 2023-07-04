# ETCD Backup


```
export ETCDCTL_API=3
etcdctl version
```

### Take the backup
```
# ETCDCTL_API=3
etcdctl snapshot save snapshot.db
```

### View status of the backup
```
# ETCDCTL_API=3
etcdctl snapshot status snapshot.db
```

### for TLS details
```
etcdctl snapshot save -h
```

# ETCD Restore

```
export ETCDCTL_API=3
etcdctl version
```

### Stop kube-api server
```
systemctl stop kube-apiserver 
```
or 
```
service kube-apiserver stop
```

### Restore the backup
```
# ETCDCTL_API=3
etcdctl snapshot retore snapshot.db --data-dir /var/lib/etcd-from-backup
```

# Edit etcd.service to use the new data dirctory
```
---data-dir=/var/lib/etcd-from-backup
```

### Restart ETCD service
```
systemctl daemon-reload
systemctl restart etcd
```

### Start kube-api server
```
systemctl start kube-apiserver 
```

### for TLS details
```
etcdctl snapshot restore -h
```