# EKS Setup Instructions

## File Structure
```
└── terraform/                 # Infrastructure as Code
    ├── eks.tf               # EKS cluster configuration
    ├── iam.tf               # IAM roles and policies
    ├── kubernetes.tf        # Kubernetes resources
    ├── main.tf              # Main Terraform configuration
    ├── outputs.tf           # Output values
    ├── variables.tf         # Input variables
    ├── vpc.tf               # VPC and networking
    ├── terraform.tfvars.example # Example variables file
    └── readme.md            # Terraform documentation
```

## Prerequisites
- AWS CLI configured
- Terraform installed
- kubectl installed

## Deployment Steps

```bash
# Initialize and apply Terraform.
terraform init
terraform plan
terraform apply


```


### 1. Configure Variables
```bash
# Copy and customize tfvars
cp terraform.tfvars.example terraform.tfvars
# Edit terraform.tfvars with your values
```

### 2. Deploy Infrastructure
```bash
# Initialize and apply Terraform
terraform init
terraform plan
terraform apply

# Change context to the created cluster.
aws eks update-kubeconfig --region us-east-1 --name kiet-demo-eks-cluster
 
# Verify the connection
kubectl get nodes

# Deploy application (Given that I build and push image "s3-write-test:latest" to ECR)
kubectl apply -f ./sample-app/deployment.yaml

# Wait and check for Pod deployment
kubectl get nodes

# Finally, go to EC2 > Load Balancers, We can access the application using the URL on this page.
```

