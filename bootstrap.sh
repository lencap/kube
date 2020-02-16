#!/bin/bash
# bootstrap.sh
# Adapted from https://8gwifi.org/docs/kube-install.jsp

sudo bash -c 'cat >> /etc/hosts' << EOF
10.11.12.2    k2
10.11.12.3    k3 
EOF

sudo swapoff -a
sudo setenforce 0

sudo bash -c 'cat > /etc/sysctl.d/k8s.conf' << EOF
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF

sudo sysctl --system
sudo yum -y update
sudo yum install -y docker 
sudo systemctl start docker
sudo systemctl enable docker
sudo systemctl status docker

sudo bash -c 'cat > /etc/yum.repos.d/kubernetes.repo' << EOF
[kubernetes]
name=Kubernetes
baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-x86_64
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
EOF

sudo yum install -y kubelet kubeadm kubectl ipvsadm
sudo systemctl enable kubelet && sudo systemctl start kubelet

echo "Setting Cgroup Driver"
CgroupDriver=$(docker info 2>&1 | awk -F': ' '/Cgroup Driver/ {print $2}')
sudo mkdir -p /etc/systemd/system/kubelet.service.d
sudo bash -c 'cat > /etc/systemd/system/kubelet.service.d/10-kubeadm.conf' << EOF
[Service]
Environment="KUBELET_CGROUP_ARGS=--cgroup-driver=$CgroupDriver"
EOF
sudo systemctl daemon-reload && sudo systemctl restart kubelet

echo "Installing calicoctl"
CalicoCtlURL="https://github.com/projectcalico/calicoctl/releases/download/v3.12.0/calicoctl-linux-amd64"
sudo curl -L $CalicoCtlURL -o /usr/local/bin/calicoctl
sudo chmod +x /usr/local/bin/calicoctl

echo "Updating /root/.bashrc"
sudo bash -c 'echo "export PATH=\$PATH:/usr/local/bin" >> /root/.bashrc'
sudo bash -c 'echo -e "alias vi=vim\nalias h=history" >> /root/.bashrc'

exit 0
