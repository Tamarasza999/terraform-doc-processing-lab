output "bucket_name" {
  value = aws_s3_bucket.document_bucket.bucket
}

output "bucket_arn" {
  value = aws_s3_bucket.document_bucket.arn
}