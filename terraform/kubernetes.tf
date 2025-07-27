# kubernetes.tf

# ServiceAccount with IRSA
resource "kubernetes_service_account" "demo" {
  metadata {
    name      = "demo-service-account"
    namespace = "default"
    annotations = {
      "eks.amazonaws.com/role-arn" = aws_iam_role.irsa_role.arn
    }
  }

  depends_on = [module.eks]
}