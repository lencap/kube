# kube
A minimum viable Kubernetes cluster with kubeadm

## Quick Start Guide
Bring up the 2 nodes (kmaster and kminion), and open a separate SSH shell session to each:
  vagrant up
  vagrant ssh kmaster
  vagrant ssh kminion

Get ready to init K8 Cluster

  kubeadm config images pull
  kubeadm init --service-cidr 10.96.0.0/12 --pod-network-cidr=192.168.0.0/16 --apiserver-advertise-address 10.11.12.2

If above runs correctly, it will tell you how to:

  1. Connect as a regular user
  2. How to add additional nodes to the cluster

<code>
Your Kubernetes master has initialized successfully!

To start using your cluster, you need to run the following as a regular user:

  mkdir -p $HOME/.kube
  sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
  sudo chown $(id -u):$(id -g) $HOME/.kube/config

You should now deploy a pod network to the cluster.
Run "kubectl apply -f [podnetwork].yaml" with one of the options listed at:
  https://kubernetes.io/docs/concepts/cluster-administration/addons/

You can now join any number of machines by running the following on each node
as root:

  kubeadm join 10.12.13.2:6443 --token dmki54.hv3740t9xlw587nr --discovery-token-ca-cert-hash sha256:f67423863bd7ced5b975e61c8109e3988c42d568c1fbfed22d88cb3d53f970a0
</code>

Confirm both nodes are running:
  kubectl get nodes
<code>
NAME      STATUS   ROLES    AGE   VERSION
kmaster   Ready    master   19m   v1.13.2
kminion   Ready    <none>   11m   v1.13.2
</code>

Install Calico Networking
  kubectl apply -f https://docs.projectcalico.org/v3.4/getting-started/kubernetes/installation/hosted/calico.yaml

Show all resources
  kubectl get all --all-namespaces

Restart Kuberlet engine
  systemctl restart kubelet && systemctl status kubelet

Verify Cluster info
  kubectl cluster-info

