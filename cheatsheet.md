# Kubernetes (K8s) Cheatsheet

## Cluster Info
```sh
kubectl cluster-info
kubectl get nodes
```

## Pods
```sh
kubectl get pods
kubectl describe pod <pod-name>
kubectl logs <pod-name>
kubectl exec -it <pod-name> -- /bin/sh
```

## Deployments
```sh
kubectl get deployments
kubectl apply -f deployment.yaml
kubectl delete deployment <deployment-name>
kubectl scale deployment <name> --replicas=3
kubectl rollout restart deployment <name>
```

## Services
```sh
kubectl get svc
kubectl expose deployment <name> --type=LoadBalancer --port=80 --target-port=3000
```

## Namespace
```sh
kubectl get ns
kubectl create ns <name>
kubectl config set-context --current --namespace=<name>
```

## Autoscaling
```sh
kubectl autoscale deployment <name> --cpu-percent=50 --min=2 --max=5
```

## Config & Secrets
```sh
kubectl create configmap <name> --from-literal=key=value
kubectl create secret generic <name> --from-literal=key=value
```

## Cleanup
```sh
kubectl delete pod <pod-name>
kubectl delete svc <svc-name>
kubectl delete -f <file.yaml>
```


# Terraform Cheatsheet

## Init & Setup
```sh
terraform init         # Initialize working directory
terraform validate     # Validate syntax
terraform fmt          # Format code
```

## Plan & Apply
```sh
terraform plan         # Show changes
terraform apply        # Apply changes
terraform apply -auto-approve
```

## Destroy
```sh
terraform destroy      # Destroy all resources
terraform destroy -target=aws_instance.example
```

## State Management
```sh
terraform show         # Show current state
terraform state list   # List resources in state
terraform state show <resource>
```

## Output & Variables
```sh
terraform output                    # Show all outputs
terraform output <output_name>     # Show specific output
terraform apply -var="key=value"   # Pass variable inline
terraform apply -var-file="vars.tfvars"
```

## Modules
```hcl
module "name" {
  source = "./modules/name"
  ...
}
```

## Providers
```hcl
provider "aws" {
  region = "us-west-2"
}
```
