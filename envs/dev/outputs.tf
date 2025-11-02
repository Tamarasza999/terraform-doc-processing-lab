output "s3_bucket_name" {
  value = module.s3_trigger.bucket_name
}

output "kinesis_stream_name" {
  value = module.kinesis.stream_name
}

output "step_functions_arn" {
  value = module.step_functions.state_machine_arn
}

output "dynamodb_table" {
  value = module.dynamodb.table_name
}