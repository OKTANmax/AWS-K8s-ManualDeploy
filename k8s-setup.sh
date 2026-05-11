#!/bin/bash

##System configuration script to prepare the machine to be a k8s node

## Preparing for Execution

set -e # if any error accured while executing,
set -o pipefail #if any error accured even in a pipline while executing, exit

LOG_FILE="/tmp/k8s_setup_$(date +'%Y-%m-%d_%H:%M:%S').log" # Log file  write down every thing.
NEW_HOSTNAME="Worker-Node-Machine" # write here hostname 

exec > >(tee -a "$LOG_FILE") 2>&1 # All output successes and error, display on screen and log it in the log file.

log_message() { # a function for logging 
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] $1"
}

log_message "Starting System Configuration for Kubernetes Initialization..."

#Step one: updating the system and changing hostname.

log_message "Changing Machine Hostname..."

sudo hostnamectl set-hostname "$NEW_HOSTNAME"

sudo sed -i "s/127.0.1.1.*/127.0.1.1 $NEW_HOSTNAME/g" /etc/hosts

log_message "Updating System Packages..."

sudo apt update -y && sudo apt upgrade -y

#Step two: Configuring system networking to work as a node

log_message "Configuring System Network and Kernel Modules..."

# Adding follwing kernel modules to be loaded automatically during early boot
cat <<EOF | sudo tee /etc/modules-load.d/kubernetes.conf 
overlay 
br_netfilter
EOF
# overlay: Required for Container Runtime to create lightweight, layered container images
#br_netfilter:  Essential for Kubernetes networking policies and pod-to-pod communication.

sudo modprobe overlay #apply module
sudo modprobe br_netfilter #apply module

#Setting Values for br_netfilter module
cat <<EOF | sudo tee /etc/sysctl.d/kubernetes.conf
net.bridge.bridge-nf-call-iptables  = 1
net.bridge.bridge-nf-call-ip6tables = 1
net.ipv4.ip_forward                 = 1
EOF

sudo sysctl --system # load and apply kernel parameters from all system configuration files immediately.

#Step three: Installing Container Runtime and Configuring Cgroup driver

log_message "Installing Containerd and Configuring Cgroup That will be used..."

sudo apt install -y containerd

sudo mkdir -p /etc/containerd

sudo containerd config default | sudo tee /etc/containerd/config.toml # extracting containerd default config and store it in config.toml

sudo sed -i 's/SystemdCgroup = false/SystemdCgroup = true/g' /etc/containerd/config.toml # edit containerd config to use systmed Cgroup.


sudo systemctl restart containerd 

sudo systemctl enable containerd 

#Step four:

log_message "Configuring Repos, and Downloading Kubernetes tools: kubeadm,kubectl and kubelet..."
#adding k8s repos.
sudo apt-get update

sudo apt-get install -y apt-transport-https ca-certificates curl gpg

sudo mkdir -p -m 755 /etc/apt/keyrings

curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.36/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg

echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.36/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list

sudo apt-get update

sudo apt-get install -y kubelet kubeadm kubectl

sudo apt-mark hold kubelet kubeadm kubectl # Holding k8s utilites for future updates

sudo systemctl enable --now kubelet

log_message "Setup Completed, Look at $LOG_FILE for loggng."