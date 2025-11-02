import json
import boto3
from datetime import datetime

dynamodb = boto3.resource('dynamodb')

def lambda_handler(event, context):
    print("Final Storer Event:", json.dumps(event))
    
    try:
        table_name = "dev-documents"  # Would be from environment variable
        table = dynamodb.Table(table_name)
        
        document_id = event['documentId']
        
        # Prepare item for DynamoDB
        item = {
            'documentId': document_id,
            'userId': 'user123',  # Mock user ID
            'bucket': event.get('bucket'),
            'key': event.get('key'),
            'fileSize': event.get('fileSize'),
            'contentType': event.get('contentType'),
            'ocrStatus': event.get('ocrStatus'),
            'transformationStatus': event.get('transformationStatus'),
            'extractedText': event.get('extractedText'),
            'entities': event.get('entities', []),
            'keywords': event.get('keywords', []),
            'summary': event.get('summary'),
            'processedAt': datetime.utcnow().isoformat(),
            'status': 'COMPLETED'
        }
        
        # Store in DynamoDB
        response = table.put_item(Item=item)
        
        result = {
            'documentId': document_id,
            'storageStatus': 'COMPLETED',
            'dynamoDbResponse': response
        }
        
        print(f"Document stored in DynamoDB: {document_id}")
        return {**event, **result}
        
    except Exception as e:
        print(f"Storage error: {str(e)}")
        return {
            'documentId': event.get('documentId', 'unknown'),
            'storageStatus': 'FAILED',
            'error': str(e)
        }