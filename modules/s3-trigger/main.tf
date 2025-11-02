resource "aws_s3_bucket" "document_bucket" {
  bucket = "${var.env}-document-bucket"
}

resource "aws_s3_bucket_notification" "document_upload" {
  bucket = aws_s3_bucket.document_bucket.id

  lambda_function {
    lambda_function_arn = var.trigger_lambda_arn
    events              = ["s3:ObjectCreated:*"]
  }

  depends_on = [aws_lambda_permission.s3_trigger]
}

resource "aws_lambda_permission" "s3_trigger" {
  statement_id  = "AllowS3Invoke"
  action        = "lambda:InvokeFunction"
  function_name = var.trigger_lambda_name
  principal     = "s3.amazonaws.com"
  source_arn    = aws_s3_bucket.document_bucket.arn
}