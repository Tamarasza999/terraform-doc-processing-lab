resource "aws_kinesis_stream" "analytics_stream" {
  name             = "${var.env}-analytics-stream"
  shard_count      = 1
  retention_period = 24

  shard_level_metrics = [
    "IncomingBytes",
    "OutgoingBytes",
    "WriteProvisionedThroughputExceeded",
    "ReadProvisionedThroughputExceeded",
  ]

  stream_mode_details {
    stream_mode = "PROVISIONED"
  }
}

resource "aws_lambda_event_source_mapping" "kinesis_trigger" {
  event_source_arn  = aws_kinesis_stream.analytics_stream.arn
  function_name     = var.analytics_lambda_arn
  starting_position = "LATEST"
  batch_size        = 100
}