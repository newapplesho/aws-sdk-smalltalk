Class {
	#name : #AWSLambda,
	#superclass : #AWSService,
	#category : #'AWS-Lambda'
}

{ #category : #private }
AWSLambda >> createRequest: aRequestBody url: url method: method [

	| request |
	request := ZnRequest empty.
	request method: method.
	request url: url.
	request entity: (ZnEntity with: aRequestBody type: ZnMimeType textPlain).
	request headers at: 'host' put: self awsConfig endpoint.
	request headers at: 'X-Amz-Invocation-Type' put: 'RequestResponse'.
	request headers at: 'LogType' put: 'None'.
	request headers at: 'x-amz-content-sha256' put: (SHA256 new hashMessage: aRequestBody) hex.
	^ self signRequest: request
]

{ #category : #defaults }
AWSLambda >> defaultConfigClass [
	^ AWSLambdaConfig 
]

{ #category : #private }
AWSLambda >> invokeLambda: functionName withPayload: payload [
	| url request |
	url := '/2015-03-31/functions' asZnUrl.
	url := url / functionName / 'invocations'.
	request := self createRequest: payload url: url method: #POST.
	^ self client request: request andOption: nil
]
