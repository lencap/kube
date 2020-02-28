# Simple Kubernetes Cluster
A minimalist [Kubernetes](https://kubernetes.io/) cluster with [kubeadm](https://kubernetes.io/docs/setup/independent/create-cluster-kubeadm/) using the [vm](https://github.com/lencap/vm), which is a small utility that behaves a bit like Vagrant. 

## Quick Start Guide
1. The first step is to install the latest version of [vm](https://github.com/lencap/vm):
  * `brew install lencap/tools/vm`
  * Afterwards, run `vm` to get familiar with its usage, and to ensure that the SSH keys are created under `~/.vm`.

2. The next step is to create the `centos7.7.1908.ova` or `ubuntu1804.ova` OS image by running `vm imgpack` and following those instructions.

3. Beforehand, adjust the number of CPUs and Memory settings in `kube-<OS>.conf` to better suit your need. Then run `vm prov kube-<OS>.conf` to provision the 2 VMs. 

4. Open a separate SSH shell session to each:
  * `vm ssh k2`
  * `vm ssh k3`

5. Initialize the cluster from master k2 host:
  * `sudo kubeadm init --service-cidr 10.96.0.0/12 --pod-network-cidr=192.168.0.0/16 --apiserver-advertise-address 10.11.12.2`
  * The `--pod-network-cidr`setting is needed for Calico neetworking.
  
6. If Kubernetes master has initialized successfully, setup `kubectl` wherever you need to from the files in the k2 host:
  * `mkdir -p $HOME/.kube`
  * `sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config`
  * `sudo chown $(id -u):$(id -g) $HOME/.kube/config`

7. Install Calico as the Pod network add-on (get latest non-beta version):
  * `curl -O https://docs.projectcalico.org/v3.12/manifests/calico.yaml`
  * `vi calico.yaml` and make any necessary adjustments
  * `kubectl apply -f calico.yaml`
  * Afterwards check that the CoreDNS Pod is Running in the output of `kubectl get pods --all-namespaces`. And once the CoreDNS Pod is up and running, you can continue by joining your nodes.

8. Join k3 host as a member node:
  * On k2 host run: `sudo kubeadm token create --print-join-command`
  * On k3 host use output of above command to join cluster (as root, sudo) 

## Other Steps
* If you're having issues and want to tear everything down and start over. The easiest thing to do is to delete the two VMs with `vm del k2 -f`, and on, then reprovision. Alternatively you can try:
  * `sudo kubeadm reset -f && iptables -F && iptables -t nat -F && iptables -t mangle -F && iptables -X && ipvsadm -C`

* Confirm both nodes are running:
  * `kubectl get nodes`

```
NAME      STATUS   ROLES    AGE   VERSION
k2        Ready    master   19m   v1.17.0
k3        Ready    <none>   11m   v1.17.0
```

* Restart Kuberlet engine
  * `systemctl daemon-reload && systemctl restart kubelet && systemctl status kubelet`

* Verify Cluster info
  * `kubectl cluster-info`

## Notes
Install the https://github.com/ahmetb/kubectx utility wherever you're running `kubectl` from, to more easily switch context and namespaces.
