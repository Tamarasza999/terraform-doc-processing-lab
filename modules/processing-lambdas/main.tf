resource "aws_lambda_function" "s3_trigger" {
  filename      = var.s3_trigger_zip
  function_name = "${var.env}-s3-trigger"
  role          = aws_iam_role.lambda.arn
  handler       = "s3-trigger.lambda_handler"
  runtime       = "python3.9"
  timeout       = 30

  environment {
    variables = {
      QUEUE_URL = var.sqs_queue_url
    }
  }
}


resource "aws_lambda_function" "validate_document" {
  filename      = var.validate_document_zip
  function_name = "${var.env}-validate-document"
  role          = aws_iam_role.lambda.arn
  handler       = "validate-document.lambda_handler"
  runtime       = "python3.9"
  timeout       = 60
}


resource "aws_lambda_function" "ocr_processor" {
  filename      = var.ocr_processor_zip
  function_name = "${var.env}-ocr-processor"
  role          = aws_iam_role.lambda.arn
  handler       = "ocr-processor.lambda_handler"
  runtime       = "python3.9"
  timeout       = 120
  memory_size   = 512
}


resource "aws_lambda_function" "data_transformer" {
  filename      = var.data_transformer_zip
  function_name = "${var.env}-data-transformer"
  role          = aws_iam_role.lambda.arn
  handler       = "data-transformer.lambda_handler"
  runtime       = "python3.9"
  timeout       = 60
}


resource "aws_lambda_function" "final_storer" {
  filename      = var.final_storer_zip
  function_name = "${var.env}-final-storer"
  role          = aws_iam_role.lambda.arn
  handler       = "final-storer.lambda_handler"
  runtime       = "python3.9"
  timeout       = 30

  environment {
    variables = {
      TABLE_NAME = var.dynamodb_table_name
    }
  }
}


resource "aws_lambda_function" "kinesis_analytics" {
  filename      = var.kinesis_analytics_zip
  function_name = "${var.env}-kinesis-analytics"
  role          = aws_iam_role.lambda.arn
  handler       = "kinesis-analytics.lambda_handler"
  runtime       = "python3.9"
  timeout       = 60
}


resource "aws_iam_role" "lambda" {
  name = "${var.env}-lambda-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "lambda.amazonaws.com"
      }
    }]
  })
}

resource "aws_iam_role_policy" "lambda" {
  name = "${var.env}-lambda-policy"
  role = aws_iam_role.lambda.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "logs:*",
          "s3:*",
          "sqs:*",
          "states:*",
          "dynamodb:*",
          "kinesis:*"
        ]
        Effect   = "Allow"
        Resource = "*"
      }
    ]
  })
}
