resource "aws_sfn_state_machine" "document_processor" {
  name     = "${var.env}-document-processor"
  role_arn = aws_iam_role.step_functions.arn

  definition = jsonencode({
    Comment = "Document Processing Workflow"
    StartAt = "ValidateDocument"
    States = {
      ValidateDocument = {
        Type = "Task"
        Resource = var.validate_lambda_arn
        Next = "IsDocumentValid"
        ResultPath = "$.validationResult"
        Catch = [{
          ErrorEquals = ["States.ALL"]
          Next = "ProcessFailed"
          ResultPath = "$.error"
        }]
      }
      IsDocumentValid = {
        Type = "Choice"
        Choices = [{
          Variable = "$.validationResult.status"
          StringEquals = "VALID"
          Next = "ProcessOCR"
        }]
        Default = "ProcessFailed"
      }
      ProcessOCR = {
        Type = "Task"
        Resource = var.ocr_lambda_arn
        Next = "TransformData"
        ResultPath = "$.ocrResult"
        Catch = [{
          ErrorEquals = ["States.ALL"]
          Next = "ProcessFailed"
          ResultPath = "$.error"
        }]
      }
      TransformData = {
        Type = "Task"
        Resource = var.transform_lambda_arn
        Next = "StoreResults"
        ResultPath = "$.transformationResult"
        Catch = [{
          ErrorEquals = ["States.ALL"]
          Next = "ProcessFailed"
          ResultPath = "$.error"
        }]
      }
      StoreResults = {
        Type = "Task"
        Resource = var.store_lambda_arn
        End = true
        ResultPath = "$.storageResult"
        Catch = [{
          ErrorEquals = ["States.ALL"]
          Next = "ProcessFailed"
          ResultPath = "$.error"
        }]
      }
      ProcessFailed = {
        Type = "Fail"
        Cause = "Document processing failed"
        Error = "ProcessingError"
      }
    }
  })
}

resource "aws_iam_role" "step_functions" {
  name = "${var.env}-step-functions-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "states.amazonaws.com"
      }
    }]
  })
}

resource "aws_iam_role_policy" "step_functions" {
  name = "${var.env}-step-functions-policy"
  role = aws_iam_role.step_functions.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action   = ["lambda:InvokeFunction"]
        Effect   = "Allow"
        Resource = "*"
      }
    ]
  })
}