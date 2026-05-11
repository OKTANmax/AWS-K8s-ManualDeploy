# High-Available-Manual-Kubernetes-Cluster-Deployment-on-AWS-Hardened-Architecture

Project Overview

![Profile Photo](/Screenshots/VPC/VPC-Architecture.drawio.png)

This project demonstrates the end-to-end design and implementation of a Production-Ready Kubernetes (K8s) Cluster deployed manually on a hardened AWS infrastructure. 
The primary focus was to ensure High Availability (HA), and a "security-first" approach by isolating resources within private subnets and managing access through secure gateway.

Technical Implementation Phases

1. Architecture Design & Network Hardening:
Designed a multi-tier VPC architecture featuring public and private subnets across multiple Availability Zones.
This phase focused on creating a resilient foundation, utilizing NAT Gateway for outbound connectivity and Security Groups to enforce the principle of least privilege.

2. Infrastructure Provisioning:
Deployed and configured the underlying AWS resources (EC2 instances, IAM roles, and VPC endpoints).
The environment was optimized specifically for Kubernetes control plane and worker node requirements, ensuring proper synchronization and resource allocation.

3. Custom Bash Automation for K8s Bootstrapping:
To streamline the manual installation process, I developed an extensive Bash automation suite based on official Kubernetes documentation.
This script automates the installation of container runtimes (CRI), kubelet, and kubeadm, handling all system prerequisites up to the kubeadm init phase.

4. Cluster Initialization & Networking (CNI):
Initialized the cluster and integrated Calico as the Container Network Interface (CNI).
This provides robust, high-performance networking and allows for the implementation of fine-grained Network Policies for Pod-to-Pod communication.

5. Application Orchestration:
Authored declarative Kubernetes manifests, including Deployments for application lifecycle management and Services to define internal load balancing and service discovery within the cluster.

6. External Traffic Management:
Integrated the cluster with the AWS ecosystem by configuring Target Groups and an Application Load Balancer (ALB).
This ensures that external traffic is securely routed to the Kubernetes nodes while maintaining high availability and health-check monitoring.

**Key Skills Demonstrated**

- Cloud Infrastructure: VPC, EC2, ALB, NAT Gateways, Security Groups.

- Orchestration: Kubernetes Cluster Administration, kubeadm, CNI (Calico).

- Automation: Advanced Shell Scripting (Bash).

- Infrastructure Security.
