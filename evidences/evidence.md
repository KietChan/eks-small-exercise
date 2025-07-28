- [Evidences](#evidences)
  * [Execution](#execution)
  * [IRSA using Terraform](#irsa-using-terraform)
  * [IRSA using eksctl](#irsa-using-eksctl)
  * [Github Action for deployment](#github-action-for-deployment)
  * [Metric Server](#metric-server)
- [Others](#others)

## Evidences

### Execution
- Start up
- ![terraform-execute-success.png](images/terraform-execute-success.png)

- Tear Down
- ![tear-down.png](images/tear-down.png)

### IRSA using Terraform
- Application is working, and can write to S3 bucket
- ![Screenshot 2025-07-27 at 14.19.56.png](images/Screenshot%202025-07-27%20at%2014.19.56.png)
- ![Screenshot 2025-07-27 at 14.20.14.png](images/Screenshot%202025-07-27%20at%2014.20.14.png)
- ![Screenshot 2025-07-27 at 14.20.25.png](images/Screenshot%202025-07-27%20at%2014.20.25.png)

### IRSA using eksctl
- Remove write permission from irsa role

- ![Screenshot 2025-07-27 at 14.22.01.png](images/Screenshot%202025-07-27%20at%2014.22.01.png)

- Application now cannot access to our services anymore

- ![Screenshot 2025-07-27 at 14.22.10.png](images/Screenshot%202025-07-27%20at%2014.22.10.png)

- Create IAM policy, Service Account and Update deployment to use it

- ![Screenshot 2025-07-27 at 14.26.07.png](images/Screenshot%202025-07-27%20at%2014.26.07.png)
- ![Screenshot 2025-07-27 at 14.26.26.png](images/Screenshot%202025-07-27%20at%2014.26.26.png)
- ![Screenshot 2025-07-27 at 14.48.12.png](images/Screenshot%202025-07-27%20at%2014.48.12.png)
- ![Screenshot 2025-07-27 at 14.48.18.png](images/Screenshot%202025-07-27%20at%2014.48.18.png)

- Application can now write to S3 again

- ![Screenshot 2025-07-27 at 14.50.36.png](images/Screenshot%202025-07-27%20at%2014.50.36.png)
- ![Screenshot 2025-07-27 at 14.50.56.png](images/Screenshot%202025-07-27%20at%2014.50.56.png)

### Github Action for deployment
- Role Permission

- ![github-iam-permission.png](images/github-iam-permission.png)
- Role Trust Policy

- ![github-iam-trustpolicy.png](images/github-iam-trustpolicy.png)
- Before deployment

- ![github-action-before.png](images/github-action-before.png)
- After deployment

- ![github-action-after.png](images/github-action-after.png)
- Others - ECR

- ![github-action-ecr.png](images/github-action-ecr.png)
- Others - Github Log

- ![github-action-ok-log.png](images/github-action-ok-log.png)
- Config Map

- ![eks-github-configmap.png](images/eks-github-configmap.png)


### Metric Server
- ![metric-server.png](images/metric-server.png)


## Others
- Console information afte deployment
- ![after-deployment.png](images/after-deployment.png)

- EKS cluster overview
- ![eks-cluster-overview.png](images/eks-cluster-overview.png)

- EKS Pods after deploying
- ![eks-pods-after-deploy.png](images/eks-pods-after-deploy.png)

- Other screen show to show console UI after infrastructure deployed
- ![Screenshot 2025-07-27 at 15.50.12.png](images/Screenshot%202025-07-27%20at%2015.50.12.png)
- ![Screenshot 2025-07-27 at 15.50.19.png](images/Screenshot%202025-07-27%20at%2015.50.19.png)
- ![Screenshot 2025-07-27 at 15.50.42.png](images/Screenshot%202025-07-27%20at%2015.50.42.png)
