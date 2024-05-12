data "aws_caller_identity" "current" {}

data "aws_vpc" "main" {
  filter {
    name   = "tag:Name"
    values = ["main"]
  }
}

data "aws_subnet" "public_subnet" {
  filter {
    name   = "tag:Name"
    values = ["public_subnet"]
  }
}

data "aws_subnet" "private_subnet" {
  filter {
    name   = "tag:Name"
    values = ["private_subnet"]
  }
}

data "aws_security_group" "rds_public_sg" {
  filter {
    name   = "group-name"
    values = ["rds_public_sg"]
  }
}

data "aws_ssm_parameter" "db_host" {
  name = "/food_fusion/db_host"
}

data "aws_ssm_parameter" "db_name" {
  name = "/food_fusion/db_name"
}

data "aws_ssm_parameter" "db_username" {
  name = "/food_fusion/db_username"
}

data "aws_ssm_parameter" "db_password" {
  name = "/food_fusion/db_password"
}
