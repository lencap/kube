#!/bin/bash
# bootstrap.sh

# Adapted from https://8gwifi.org/docs/kube-install.jsp
# Requirement                                      k2   k3
# Disable system swap and SELinux                  Y    Y
# remove any swap entry from /etc/fstab            Y    Y
# net.bridge.bridge-nf-call-iptables is set to 1   Y    Y
# Install Docker & enable on restart               Y    Y
# Install kubeadm                                  Y    Y
# Install kubelet                                  Y    N
# Install kubectl                                  Y    N
# Configure docker cgroupsfs                       Y    N
# Creating Network Addons (flannel/Calico)         Y    N
sudo swapoff -a
sudo setenforce 0
sudo cat <<EOF >  /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF
sudo sysctl --system
sudo yum -y update
sudo yum install -y docker 
sudo systemctl start docker
sudo systemctl enable docker
sudo systemctl status docker
sudo cat <<EOF > /etc/yum.repos.d/kubernetes.repo
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
sudo mkdir /etc/systemd/system/kubelet.service.d
sudo cat <<EOF > /etc/systemd/system/kubelet.service.d/10-kubeadm.conf
[Service]
Environment="KUBELET_CGROUP_ARGS=--cgroup-driver=cgroupfs"
EOF
echo "=== docker info | grep -i cgroup ====================="
sudo docker info | grep -i cgroup
echo "======================================================"
sudo systemctl daemon-reload && sudo systemctl restart kubelet && sudo kubeadm reset -f 
