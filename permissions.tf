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
  * AWS IAM Policy for SSM
  *
  * This resource block defines an AWS IAM policy that allows Lambda functions to read
  * parameters from AWS Systems Manager Parameter Store.
  */
resource "aws_iam_policy" "ssm_policy" {
  name        = "ssm_policy"
  description = "SSM Policy"
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "ssm:GetParameters",
          "ssm:GetParameter"
        ],
        Resource = "arn:aws:ssm:${var.region}:${data.aws_caller_identity.current.account_id}:parameter/${var.project_name}/*"
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
resource "aws_iam_policy_attachment" "ssm_policy_attachment" {
  name       = "ssm_policy_attachment"
  roles      = [aws_iam_role.lambda_role.name]
  policy_arn = aws_iam_policy.ssm_policy.arn
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
  policy_arn = "arn:aws:iam::aws:policy/AmazonRDSReadOnlyAccess"
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