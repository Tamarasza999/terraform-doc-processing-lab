import json
import re
from datetime import datetime

def lambda_handler(event, context):
    print("Data Transformer Event:", json.dumps(event))
    
    try:
        document_id = event['documentId']
        extracted_text = event.get('extractedText', '')
        
        # Simulate data transformation
        print(f"Transforming data for document: {document_id}")
        
        # Extract structured data (mock implementation)
        structured_data = {
            'documentId': document_id,
            'entities': extract_entities(extracted_text),
            'keywords': extract_keywords(extracted_text),
            'summary': generate_summary(extracted_text),
            'transformedAt': datetime.utcnow().isoformat()
        }
        
        # Merge with incoming data
        result = {**event, **structured_data}
        result['transformationStatus'] = 'COMPLETED'
        
        print(f"Data transformation completed for document: {document_id}")
        return result
        
    except Exception as e:
        print(f"Data transformation error: {str(e)}")
        return {
            'documentId': event.get('documentId', 'unknown'),
            'transformationStatus': 'FAILED',
            'error': str(e)
        }

def extract_entities(text):
    # Mock entity extraction
    entities = []
    if 'important' in text.lower():
        entities.append({'type': 'KEY_PHRASE', 'value': 'important information', 'confidence': 0.9})
    if 'document' in text.lower():
        entities.append({'type': 'DOCUMENT_TYPE', 'value': 'document', 'confidence': 0.8})
    return entities

def extract_keywords(text):
    # Mock keyword extraction
    words = re.findall(r'\b\w+\b', text.lower())
    return list(set(words))[:5]  # Return top 5 unique words

def generate_summary(text):
    # Mock summary generation
    sentences = text.split('.')
    return sentences[0] + '.' if sentences else "No summary available"