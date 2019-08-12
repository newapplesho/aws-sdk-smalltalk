Class {
	#name : #ElasticTranscoder,
	#superclass : #AWSService,
	#category : 'AWS-ElasticTranscoder'
}

{ #category : #'job-Operations' }
ElasticTranscoder >> createJob: aCreateJobRequestBody [
	| request response |
	request := self createRequest: aCreateJobRequestBody url:'/2012-09-25/jobs' method: #POST.
	response :=  self client request: request andOption: nil.
	^ self readJsonFromResponse: response.
]

{ #category : #'pipeline-Operations' }
ElasticTranscoder >> createPipeline: aCreatePipelineRequestBody [
	| request response |
	request := self createRequest: aCreatePipelineRequestBody url:'/2012-09-25/pipelines' method: #POST.
	response := self client request: request andOption: nil.
	^ self readJsonFromResponse: response.
]

{ #category : #private }
ElasticTranscoder >> createRequest: aRequestBody url: url method: method [

	| amzDatePrintString request  requestBodyString |
	amzDatePrintString := DateAndTime amzDatePrintString.
	
	request := ZnRequest empty.
	request method: method.
	request url: url.

	aRequestBody ifNotNil:[ 
		requestBodyString := aRequestBody asJsonString.
		request entity:((ZnEntity with: requestBodyString) contentType: 'application/x-amz-json-1.0'). ].
	
	request headers contentType:'application/x-amz-json-1.0'. 
	request headers at:'host' put: self awsConfig endpoint.
	request headers at:'x-amz-date' put: amzDatePrintString.
	request setAuthorization: ( SignatureV4 creatAuthorization: request andConfig: self awsConfig andDateTime: amzDatePrintString ).
	^ request
]

{ #category : #defaults }
ElasticTranscoder >> defaultConfigClass [
	^ AETConfig  
]

{ #category : #'pipeline-Operations' }
ElasticTranscoder >> deletePipeline: pipelineIdString [
	| request response |
	request := self createRequest: nil url: '/2012-09-25/pipelines/',pipelineIdString method: #DELETE.
	response := self client request: request andOption: nil.
	^ self readJsonFromResponse: response.
]

{ #category : #'pipeline-Operations' }
ElasticTranscoder >> readPipeline: pipelineIdString [
	| request response |
	request := self createRequest: nil url: '/2012-09-25/pipelines/',pipelineIdString method: #GET.
	response := self client request: request andOption: nil.
	^ self readJsonFromResponse: response.
]
