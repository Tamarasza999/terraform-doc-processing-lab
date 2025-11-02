variable "env" {
  type = string
}

variable "s3_trigger_zip" { type = string }
variable "validate_document_zip" { type = string }
variable "ocr_processor_zip" { type = string }
variable "data_transformer_zip" { type = string }
variable "final_storer_zip" { type = string }
variable "kinesis_analytics_zip" { type = string }

variable "sqs_queue_url" { type = string }
variable "dynamodb_table_name" { type = string }