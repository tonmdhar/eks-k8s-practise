resource "aws_iam_user" "github_actions" {
  name = "github-actions-deployer"

  tags = {
    Project = "eks-k8s-practice"
    Purpose = "CI/CD pipeline"
  }
}

resource "aws_iam_user_policy_attachment" "github_ecr" {
  user       = aws_iam_user.github_actions.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryPowerUser"
}

resource "aws_iam_policy" "github_eks_access" {
  name = "GitHubActionsEKSAccess"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "eks:DescribeCluster",
          "eks:ListClusters",
          "eks:AccessKubernetesApi"
        ]
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_user_policy_attachment" "github_eks" {
  user       = aws_iam_user.github_actions.name
  policy_arn = aws_iam_policy.github_eks_access.arn
}

resource "aws_iam_access_key" "github_actions" {
  user = aws_iam_user.github_actions.name
}

output "github_actions_access_key_id" {
  value     = aws_iam_access_key.github_actions.id
  sensitive = true
}

output "github_actions_secret_access_key" {
  value     = aws_iam_access_key.github_actions.secret
  sensitive = true
}
