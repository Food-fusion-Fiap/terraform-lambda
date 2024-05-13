data "aws_caller_identity" "current" {}

data "terraform_remote_state" "rds_state" {
  backend = "s3"

  config = {
    bucket = var.s3_bucket_name
    key    = "prod/terraform-postgres.tfstate"
    region = "us-east-1"
  }
}

locals {
  aws_vpc_id = data.terraform_remote_state.rds_state.outputs.vpc_id
  aws_public_subnet_id = data.terraform_remote_state.rds_state.outputs.public_subnet_id
  aws_private_subnet_id = data.terraform_remote_state.rds_state.outputs.private_subnet_id
  aws_rds_public_sg_id = data.terraform_remote_state.rds_state.outputs.rds_public_sg_id
}
