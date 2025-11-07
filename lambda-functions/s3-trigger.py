import json
import boto3
import uuid
import os

sqs = boto3.client('sqs')
stepfunctions = boto3.client('stepfunctions')

def lambda_handler(event, context):
    print("S3 Trigger Event:", json.dumps(event))
    
    try:
        for record in event['Records']:
            bucket = record['s3']['bucket']['name']
            key = record['s3']['object']['key']
            
            #create unique document ID
            document_id = str(uuid.uuid4())
            
            #send message to SQS
            message = {
                'documentId': document_id,
                'bucket': bucket,
                'key': key,
                'timestamp': record['eventTime']
            }
            
            #get queue URL from environment variable or use default
            queue_url = os.environ.get('QUEUE_URL', 'http://localhost:4566/000000000000/dev-document-queue')
            
            sqs.send_message(
                QueueUrl=queue_url,
                MessageBody=json.dumps(message)
            )
            
            print(f"Queued document: {document_id} from {bucket}/{key}")
            
        return {
            'statusCode': 200,
            'body': json.dumps({'message': 'Processing started'})
        }
        
    except Exception as e:
        print(f"Error: {str(e)}")
        return {
            'statusCode': 500,
            'body': json.dumps({'error': str(e)})
        }
