# Terraform AWS VPC & EKS

This repository provisions AWS infrastructure using Terraform with modular support for **VPC** and **EKS**. It enables quick, configurable deployments for both **ARM** and **AMD** architectures and integrates seamlessly with Jenkins pipelines for CI/CD automation.

---

## ⚙️ Features

- Modular design with `vpc` and `eks` modules  
- Supports node architectures: **ARM** and **AMD**  
- Supports worker node types: **EC2** and **FARGATE**  
- Multiple backend types: `remote`, `s3`, `gcs`, `azurerm`  
- Jenkinsfile included for automation  
- Useful for fast, repeatable infrastructure deployments

---

# EKS with FARGATE


AWS Fargate is a serverless compute engine for containers that lets you run Kubernetes pods without managing EC2 instances. When using EKS with Fargate, AWS automatically provisions and scales the infrastructure required to run your pods.


## Things to Note

- Pods that run on Fargate are only supported on **private** subnets

## Verification Steps

### 1. Run a test pod

```bash
kubectl run nginx-pod --image=nginx --restart=Never
```

### 2. Check if it’s running on Fargate

```bash
kubectl describe pod nginx-pod | grep "Node"
```

You should see a node name starting with `fargate-`.


### 3. Verify CoreDNS is using Fargate
By default, CoreDNS is configured to run on Amazon EC2 infrastructure on Amazon EKS clusters.

```bash
kubectl get pods -n kube-system -l k8s-app=kube-dns -o wide
```

Check the `NODE` column — it should also show `fargate-...` style node names.

If CoreDNS pods are stuck in `Pending`, run following command:

```bash
kubectl rollout restart -n kube-system deployment coredns
```

---

## 🚀 Quick Deployment Steps

1. Clone the repository  

2. Change into the project directory  

3. Initialize Terraform with a backend config  
   terraform init -backend-config=`<path-to-backend-config-file>`

4. Preview infrastructure changes  
   terraform plan -var-file=`<path-to-var-file>`

5. Apply the configuration  
   terraform apply -var-file=`<path-to-var-file>`

---

## 🤖 Configure with Jenkins

This project includes a Jenkinsfile for pipeline automation with parameterized options:

- Select backend type: remote, s3, gcs, azurerm  
- Choose execution mode: local or remote (Terraform Cloud)  
- Provide custom backend and variable files  
- Optionally destroy the infrastructure

### Jenkins Setup Steps

1. Create a new Jenkins pipeline job  
2. Connect it to this repository  
3. Define parameters:
   - BACKEND_TYPE (e.g., remote)
   - HCP_EXEC_MODE (e.g., local)
   - BACKEND_CONFIG (e.g., remote-amd.hcl)
   - TF_VAR_FILE (e.g., amd.tfvars)
   - DESTROY_TERRAFORM (true/false)
4. Run the pipeline to provision or destroy the infrastructure

![Image](https://github.com/user-attachments/assets/cf9417f4-6a5c-4ee3-a043-a0806b914a73)