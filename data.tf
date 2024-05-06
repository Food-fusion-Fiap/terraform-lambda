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
