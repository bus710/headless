#!/bin/bash

# https://kubernetes.io/docs/tasks/tools/
# https://www.downloadkubernetes.com/

set -e

CPU_TYPE=$(uname -m)
CPU_TARGET=""
VERSION=""
VERSION2=""

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

check_architecture(){
    if [[ $CPU_TYPE == "x86_64" ]]; then
        CPU_TARGET="amd64" 
    elif [[ $CPU_TYPE == "aarch64" ]]; then
        CPU_TARGET="arm64"
    else
        exit
    fi

    cd $HOME/Downloads
}

confirmation(){
    term_color_red
    echo "Check the stable version"
    term_color_white

    # VERSION=$(curl -L -s -w '\n' https://dl.k8s.io/release/stable.txt)
    VERSION=$(curl -o- -s  https://api.github.com/repos/kubernetes/kubernetes/releases/latest | jq -r '.tag_name')
    VERSION_TMP=$(echo $VERSION | grep -Eo '.*\.')
    VERSION2=${VERSION_TMP::-1}

    echo "kubectl - " $VERSION
    echo "kubeadm - " $VERSION2

    term_color_red
    echo "Kubectl, Minikube, and Kubeadm will be installed"
    echo "Do you want to install? (y/n)"
    term_color_white

    echo
    read -n 1 ans
    echo

    if [[ ! $ans == "y" ]]; then 
        exit
    fi
}

install_kubectl(){
    # Remove if there is an old one
    if [[ -f /usr/local/bin/kubectl ]]; then
        sudo rm -rf /usr/local/bin/kubectl
    fi

    term_color_red
    echo "Install Kubectl"
    echo "- https://kubernetes.io/docs/tasks/tools/install-kubectl-linux/"
    term_color_white

    curl -LO "https://dl.k8s.io/release/${VERSION}/bin/linux/${CPU_TARGET}/kubectl"

    term_color_red
    echo "Validate Kubectl"
    term_color_white

    curl -LO "https://dl.k8s.io/${VERSION}/bin/linux/${CPU_TARGET}/kubectl.sha256"
    RES=$(echo "$(cat kubectl.sha256) kubectl" | sha256sum --check)
    rm -rf kubectl.sha256
    
    if [[ ! $RES =~ "kubectl: OK" ]]; then
        term_color_red
        echo "Validation failed - exit"
        term_color_white
        exit
    fi

    term_color_red
    echo "Validation succeeded"
    echo "- move Kubectl under /usr/local/bin"
    term_color_white

    sudo install \
        -o $LOGNAME -g root -m 0755 \
        kubectl /usr/local/bin/kubectl
    sudo rm -rf kubectl
}

install_kubeadm(){
    term_color_red
    echo "Install Kubeadm"
    echo "- https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/install-kubeadm/"
    term_color_white

    # Cleanup
    sudo rm -rf /etc/apt/keyrings/kubernetes-apt-keyring.gpg
    sudo rm -rf /etc/apt/sources.list.d/kubernetes.list

    # Get the key
    sudo curl -fsSL https://pkgs.k8s.io/core:/stable:/${VERSION2}/deb/Release.key | \
        sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
    
    # Config the source list
    A="[signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg]"
    B="https://pkgs.k8s.io/core:/stable:/${VERSION2}/deb/"
    echo "deb $A $B /" | sudo tee /etc/apt/sources.list.d/kubernetes.list

    # Install Kubeadm
    sudo apt-get update
    sudo apt-get install -y kubelet kubeadm
    # sudo apt-mark hold kubelet kubeadm
}

install_minikube(){
    # Remove if there is an old one
    sudo rm -rf /usr/local/bin/minikube

    term_color_red
    echo "Install Minikube"
    term_color_white

    curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-${CPU_TARGET}

    sudo install \
        -o $LOGNAME -g root -m 0755 \
        minikube-linux-${CPU_TARGET} /usr/local/bin/minikube
    sudo rm -rf minikube
}

install_k3s(){
    # Remote if there is an old one
    if [[ -f /usr/local/bin/k3s-uninstall.sh ]]; then
        sudo /usr/local/bin/k3s-uninstall.sh
    fi

    term_color_red
    echo "Install k3s"
    term_color_white

    curl -sfL https://get.k3s.io | \
        INSTALL_K3S_EXEC="server" sh -s - --token 12345

    # There are 3 ways to refer the config
    # 1. sudo kubectl --kubeconfig=/etc/rancher/k3s/k3s.yaml get nodes
    # 2. export KUBECONFIG=/etc/rancher/k3s/k3s.yaml && sudo kubectl get nodes
    # 3. or below

    rm -rf $HOME/.kube
    mkdir $HOME/.kube
    sudo cp /etc/rancher/k3s/k3s.yaml $HOME/.kube/config
    sudo chown $LOGNAME:$LOGNAME $HOME/.kube/config
}

install_helm(){
    term_color_red
    echo "Install helm"
    term_color_white

    sudo rm -rf /usr/local/bin/helm

    HELM_VERSION=$(curl -o- -s  https://api.github.com/repos/helm/helm/releases/latest | jq -r '.tag_name')                  

    cd $HOME/Downloads
    wget https://get.helm.sh/helm-${HELM_VERSION}-linux-${CPU_TARGET}.tar.gz
    tar xf helm-${HELM_VERSION}-linux-${CPU_TARGET}.tar.gz
    sudo cp linux-${CPU_TARGET}/helm /usr/local/bin/helm

    rm -rf helm-${HELM_VERSION}-linux-${CPU_TARGET}.tar.gz
    rm -rf linux-${CPU_TARGET}
    cd -
}

post(){
    term_color_red
    echo "Done"
    echo "- kubectl get nodes"
    echo "- kubectl top node $NODE"
    echo "- kubectl describe nodes $NODE"
    echo "- kubectl apply -f $POD_FILE"
    echo "- kubectl apply -f $DEPLOYMENT_FILE"
    echo "- kubectl get pods --all-namespaces"
    echo "- kubectl delete pods $POD"
    echo "- kubectl exec -it $POD sh" # Log-in POD shell
    echo "- kubectl logs --tail=2 $POD"
    echo "- kubectl exec $POD -- sh -c '$COMMAND'" # Run a command inside of pod
    echo "- kubectl cp $POD:$TARGET_FILE $LOCAL_FILE" # Copy file from pod to local
    echo 
    echo "- sudo journalctl -u kubelet"
    echo "- sudo systemctl status k3s"
    echo "- sudo systemctl status kubelet"
    term_color_white
}

trap term_color_white EXIT
check_architecture
confirmation
install_kubectl
install_kubeadm
install_k3s
install_helm
post
