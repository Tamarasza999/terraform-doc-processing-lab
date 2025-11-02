resource "aws_sqs_queue" "document_queue" {
  name                      = "${var.env}-document-queue"
  delay_seconds             = 0
  message_retention_seconds = 86400
  visibility_timeout_seconds = 300
}