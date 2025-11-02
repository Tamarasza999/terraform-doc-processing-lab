class PipelineDemo {
    constructor() {
        this.processingSteps = [
            'S3: Document uploaded to bucket',
            'Lambda: S3 trigger executed',
            'SQS: Message queued for processing',
            'Step Functions: Workflow started',
            'Lambda: Document validation',
            'Lambda: OCR processing',
            'Lambda: Data transformation',
            'Lambda: Store results in DynamoDB',
            'Kinesis: Analytics data streamed',
            'COMPLETED: Document processed successfully'
        ];
    }

    log(message) {
        const logElement = document.getElementById('processingLog');
        const timestamp = new Date().toLocaleTimeString();
        logElement.innerHTML += `[${timestamp}] ${message}\n`;
        logElement.scrollTop = logElement.scrollHeight;
    }

    updateStatus(message, type = 'info') {
        const statusElement = document.getElementById('uploadStatus');
        statusElement.textContent = message;
        statusElement.className = `status-message status-${type}`;
    }

    async uploadDocument() {
        const fileInput = document.getElementById('fileInput');
        if (!fileInput.files[0]) {
            this.updateStatus('Please select a file first', 'error');
            return;
        }

        const fileName = fileInput.files[0].name;
        this.updateStatus(`Processing: ${fileName}`, 'info');
        this.log(`Starting upload: ${fileName}`);
        
        await this.simulatePipeline(fileName);
    }

    async testPipeline() {
        this.updateStatus('Running pipeline test...', 'info');
        this.log('Starting pipeline test...');
        
        const testFiles = ['document.pdf', 'image.jpg', 'data.txt'];
        
        for (const fileName of testFiles) {
            this.log(`Testing with: ${fileName}`);
            await this.simulatePipeline(fileName);
            await this.delay(1000);
        }
        
        this.updateStatus('Pipeline test completed', 'success');
    }

    async simulatePipeline(fileName) {
        try {
            // Step 1: S3 Upload
            this.log('1. S3: Uploading document to bucket...');
            await this.delay(1000);
            this.log('   S3: Document stored successfully');

            // Step 2: Lambda Trigger
            this.log('2. Lambda: S3 event trigger executed');
            await this.delay(800);
            this.log('   Lambda: Document metadata extracted');

            // Step 3: SQS Message
            this.log('3. SQS: Sending message to queue...');
            await this.delay(600);
            this.log('   SQS: Message queued for processing');

            // Step 4: Step Functions
            this.log('4. Step Functions: Starting workflow...');
            await this.delay(500);
            
            // Step 5-8: Processing steps
            const processingSteps = [
                'Lambda: Validating document format',
                'Lambda: Running OCR extraction',
                'Lambda: Transforming data structure',
                'Lambda: Storing in DynamoDB'
            ];

            for (const step of processingSteps) {
                this.log(`   ${step}...`);
                await this.delay(400);
                this.log(`   ${step.split(':')[0]}: Completed`);
            }

            // Step 9: Kinesis
            this.log('5. Kinesis: Streaming analytics data...');
            await this.delay(300);
            this.log('   Kinesis: Analytics data processed');

            // Completion
            this.log(`SUCCESS: "${fileName}" processed through entire pipeline`);
            this.log('--- Pipeline Complete ---');

        } catch (error) {
            this.log(`ERROR: ${error.message}`);
            this.updateStatus('Processing failed', 'error');
        }
    }

    delay(ms) {
        return new Promise(resolve => setTimeout(resolve, ms));
    }

    clearLog() {
        document.getElementById('processingLog').innerHTML = 'Log cleared...\n';
        this.updateStatus('', 'info');
    }

    showArchitecture() {
        this.log('\nARCHITECTURE OVERVIEW:');
        this.log('S3 (Storage) -> Lambda (Compute) -> SQS (Queue) ->');
        this.log('Step Functions (Orchestration) -> Multiple Lambdas (Processing) ->');
        this.log('DynamoDB (Database) -> Kinesis (Analytics)');
        this.log('\nAll services deployed with Terraform + LocalStack');
    }

    showTerraform() {
        this.log('\nTERRAFORM DEPLOYMENT:');
        this.log('Modules:');
        this.log('  - s3-trigger: S3 bucket with Lambda trigger');
        this.log('  - sqs-queue: Message queue for async processing');
        this.log('  - step-functions: Workflow orchestration');
        this.log('  - processing-lambdas: Multiple Lambda functions');
        this.log('  - dynamodb-table: NoSQL data storage');
        this.log('  - kinesis-stream: Real-time analytics');
        this.log('\nInfrastructure as Code: All AWS resources defined in Terraform');
    }
}

// Initialize demo
const demo = new PipelineDemo();

// Global functions for HTML buttons
function uploadDocument() {
    demo.uploadDocument();
}

function testPipeline() {
    demo.testPipeline();
}

function clearLog() {
    demo.clearLog();
}

function showArchitecture() {
    demo.showArchitecture();
}

function showTerraform() {
    demo.showTerraform();
}

// Auto-show architecture on load
window.onload = function() {
    demo.showArchitecture();
};