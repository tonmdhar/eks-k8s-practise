module "vpc" {
  source = "terraform-aws-modules/vpc/aws"
  version = "5.17.0"

  name = "eks-practise-vpc"
  cidr = "10.1.0.0/16"

  azs             = ["us-east-1a", "us-east-1b"]
  private_subnets = ["10.1.1.0/24", "10.1.2.0/24"]
  public_subnets  = ["10.1.101.0/24", "10.1.102.0/24"]

  enable_nat_gateway = true
  single_nat_gateway = true

  enable_vpn_gateway = false

  private_subnet_tags = {
    "kubernetes.io/internal-elb" = "1"
    "kubernetes.io/cluster/k8s-practise" = "shared"
  }

  public_subnet_tags = {
    "kubernetes.io/role/elb" = "1"
  }

  tags = {
    Project = "eks-k8s-practice"
  }
}