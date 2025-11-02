terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  backend "local" {
    path = "terraform.tfstate"
  }
}

provider "aws" {
  access_key                  = "test"
  secret_key                  = "test"
  region                      = "us-east-1"
  skip_credentials_validation = true
  skip_metadata_api_check     = true
  skip_requesting_account_id  = true

  endpoints {
    s3             = "http://localhost:4566"
    lambda         = "http://localhost:4566"
    sqs            = "http://localhost:4566"
    sns            = "http://localhost:4566"
    stepfunctions  = "http://localhost:4566"
    apigateway     = "http://localhost:4566"
    kinesis        = "http://localhost:4566"
    dynamodb       = "http://localhost:4566"
    iam            = "http://localhost:4566"
    cloudwatch     = "http://localhost:4566"
  }

  s3_use_path_style = true
}

# 1. First create independent resources
module "dynamodb" {
  source = "../../modules/dynamodb-table"
  env    = var.env
}

module "sqs" {
  source = "../../modules/sqs-queue"
  env    = var.env
}

# 2. Create processing lambdas first
module "processing_lambdas" {
  source = "../../modules/processing-lambdas"
  env    = var.env

  s3_trigger_zip         = "s3-trigger.zip"
  validate_document_zip  = "validate-document.zip"
  ocr_processor_zip      = "ocr-processor.zip"
  data_transformer_zip   = "data-transformer.zip"
  final_storer_zip       = "final-storer.zip"
  kinesis_analytics_zip  = "kinesis-analytics.zip"

  sqs_queue_url       = module.sqs.queue_url
  dynamodb_table_name = module.dynamodb.table_name
}

# 3. Create Step Functions after lambdas exist
module "step_functions" {
  source = "../../modules/step-functions"
  env    = var.env

  validate_lambda_arn  = module.processing_lambdas.validate_document_arn
  ocr_lambda_arn       = module.processing_lambdas.ocr_processor_arn
  transform_lambda_arn = module.processing_lambdas.data_transformer_arn
  store_lambda_arn     = module.processing_lambdas.final_storer_arn
}

# 4. Create S3 trigger
module "s3_trigger" {
  source = "../../modules/s3-trigger"
  env    = var.env

  trigger_lambda_arn  = module.processing_lambdas.s3_trigger_arn
  trigger_lambda_name = module.processing_lambdas.s3_trigger_name
}

module "kinesis" {
  source = "../../modules/kinesis-stream"
  env    = var.env

  analytics_lambda_arn = module.processing_lambdas.kinesis_analytics_arn
}