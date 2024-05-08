resource "aws_security_group" "lambda_auth_sg" {
  name   = "lambda_auth_sg"
  vpc_id = data.aws_vpc.main.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_lambda_function" "lambda_auth" {
  filename      = "lambda/lambda_function.zip"
  function_name = var.lambda_function_name
  role          = aws_iam_role.lambda_role.arn
  handler       = "app/index.handler"
  runtime       = "nodejs20.x"
  timeout       = 5
  memory_size   = 128

  environment {
    variables = {
      NODE_ENV = "production"
    }
  }

  vpc_config {
    subnet_ids         = [data.aws_subnet.public_subnet.id, data.aws_subnet.private_subnet.id]
    security_group_ids = [aws_security_group.lambda_auth_sg.id]
  }
}

resource "aws_security_group_rule" "lambda_to_rds" {
  type                     = "ingress"
  from_port                = 5432 # Porta do banco de dados na instância RDS
  to_port                  = 5432 # Porta do banco de dados na instância RDS
  protocol                 = "tcp"
  security_group_id        = data.aws_security_group.rds_public_sg.id # ID da security group da RDS
  source_security_group_id = aws_security_group.lambda_auth_sg.id     # ID da security group da Lambda
}


/**
 * AWS IAM Role for Lambda
 *
 * This resource block defines an AWS IAM role for Lambda functions.
 * The role allows Lambda functions to assume this role and perform actions on behalf of this role.
 */
resource "aws_iam_role" "lambda_role" {
  name = var.lambda_role_name
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action = [
        "sts:AssumeRole"
      ],
      Principal = {
        Service = "lambda.amazonaws.com"
      },
      Effect = "Allow"
    }]
  })
}


/**
 * Attach the AWS IAM policy to the Lambda function's role.
 *
 * This resource block attaches the AWS IAM policy specified by the `policy_arn` attribute
 * to the IAM role associated with the Lambda function. The `name` attribute is used to
 * provide a unique name for this policy attachment resource.
 */
resource "aws_iam_policy_attachment" "lambda_policy_attachment" {
  name       = var.lambda_policy_attachment_name
  roles      = [aws_iam_role.lambda_role.name]
  policy_arn = "arn:aws:iam::aws:policy/AWSLambda_FullAccess"
}

/**
  * Attach the AWS IAM policy to the Lambda function's role.
  *
  * This resource block attaches the AWS IAM policy specified by the `policy_arn` attribute
  * to the IAM role associated with the Lambda function. The `name` attribute is used to
  * provide a unique name for this policy attachment resource.
  */
resource "aws_iam_policy_attachment" "lambda_rds_policy" {
  name       = "lambda_rds_policy"
  roles      = [aws_iam_role.lambda_role.name]
  policy_arn = "arn:aws:iam::aws:policy/AmazonRDSFullAccess"
}

/**
  * AWS IAM Policy for SSM Access
  *
  * This resource block defines an AWS IAM policy that allows Lambda functions to access
  * the SSM parameter specified by the `resource` attribute.
  */
resource "aws_iam_policy" "ssm_access_policy" {
  name        = "SSMAccessPolicy"
  description = "Allows Lambda function to access SSM Parameter"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          # "ssm:Describe*",
          #       "ssm:Get*",
          #       "ssm:List*"
          "ssm:GetParameters",
          "ssm:GetParameter"
        ],
        Resource = [
          "arn:aws:ssm:us-east-1:616605573845:parameter/food_fusion/db_host",
          "arn:aws:ssm:us-east-1:616605573845:parameter/food_fusion/db_name",
          "arn:aws:ssm:us-east-1:616605573845:parameter/food_fusion/db_username",
          "arn:aws:ssm:us-east-1:616605573845:parameter/food_fusion/db_password"
        ]
      }
    ]
  })
}

/**
  * Attach the AWS IAM policy to the Lambda function's role.
  *
  * This resource block attaches the AWS IAM policy specified by the `policy_arn` attribute
  * to the IAM role associated with the Lambda function. The `name` attribute is used to
  * provide a unique name for this policy attachment resource.
  */
resource "aws_iam_role_policy_attachment" "lambda_ssm_access" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = aws_iam_policy.ssm_access_policy.arn
}

/**
  * Attach the AWS IAM policy to the Lambda function's role.
  *
  * This resource block attaches the AWS IAM policy specified by the `policy_arn` attribute
  * to the IAM role associated with the Lambda function. The `name` attribute is used to
  * provide a unique name for this policy attachment resource.
  */
resource "aws_iam_policy_attachment" "lambda_vpc_policy" {
  name       = "lambda_vpc_policy"
  roles      = [aws_iam_role.lambda_role.name]
  policy_arn = "arn:aws:iam::aws:policy/AmazonVPCFullAccess"
}

terraform {
  backend "s3" {
    bucket = "terraform-github-action"
    key    = "prod/lambda-auth.tfstate"
    region = "us-east-1"
  }
}
