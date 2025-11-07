import json
import boto3
import time

def lambda_handler(event, context):
    print("OCR Processor Event:", json.dumps(event))
    
    try:
        document_id = event['documentId']
        
        #simulate OCR processing
        print(f"Starting OCR processing for document: {document_id}")
        
        #simulate processing time
        time.sleep(2)
        
        #mock OCR results
        ocr_results = {
            'documentId': document_id,
            'ocrStatus': 'COMPLETED',
            'extractedText': 'This is mock extracted text from the document. It contains important information that was processed through OCR.',
            'confidence': 0.95,
            'pagesProcessed': 1,
            'processingTime': 2.5
        }
        
        #merge with incoming event data
        result = {**event, **ocr_results}
        
        print(f"OCR completed for document: {document_id}")
        return result
        
    except Exception as e:
        print(f"OCR processing error: {str(e)}")
        return {
            'documentId': event.get('documentId', 'unknown'),
            'ocrStatus': 'FAILED',
            'error': str(e)
        }
