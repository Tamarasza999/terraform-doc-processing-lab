output "table_name" {
  value = aws_dynamodb_table.documents.name
}

output "table_arn" {
  value = aws_dynamodb_table.documents.arn
}

output "stream_arn" {
  value = aws_dynamodb_table.documents.stream_arn
}