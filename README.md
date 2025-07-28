# EKS Exercise

This repository contains a complete Amazon EKS (Elastic Kubernetes Service) exercise with a sample application and Terraform infrastructure code.

## Evidences
[evidence.md](evidences/evidence.md)

This include evidences for
- Cluster Startup
- IRSA using Terraform
- IRSA using 
- Github Action for deployment
- Metrics Server
- Others

## Project Structure

```
eks-exercise/
├── .github/                    # GitHub workflows and configurations
├── sample-app/                 # Sample Node.js application
│   ├── node_modules/          # Dependencies (library root)
│   ├── deployment.yaml        # Kubernetes deployment configuration
│   ├── Dockerfile            # Container image definition
│   ├── index.js              # Main application file
│   ├── package.json          # Node.js dependencies and scripts
│   ├── package-lock.json     # Dependency lock file
│   └── README.md             # Application-specific documentation
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

## Components

### Sample Application
- **Node.js** web application
- **Docker** containerization
- **Kubernetes** deployment manifests

### Infrastructure
- **Amazon EKS** cluster setup
- **VPC** and networking configuration
- **IAM** roles and policies
- **Terraform** for infrastructure provisioning

# Terraform
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
# Customize your terraform.tfvars from terraform.tfvars.example

# Initialize and apply Terraform
terraform init
terraform plan
terraform apply

# Change context to the created cluster.
aws eks update-kubeconfig --region us-east-1 --name kiet-demo-eks-cluster
kubectl config use-context <eks-arn>

# Verify the connection
kubectl get nodes

# Deploy application (Given that I build and push image "s3-write-test:latest" to ECR)
kubectl apply -f ./sample-app/deployment.yaml

# Wait and check for Pod deployment
kubectl get nodes

# Finally, go to EC2 > Load Balancers, We can access the application using the URL on this page.
```
### Use eksctl to create irsa


```bash
aws iam create-policy \
  --policy-name <policy-name> \
  --policy-document '{
    "Version": "2012-10-17",
    "Statement": [{
      "Effect": "Allow",
      "Action": [
        "s3:PutObject",
        "s3:GetObject",
        "s3:ListBucket"
      ],
      "Resource": [
        "arn:aws:s3:::*",
        "arn:aws:s3:::*/*"
      ]
    }]
  }'

eksctl create iamserviceaccount \
  --name <service-account-name> \
  --namespace default \
  --cluster <cluster-name> \
  --attach-policy-arn arn:aws:iam::<account-id>:policy/<policy-name> \
  --approve

# In your deployment YAML
spec:
  serviceAccountName: <service-account-name>
  containers:
    - name: app
      image: <aws-account-id>.dkr.ecr.<region>.amazonaws.com/<image-name>:<tag>
      ports:
        - containerPort: 3000
      env:
        - name: S3_BUCKET
          value: <bucket-name>
          

# To Authenticate the Github Action we also need to:
- Create IAM Role
- Add necessary permission
- Setup trust policy to trust Github OIDC
- Update EKS config map to allow this role to execute deployment
  - Most simple way is to update config map directly kubectl edit configmap aws-auth -n kube-system
```


# Sample Application
## S3 Write API (Node.js)
A simple Node.js API to write data to an S3 bucket via `/s3/write?name=...&content=...`.

## Features
- Accepts `name` and `content` query parameters.
- Defaults to `default.txt` and `Hello from default content` if not provided.
- Works on local and Kubernetes (ARM64/Mac M1 compatible).

---

## 1. Run Locally
### Prerequisites
- Node.js >= 18
- AWS credentials configured
- An existing S3 bucket

### Steps
```
npm install  
export S3_BUCKET=your-bucket-name  
node index.js
```

- Visit: http://localhost:3000/s3/write?name=test.txt&content=hello (If parameters are missing, defaults will be used.)
---

## 2. Build Docker Image
### Build (for Mac M1 - ARM64)
`docker buildx build --platform linux/arm64 -t <image-name>:latest .`

### Rebuild & Override (Save Disk Space)
`docker buildx build --platform linux/arm64 --no-cache -t <image-name>:latest .`

### Tag for ECR
`docker tag <image-name>:latest <account-id>.dkr.ecr.<region>.amazonaws.com/<image-name>:latest`

### Push to ECR
`docker push <account-id>.dkr.ecr.<region>.amazonaws.com/<image-name>:latest`

### Run
```# Ensure these environment variables are set in your shell before running:
# export S3_BUCKET=your-bucket-name
# export AWS_ACCESS_KEY_ID=your-access-key
# export AWS_SECRET_ACCESS_KEY=your-secret-key

docker run \
  -e S3_BUCKET \
  -e AWS_ACCESS_KEY_ID \
  -e AWS_SECRET_ACCESS_KEY \
  -p 3000:3000 <image-name>:latest
```

- Visit: http://localhost:3000/s3/write?name=test.txt&content=hello

---
## 3. K8S run on local
Apply & Access
```
kubectl apply -f deployment.yaml
kubectl port-forward svc/<image-name>-svc 8080:80
```

- Then open in browser: http://localhost:8080/s3/write?name=demo.txt&content=test

