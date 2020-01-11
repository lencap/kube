# Simple Kubernetes Cluster
A minimalist [Kubernetes](https://kubernetes.io/) cluster with [kubeadm](https://kubernetes.io/docs/setup/independent/create-cluster-kubeadm/) using [vm](https://github.com/lencap/vm), which is a small utility that behaves a bit like Vagrant. 

## Quick Start Guide
1. The first step is to install [vm](https://github.com/lencap/vm) by doing `brew install lencap/tools/vm`. After its  installation, make sure you run `vm` to see its usage and to ensure that 3 essential files are created under `~/.vm`.

2. The next step is to create the *centos7.7.1908-vm.ova* image by following the steps described when you run `vm imgdawn`.

3. Beforehand, you may have to adjust the CPUs and Memory settings in the `vm.conf` file to suit your environment. Next, run `vm prov` to provision the 2 VMs. 

4. Open a separate SSH shell session to each:
  * `vm ssh k2`
  * `vm ssh k3`

5. Initialize the cluster from master k2 host:
  * `sudo kubeadm config images pull`
  * `sudo kubeadm init --service-cidr 10.96.0.0/12 --pod-network-cidr=192.168.0.0/16 --apiserver-advertise-address 10.11.12.2`

6. If above runs correctly, it will tell you how to:
  * Connect to the cluser as a regular user and,
  * How to add additional nodes to the cluster (see below sample message that will be displayed)

```
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

  kubeadm join 10.11.12.2:6443 --token dmki54.hv3740t9xlw587nr --discovery-token-ca-cert-hash sha256:f67423863bd7ced5b975e61c8109e3988c42d568c1fbfed22d88cb3d53f970a0
```
Note, you'll need to use `sudo` for above command.

## Other Steps
Confirm both nodes are running:
  * `kubectl get nodes`

```
NAME      STATUS   ROLES    AGE   VERSION
k2        Ready    master   19m   v1.17.0
k3        Ready    <none>   11m   v1.17.0
```

Install latest Calico Networking (there may be a newer one)
  * `kubectl apply -f https://docs.projectcalico.org/v3.11/getting-started/kubernetes/installation/hosted/calico.yaml`

Show all resources
  * `kubectl get all --all-namespaces`

Restart Kuberlet engine
  * `systemctl restart kubelet && systemctl status kubelet`

Verify Cluster info
  * `kubectl cluster-info`

## Notes
Install the https://github.com/ahmetb/kubectx utility to switch context and namespaces more seamlessly.
