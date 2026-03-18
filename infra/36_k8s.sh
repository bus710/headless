#!/bin/bash

# https://kubernetes.io/docs/tasks/tools/
# https://www.downloadkubernetes.com/

set -e

VERSION=""
TARGET=""

if [[ "$EUID" == 0 ]]; then 
    echo "Please run as super user (w/o sudo)"
    exit
fi

term_color_red () {
    echo -e "\e[91m"
}

term_color_white () {
    echo -e "\e[39m"
}

confirmation(){
    term_color_red
    echo "Check the stable version"
    term_color_white

    term_color_red
    echo "k8s base will be installed (this is meant to be used in VMs)"
    echo
    echo "Do you want to proceed?"
    echo "- Press 'c' for k8s control plane"
    echo "- Press 'w' for k8s worker"
    echo "- Press 'n' to exit"
    term_color_white

    read -n 1 ans
    echo

    if [[ $ans == "c" ]]; then
        TARGET="cp"
    elif [[ $ans == "w" ]]; then
        TARGET="wk"
    else
        exit 1
    fi

    VER=$(curl -o- -s https://api.github.com/repos/kubernetes/kubernetes/releases/latest | jq -r '.name')
    VERSION="${VER%.*}"
}

swapoff() {
    term_color_red 
    echo "Swap off"
    term_color_white

    sudo bash -c "swapoff -a"
    sudo sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab
}

load_kernerl_module() {
    term_color_red 
    echo "Load kernel modules"
    term_color_white

cat <<EOF | sudo tee /etc/modules-load.d/k8s.conf
overlay
br_netfilter
EOF

    sudo modprobe overlay
    sudo modprobe br_netfilter
}

config_sysctl(){
    term_color_red 
    echo "Config sysctl"
    term_color_white

cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-iptables  = 1
net.bridge.bridge-nf-call-ip6tables = 1
net.ipv4.ip_forward                 = 1
EOF

sudo sysctl --system   
}

install_containerd(){
    term_color_red 
    echo "Install containerd"
    term_color_white

    sudo apt-get update -y
    sudo apt-get install -y ca-certificates curl gnupg

    install -m 0755 -d /etc/apt/keyrings
    curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
    sudo chmod a+r /etc/apt/keyrings/docker.gpg

    echo \
        "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
    sudo tee /etc/apt/sources.list.d/docker.list

    sudo apt-get update
    sudo apt-get install -y containerd.io
}

config_containerd(){
    term_color_red 
    echo "Config containerd"
    term_color_white

    sudo containerd config default | sudo tee /etc/containerd/config.toml
    sudo sed -i 's/SystemdCgroup = false/SystemdCgroup = true/' /etc/containerd/config.toml
    sudo systemctl restart containerd
    sudo systemctl enable containerd
}

install_k8s(){
    term_color_red 
    echo "Install k8s"
    term_color_white

    sudo apt-get install -y apt-transport-https ca-certificates curl gpg

    curl -fsSL https://pkgs.k8s.io/core:/stable:/"$VERSION"/deb/Release.key | \
        sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg

    echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/"$VERSION"/deb/ /' | \
        sudo tee /etc/apt/sources.list.d/kubernetes.list

    sudo apt-get update -y
    sudo apt-get install -y kubelet kubeadm kubectl
    sudo apt-mark hold kubelet kubeadm kubectl
}

init_k8s(){
    if [[ $TARGET != "cp" ]]; then
        return
    fi

    term_color_red 
    echo "Innitialize k8s"
    term_color_white

    ADDR=$(ip -4 -o addr show eth0 | awk '{print $4}' | cut -d/ -f1)

    sudo kubeadm init \
        --pod-network-cidr=192.168.0.0/16 \
        --apiserver-advertise-address=$ADDR
}

config_kubectl(){
    if [[ $TARGET != "cp" ]]; then
        return
    fi

    term_color_red 
    echo "Config kubectl"
    term_color_white

    mkdir -p $HOME/.kube
    sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
    sudo chown $(id -u):$(id -g) $HOME/.kube/config
}

install_calico(){
    if [[ $TARGET != "cp" ]]; then
        return
    fi

    term_color_red 
    echo "Install calico"
    term_color_white

    kubectl apply -f https://raw.githubusercontent.com/projectcalico/calico/v3.27.0/manifests/calico.yaml
}

print_kubeadm_join(){
    if [[ $TARGET != "cp" ]]; then
        return
    fi

    term_color_red 
    echo "Show the k8s token to be used by workers"
    term_color_white

    kubeadm token create --print-join-command
}

join(){
    if [[ $TARGET != "wk" ]]; then
        return
    fi

    term_color_red 
    echo "Please manually join to the cluster"
    term_color_white
}

install_helm(){
    if [[ $TARGET != "cp" ]]; then
        return
    fi

    term_color_red
    echo "Install helm"
    term_color_white

    curl -LO https://git.io/get_helm.sh
    chmod 700 get_helm.sh
    ./get_helm.sh
}

post(){
    term_color_red
    echo "Done"
    term_color_white 

    if [[ $TARGET != "cp" ]]; then
        return
    fi

    term_color_red
    echo "- kubectl get nodes"
    echo "- kubectl top node $NODE"
    echo "- kubectl describe nodes $NODE"
    echo
    echo "- kubectl apply -f $POD_FILE"
    echo "- kubectl apply -f $DEPLOYMENT_FILE"
    echo "- kubectl get pods --all-namespaces"
    echo "- kubectl delete pods --all"
    echo "- kubectl delete pods $POD"
    echo
    echo "- kubectl exec -it $POD sh" # Log-in POD shell
    echo "- kubectl logs --tail=2 $POD"
    echo "- kubectl exec $POD -- sh -c '$COMMAND'" # Run a command inside of pod
    echo "- kubectl cp $POD:$TARGET_FILE $LOCAL_FILE" # Copy file from pod to local
    echo
    echo "- kubectl delete deploy --all" # Delete all controllers
    echo 
    echo "- kubectl get all"
    echo 
    echo "- sudo journalctl -u kubelet"
    echo "- sudo systemctl status k3s"
    echo "- sudo systemctl status kubelet"
    term_color_white
}

trap term_color_white EXIT
confirmation
swapoff
load_kernerl_module 
config_sysctl
install_containerd 
config_containerd
install_k8s
init_k8s
config_kubectl 
install_calico 
install_helm
# config_editor
post
print_kubeadm_join
join

# Also consider:
# - https://github.com/ahmetb/kubectx?tab=readme-ov-file#apt-debian
# - https://github.com/johanhaleby/kubetail
# - https://github.com/kubernetes-sigs/krew?tab=readme-ov-file
