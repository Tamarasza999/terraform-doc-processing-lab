output "s3_trigger_arn" {
  value = aws_lambda_function.s3_trigger.arn
}

output "s3_trigger_name" {
  value = aws_lambda_function.s3_trigger.function_name
}

output "validate_document_arn" {
  value = aws_lambda_function.validate_document.arn
}

output "ocr_processor_arn" {
  value = aws_lambda_function.ocr_processor.arn
}

output "data_transformer_arn" {
  value = aws_lambda_function.data_transformer.arn
}

output "final_storer_arn" {
  value = aws_lambda_function.final_storer.arn
}

output "kinesis_analytics_arn" {
  value = aws_lambda_function.kinesis_analytics.arn
}