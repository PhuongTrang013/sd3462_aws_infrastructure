terraform {
  backend "s3" {
    bucket = "sd3462-bucket"
    key    = "jenkins/terraform.tfstate"
    region = "us-east-1"
  }
}