provider "aws" {
  region = var.region
}

terraform {
  backend "s3" {
    bucket = "terraform-github-action"
    key    = "prod/terraform-lambda.tfstate"
    region = "us-east-1"
  }
}