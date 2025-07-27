# iam.tf

# IAM Role for demo purposes
resource "aws_iam_role" "demo_role" {
  name = "${var.cluster_name}-demo-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })

  tags = var.tags
}

# S3 Read/Write  policy for IRSA
resource "aws_iam_policy" "s3_read_write" {
  name        = "${var.cluster_name}-s3-read_write"
  description = "S3 read/write access policy for IRSA demo"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:ListBucket",
          "s3:PutObject"
        ]
        Resource = [
          "arn:aws:s3:::*",
          "arn:aws:s3:::*/*"
        ]
      }
    ]
  })

  tags = var.tags
}

# IRSA Role
resource "aws_iam_role" "irsa_role" {
  name = "${var.cluster_name}-irsa-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Federated = module.eks.oidc_provider_arn
        }
        Action = "sts:AssumeRoleWithWebIdentity"
        Condition = {
          StringEquals = {
            "${module.eks.oidc_provider}:sub": "system:serviceaccount:default:demo-service-account"
            "${module.eks.oidc_provider}:aud": "sts.amazonaws.com"
          }
        }
      }
    ]
  })

  tags = var.tags
}

# Attach S3 policy to IRSA role
resource "aws_iam_role_policy_attachment" "irsa_policy" {
  policy_arn = aws_iam_policy.s3_read_write.arn
  role       = aws_iam_role.irsa_role.name
}
