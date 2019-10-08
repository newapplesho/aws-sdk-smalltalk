Class {
	#name : #AWSLambda,
	#superclass : #AWSService,
	#category : #'AWS-Lambda'
}

{ #category : #private }
AWSLambda >> createInvokeRequest: functionName payload: payload [
	| url request |
	url := '/2015-03-31/functions' asZnUrl.
	url := url / functionName / 'invocations'.
	request := self createRequest: payload url: url method: #POST.
	request inspect.
	^ self client request: request andOption: nil
]

{ #category : #private }
AWSLambda >> createRequest: aRequestBody url: url method: method [ 
		
	| datetimeString hostUrl request |
	datetimeString := DateAndTime amzDatePrintString.
	hostUrl := self awsConfig endpoint.
	
	request := ZnRequest empty.
	request method: method.
	request url: url.

	request entity:(ZnEntity with: aRequestBody type: (ZnMimeType textPlain)). 
	request headers at:'host' put: hostUrl.
	request headers at:'X-Amz-Invocation-Type' put: 'RequestResponse'.
	request headers at:'LogType' put: 'None'.
	self awsConfig sessionToken ifNotNil: [ request headers at:'X-Amz-Security-Token' put: self awsConfig sessionToken ].	
	request headers at:'x-amz-content-sha256' put: (SHA256 new hashMessage: aRequestBody) hex.
	request headers at:'x-amz-date' put: datetimeString.
	request setAuthorization: ( SignatureV4 creatAuthorization: request andConfig: self awsConfig andDateTime: datetimeString andOption: nil ) .
	^ request
]

{ #category : #defaults }
AWSLambda >> defaultConfigClass [
	^ AWSLambdaConfig 
]
