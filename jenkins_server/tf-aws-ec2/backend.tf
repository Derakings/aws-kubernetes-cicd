terraform {
  backend "s3" {
    bucket = "terraform-eks-cicd-1456"
    key    = "jenkins/terraform.tfstate"
    region = "us-east-1"
  }
}