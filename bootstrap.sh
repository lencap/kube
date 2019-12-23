#!/bin/bash
# bootstrap.sh

# Adapted from https://8gwifi.org/docs/kube-install.jsp

# |-------------------------------------------------|----------|----------|
# | Requirement                                     | k101     | k102     |
# |-------------------------------------------------|----------|----------|
# | Disable system swap and SELinux                 | Y        | Y        |
# | remove any swap entry from /etc/fstab           | Y        | Y        |
# | net.bridge.bridge-nf-call-iptables is set to 1  | Y        | Y        |
# | Install Docker & enable on restart              | Y        | Y        |
# | Install kubeadm                                 | Y        | Y        |
# | Install kubelet                                 | Y        | N        |
# | Install kubectl                                 | Y        | N        |
# | Configure docker cgroupsfs                      | Y        | N        |
# | Creating Network Addons (flannel/Calico)        | Y        | N        |
# |-------------------------------------------------|----------|----------|

sudo swapoff -a

sudo setenforce 0

cat <<EOF >  /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF
sudo sysctl --system

sudo yum -y update

sudo yum install -y docker 

sudo systemctl start docker
sudo systemctl enable docker
sudo systemctl status docker

cat <<EOF > /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-x86_64
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
EOF
sudo yum install -y kubelet kubeadm kubectl

sudo systemctl enable kubelet && sudo systemctl start kubelet

echo "=== docker info | grep -i cgroup ====================="
sudo docker info | grep -i cgroup
echo "======================================================"

echo "****** WARNING *****"
echo "If output of above command isn't: Cgroup Driver: cgroupfs"
echo "Ensure"
echo "cat /etc/systemd/system/kubelet.service.d/10-kubeadm.conf"
echo "[Service]"
echo "Environment=\"KUBELET_CGROUP_ARGS=--cgroup-driver=cgroupfs\""
echo "****** WARNING *****"
echo ""

sudo systemctl daemon-reload && sudo systemctl restart kubelet && sudo kubeadm reset -f 
