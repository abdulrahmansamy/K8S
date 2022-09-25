#!/bin/bash

###################################################
#Define cluster Hosts
#in hosts file

more /etc/hosts
#127.0.0.1   localhost localhost.localdomain localhost4 localhost4.localdomain4
#::1         localhost localhost.localdomain localhost6 localhost6.localdomain6

#192.168.2.3	jumbhost02	jh				jumbhost	
#192.168.2.4	master01	m1	master01.cluster.local	
#192.168.2.5	master02	m2	master02.cluster.local
#192.168.2.6	master03	m3	master03.cluster.local
#192.168.2.7	worker01	w1	worker01.cluster.local
#192.168.2.8	worker02	w2	worker02.cluster.local
#192.168.2.9	worker03	w3	worker03.cluster.local


#destributing ssh pub keys
#=========================
echo -e "\n\nGenerating a ssh key pair\n=========================\n"
ssh-keygen -t rsa -b 2048 -f ~/.ssh/id_rsa -N '' <<< n
echo 
echo


echo -e "\n\ndestributing ssh Public keys\n============================\n"
for X in `egrep -i 'master|worker' /etc/hosts | cut -f 2`
do
echo -e "\nNode: $X\n==============\n"
cat ~/.ssh/id_rsa.pub | ssh $X -i ~/.ssh/RKE-CLUSTER 'umask 077; test -d ~/.ssh || mkdir ~/.ssh ; cat >> ~/.ssh/authorized_keys'
ssh $X umask 0002
done


#Check the connectivity to the hosts


echo -e "\n\nChecking the connectivity to the Nodes\n======================================\n"
for x in `egrep -i 'master|worker' /etc/hosts | cut -f 2` ; do ssh $x hostname ; done




#Update sysctl settings for Kubernetes networking

echo -e "\n\nUpdating sysctl settings for Kubernetes networking\n==================================================\n"

for x in `egrep -i 'master|worker' /etc/hosts | cut -f 2`
do
echo -e "\nNode: $x\n==============\n"
ssh $x sudo tee /etc/sysctl.d/kubernetes.conf >/dev/null <<EOF
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF
ssh $x sudo sysctl --system
done


#escale user privilages

echo -e "\n\nUser: $(whoami) Privilege Escalation\n=================================\n"

for x in `egrep -i 'master|worker' /etc/hosts | cut -f 2`
do
echo -e "\nNode: $x\n==============\n"
ssh $x sudo tee /etc/sudoers.d/$(whoami) >/dev/null <<EOF  
$(whoami)    ALL=(ALL)       NOPASSWD: ALL
EOF
done



#Installing docker engine

echo -e "\n\nInstalling docker engine\n=========================\n"

for x in `egrep -i 'master|worker' /etc/hosts | cut -f 2`
do
echo -e "\nNode: $x\n==============\n"
ssh $x sudo yum check-update
ssh $x sudo curl -fsSL https://get.docker.com -o get-docker.sh
ssh $x sudo sh get-docker.sh
ssh $x sudo systemctl start docker
ssh $x sudo systemctl enable docker
ssh $x sudo systemctl status docker
done


# Running Docker Containers as Non-Root User


echo -e "\n\nConfiguring Docker to Run Containers as Non-Root User\n=====================================================\n"

for x in `egrep -i 'master|worker' /etc/hosts | cut -f 2`
do
echo -e "\nNode: $x\n==============\n"
ssh $x sudo groupadd docker
ssh $x sudo usermod -aG docker $(whoami)
ssh $x grep docker /etc/group
done

#Checking docker installation

echo -e "\n\nChecking docker installation\n============================\n"

for x in `egrep -i 'master|worker' /etc/hosts | cut -f 2`
do


echo -e "\nNode: $x\n==============\n"
ssh $x docker info
ssh $x docker images
ssh $x docker ps -a
done



#Updating systems and reboot

echo -e "\n\nUpdating systems and reboot\n===========================\n"
for x in `egrep -i 'master|worker' /etc/hosts | cut -f 2`
do
echo -e "\nNode: $x\n==============\n"
ssh $x sudo yum -y update
ssh $x sudo reboot
done

#Waiting for reboot

echo -e "\n\nWaiting for reboot\n==================\n"
for x in `egrep -i 'master|worker' /etc/hosts | cut -f 2`
do
echo -e "\nNode: $x\n==============\n"
sleep 5
done

#Disable Swap

echo -e "\n\nDisabling Swap\n==============\n"
for x in `egrep -i 'master|worker' /etc/hosts | cut -f 2` 
do
echo -e "\nNode: $x\n==============\n"
ssh $x sudo swapoff -a; sudo sed -i '/swap/d' /etc/fstab
done


#Disable firewall

echo -e "\n\nDisabling firewall\n==================\n"

for x in `egrep -i 'master|worker' /etc/hosts | cut -f 2`
do
echo -e "\nNode: $x\n==============\n"
ssh $x sudo systemctl stop firewalld 2> /dev/null
ssh $x sudo ufw disable 2> /dev/null
done


#Installing wget command

echo -e "\n\nInstalling wget command\n=======================\n"

for x in `egrep -i 'jumbhost' /etc/hosts | cut -f 2`
do
echo -e "\nNode: $x\n==============\n"
ssh $x sudo yum install -y wget
done

#RKE installation

echo -e "\n\nRKE Installation\n================\n"

for x in `egrep -i 'jumbhost' /etc/hosts | cut -f 2`
do
echo -e "\nNode: $x\n==============\n"

curl -s https://api.github.com/repos/rancher/rke/releases/latest | grep download_url | grep amd64 | grep linux | cut -d '"' -f 4 | wget -qi - 
mv rke_linux-amd64 rke
chmod +x rke
sudo mv rke /usr/local/bin/rke
rke --version

done

#KUBECTL installation

echo -e "\n\nKUBECTL Installation\n====================\n"

for x in `egrep -i 'jumbhost' /etc/hosts | cut -f 2`
do
echo -e "\nNode: $x\n==============\n"

curl -sLO https://storage.googleapis.com/kubernetes-release/release/`curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt`/bin/linux/amd64/kubectl
chmod +x kubectl
sudo mv kubectl /usr/local/bin/kubectl
echo
kubectl version --output=yaml
done

echo


#Configuring the Kubernetes cluster

echo -e "\n\nConfiguring the Kubernetes cluster\n==================================\n"

#rke config

#Bring up Kubernetes cluster

echo -e "\n\nBring up the Kubernetes cluster\n===========================\n"
#rke up

mkdir ~/.kube 2> /dev/null
cp kube_config_cluster.yml ~/.kube/config


#Checking the cluster health

echo -e "\n\nChecking the cluster health\n===========================\n"

echo -e "\nCluster information\n===================\n"
kubectl cluster-info

echo -e "\nCluster Nodes\n=============\n"
kubectl get nodes

echo -e "\nCluster Component Status\n========================\n"
kubectl get cs

echo -e "\nReadyz Check\n============\n"
kubectl get --raw='/readyz?verbose'

