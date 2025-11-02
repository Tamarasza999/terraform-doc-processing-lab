import json
import boto3

def lambda_handler(event, context):
    print("Validate Document Event:", json.dumps(event))
    
    try:
        # Extract message from SQS event
        if 'Records' in event:
            record = event['Records'][0]
            message = json.loads(record['body'])
        else:
            message = event
        
        document_id = message['documentId']
        bucket = message['bucket']
        key = message['key']
        
        # Simulate document validation
        s3 = boto3.client('s3')
        
        # Check if file exists and get metadata
        response = s3.head_object(Bucket=bucket, Key=key)
        file_size = response['ContentLength']
        content_type = response['ContentType']
        
        # Validate file type and size
        allowed_types = ['application/pdf', 'image/jpeg', 'image/png', 'text/plain']
        max_size = 10 * 1024 * 1024  # 10MB
        
        if content_type not in allowed_types:
            raise Exception(f"Unsupported file type: {content_type}")
        
        if file_size > max_size:
            raise Exception(f"File too large: {file_size} bytes")
        
        validation_result = {
            'documentId': document_id,
            'bucket': bucket,
            'key': key,
            'fileSize': file_size,
            'contentType': content_type,
            'status': 'VALID',
            'validationMessage': 'Document passed all validation checks'
        }
        
        print(f"Document validated: {document_id}")
        return validation_result
        
    except Exception as e:
        print(f"Validation error: {str(e)}")
        return {
            'documentId': message.get('documentId', 'unknown'),
            'status': 'INVALID',
            'error': str(e)
        }