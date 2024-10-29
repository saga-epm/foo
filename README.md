# Infrastructure as Code (IaC) Project for Azure Resources

This project is designed to set up and manage Azure resources across different environments (Sandbox, Development, Test, and Production) using Terraform. 
All variable files are stored in Github as part of structured environments, and any changes to variable files must be reflected in the corresponding `terraform.tfvars` file under the `{environment}` folder.

## Setup Guide

### Prerequisites
- **Azure CLI** installed
- **Terraform** installed
- Access to **Azure Key Vault** for variable files

---

### Step 1: Backend Setup

1. **Navigate** to the `environments/{env}/backend` folder.
2. Ensure that `terraform.tfvars` file exists with required variables and values.
3. Run the following commands in order:

   ```bash
   terraform init
   terraform validate
   terraform plan
   terraform apply -auto-approve
   ```

   - This setup uses the backend module in the main folder to create the necessary resources:
     - **Resource Group**
     - **Storage Account**
     - **Storage Container**

4. Make a note of the output variables, as they will be needed for GitHub environment variables:

   | Environment Variable        | Terraform Output        |
   |-----------------------------|-------------------------|
   | BACKEND_RESOURCE_GROUP      | `resource_group_name`   |
   | BACKEND_STORAGE_ACCOUNT     | `storage_account_name`  |
   | BACKEND_STORAGE_CONTAINER   | `storage_container_name`|

   | Environment Secret          | Terraform Output        |
   |-----------------------------|-------------------------|
   | BACKEND_RESOURCE_GROUP      | `resource_group_name`   |

   5. Under GitHub Environments, navigate to the `{env}` Environment, and add the above environment variables with the values from the Terraform output.

---

### Step 2: Resource Setup

1. **Navigate** to the `environments/{env}/resources` folder.
2. Ensure `variables.tf` is defined with the following variables:

   ```hcl
   variable "appname" {}
   variable "environment" {}
   variable "region" {}
   variable "instance" {}
   variable "backend_resource_group_name" {}
   variable "backend_storage_account_name" {} 
   variable "backend_storage_account_container" {}
   variable "backend_storage_account_key" {}
   ```

3. Ensure `terraform.tfvars` exists with the backend module output values.
4. Run the commands below in order, substituting `<<sub-id>>` with the appropriate subscription ID:

   ```bash
   terraform init -var "subscription_id=<<sub-id>>"
   terraform validate
   terraform plan -var "subscription_id=<<sub-id>>"
   terraform apply -var "subscription_id=<<sub-id>>" -auto-approve
   ```

---

### Additional Commands

1. **Initialize Terraform modules**:
   ```bash
   terraform init
   ```

2. **Check Azure subscription**:
   ```bash
   az account show
   ```

3. **Change Azure subscription**:
   ```bash
   az login
   ```

4. **Manage workspaces**:
   ```bash
   terraform workspace list
   terraform workspace new {workspaceName}
   terraform workspace select {workspaceName}
   ```

5. **Plan, apply, and destroy resources by environment**:
   ```bash
   # Sandbox
   terraform plan -var-file="variables-sandbox.tfvars"
   terraform apply -var-file="variables-sandbox.tfvars"
   terraform destroy -var-file="variables-sandbox.tfvars"

   # Development
   terraform plan -var-file="variables-development.tfvars"
   terraform apply -var-file="variables-development.tfvars"
   terraform destroy -var-file="variables-development.tfvars"

   # Test
   terraform plan -var-file="variables-test.tfvars"
   terraform apply -var-file="variables-test.tfvars"
   terraform destroy -var-file="variables-test.tfvars"

   # Production
   terraform plan -var-file="variables-production.tfvars"
   terraform apply -var-file="variables-production.tfvars"
   terraform destroy -var-file="variables-production.tfvars"
   ```

6. **State management**:
   - **Pull state**:
     ```bash
     terraform state pull "module.mssql_database_module.azuread_service_principal.xccelerate_service_principal"
     ```
   - **View output**:
     ```bash
     terraform output output_variable
     ```

7. **Selective Resource Destruction**:
   ```bash
   terraform destroy --target aws_instance.resource_name
   ```

8. **Initialize Terraform with Azure Blob Storage**:
   ```bash
   terraform init -backend-config="resource_group_name=TF_VAR_env_resource_group_name" \
                  -backend-config="storage_account_name=TF_VAR_env_storage_account_name" \
                  -backend-config="storage_container_name=TF_VAR_env_storage_container_name" \
                  -backend-config="storage_key=TF_VAR_env_storage_key" \
                  -backend=true -force-copy -get=true -input=false
   ```

---

### Setup Steps Overview

1. **Call script** to set up environment variables locally or on GitHub.
2. **Run `terraform init` and `terraform plan`** in the backend folder to create the backend resources.
3. **Navigate to the resources folder** and configure the backend storage account details to store state as a blob.
4. **Configure environment variables** for backend configuration initialization.

---

This README provides a comprehensive step-by-step guide for setting up and managing resources across multiple environments using Terraform. Happy coding!
