# EKS Setup Instructions

## File Structure
```
├── main.tf
├── variables.tf
├── vpc.tf
├── eks.tf
├── iam.tf
├── kubernetes.tf
├── outputs.tf
├── terraform.tfvars.example
└── nginx-deployment.yaml
```

## Prerequisites
- AWS CLI configured
- Terraform installed
- kubectl installed
- helm installed

## Deployment Steps

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
```

### 2. Configure kubectl
```bash
# Get the command from terraform output
terraform output configure_kubectl
# Then run the command, e.g.:
aws eks --region us-west-2 update-kubeconfig --name demo-eks-cluster
```

### 3. Deploy Application
```bash
# Apply Kubernetes manifests
kubectl apply -f nginx-deployment.yaml

# Verify deployment
kubectl get pods
kubectl get svc
kubectl get hpa
```

## Verification Commands

### Check Infrastructure
```bash
# Verify nodes
kubectl get nodes
kubectl top nodes

# Verify metrics server
kubectl top pods -A
```

### Test LoadBalancer
```bash
# Get LoadBalancer URL
kubectl get svc nginx-service

# Test the service (replace with actual LoadBalancer DNS)
curl http://<EXTERNAL-IP>
```

### Test HPA
```bash
# Generate load to trigger scaling
kubectl run -i --tty load-generator --rm --image=busybox --restart=Never -- /bin/sh
# Inside the pod:
while true; do wget -q -O- http://nginx-service; done

# Watch HPA in another terminal
kubectl get hpa nginx-hpa --watch
```

### Test IRSA (S3 Access)
```bash
# Exec into AWS CLI pod
kubectl exec -it aws-cli-pod -- /bin/sh

# Inside the pod, test S3 access
aws s3 ls
aws sts get-caller-identity
```

### Check Logs
```bash
# View pod logs
kubectl logs -l app=nginx
kubectl logs aws-cli-pod

# Follow logs
kubectl logs -f deployment/nginx-deployment
```

## Cleanup
```bash
kubectl delete -f nginx-deployment.yaml
terraform destroy
```

## Key Components Implemented
- ✅ VPC with 2 private + 2 public subnets
- ✅ EKS cluster with managed node group (t3.medium, 2 nodes)
- ✅ Nginx deployment with LoadBalancer service
- ✅ HPA (2-5 replicas at 50% CPU)
- ✅ IRSA with S3 read-only policy
- ✅ Metrics Server for `kubectl top`
- ✅ ServiceAccount integration