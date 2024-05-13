resource "aws_ssm_parameter" "jwt_secret" {
  name  = "/${var.project_name}/jwt_secret"
  value = var.jwt_secret
  type  = "SecureString" # Important to store the password securely in SSM
}

resource "aws_security_group" "lambda_auth_sg" {
  name   = "lambda_auth_sg"
  vpc_id = local.aws_vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_lambda_function" "lambda_auth" {
  filename      = "lambda-auth/dist/lambda_function.zip"
  source_code_hash = filebase64("lambda-auth/dist/lambda_function.zip")
  function_name = var.lambda_function_name
  role          = aws_iam_role.lambda_role.arn
  handler       = "app/authenticate.handler"
  runtime       = "nodejs20.x"
  timeout       = 5
  memory_size   = 128

  environment {
    variables = {
      NODE_ENV = "production"
    }
  }

  vpc_config {
    subnet_ids         = [local.aws_public_subnet_id, local.aws_private_subnet_id]
    security_group_ids = [aws_security_group.lambda_auth_sg.id]
  }
}

resource "aws_security_group_rule" "lambda_to_rds" {
  type                     = "ingress"
  from_port                = 5432 # Porta do banco de dados na instância RDS
  to_port                  = 5432 # Porta do banco de dados na instância RDS
  protocol                 = "tcp"
  security_group_id        = local.aws_rds_public_sg_id # ID da security group da RDS
  source_security_group_id = aws_security_group.lambda_auth_sg.id     # ID da security group da Lambda
}
