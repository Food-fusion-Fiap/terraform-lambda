provider "aws" {
  region = var.region
}

terraform {
  backend "s3" {
    bucket = "terraform-state-fiap-group-18"
    key    = "prod/terraform-lambda.tfstate"
    region = "us-east-1"
  }
}