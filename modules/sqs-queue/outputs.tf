output "queue_url" {
  value = aws_sqs_queue.document_queue.url
}

output "queue_arn" {
  value = aws_sqs_queue.document_queue.arn
}