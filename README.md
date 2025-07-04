# Terraform AWS VPC & EKS

This repository provisions AWS infrastructure using Terraform with modular support for **VPC** and **EKS**. It enables quick, configurable deployments for both **ARM** and **AMD** architectures and integrates seamlessly with Jenkins pipelines for CI/CD automation.

---

## ⚙️ Features

- Modular design with `vpc` and `eks` modules  
- Supports node architectures: **ARM** and **AMD**  
- Multiple backend types: `remote`, `s3`, `gcs`, `azurerm`  
- Jenkinsfile included for automation  
- Useful for fast, repeatable infrastructure deployments

---

## 🚀 Quick Deployment Steps

1. Clone the repository  

2. Change into the project directory  

3. Initialize Terraform with a backend config  
   terraform init -backend-config=<backend-config-file>

4. Preview infrastructure changes  
   terraform plan -var-file=<var-file>

5. Apply the configuration  
   terraform apply -var-file=<var-file>

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
