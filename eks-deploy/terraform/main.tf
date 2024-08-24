# setup terraform aws provider to create resources in your desired aws region
provider "aws" {
  region = var.region
}

# invoke cluster module which creates vpc, subnets and eks cluter
module "cluster" {
  source = "./cluster"

  # vpc details
  vpc_name = var.vpc_name
  vpc_cidr = var.vpc_cidr

  # eks details
  eks_cluster_name = var.cluster_name
  k8s_version      = var.k8s_version
}

#invoke ecr module
module "ecr" {
  source = "terraform-aws-modules/ecr/aws"

  repository_name = "practical-devops"

  repository_read_write_access_arns = var.access_arns
  repository_lifecycle_policy = jsonencode({
    rules = [
      {
        rulePriority = 1,
        description  = "Keep last 30 images",
        selection = {
          tagStatus     = "tagged",
          tagPrefixList = ["v"],
          countType     = "imageCountMoreThan",
          countNumber   = 30
        },
        action = {
          type = "expire"
        }
      }
    ]
  })

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}