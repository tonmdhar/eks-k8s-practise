resource "aws_ecr_repository" "app" {
  name = "eks-practise"
  image_tag_mutability = "MUTABLE"
  force_delete = true
  image_scanning_configuration {
    scan_on_push = true
  }
  tags = {
    Project = "eks-k8s-practice"
  }
}

output "ecr_repository_url" {
  value = aws_ecr_repository.app.repository_url
}

resource "null_resource" "docker_push" {
  depends_on = [aws_ecr_repository.app]

  triggers = {
    always_run = timestamp()
  }

  provisioner "local-exec" {
    command = "./push.sh ${aws_ecr_repository.app.repository_url}"
    working_dir = path.module
  }
}
