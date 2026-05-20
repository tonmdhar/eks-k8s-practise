resource "aws_eks_cluster" "practice_cluster" {
  name     = "k8s-practice"
  role_arn = aws_iam_role.eks_role.arn

  vpc_config {
    subnet_ids = module.vpc.private_subnets
  }

  enabled_cluster_log_types = ["api", "audit", "authenticator"]
}

resource "aws_eks_node_group" "practice_nodes" {
  cluster_name    = aws_eks_cluster.practice_cluster.name
  node_group_name = "practice-nodes"
  node_role_arn   = aws_iam_role.eks_node_role.arn
  subnet_ids      = module.vpc.private_subnets

  scaling_config {
    desired_size = 2
    max_size     = 3
    min_size     = 1
  }

  instance_types = ["t3.medium"]

  tags = {
    Project = "eks-k8s-practise"
  }

  depends_on = [
    aws_iam_role_policy_attachment.eks_node_policy,
    aws_iam_role_policy_attachment.eks_cni_policy,
    aws_iam_role_policy_attachment.eks_ecr_policy,
  ]
}

resource "null_resource" "kubectl_config" {
  depends_on = [aws_eks_cluster.practice_cluster]

  provisioner "local-exec" {
    command = "aws eks update-kubeconfig --name k8s-practice --region us-east-1"
  }
}
