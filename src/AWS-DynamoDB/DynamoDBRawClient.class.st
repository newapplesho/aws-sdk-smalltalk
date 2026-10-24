Class {
	#name : #DynamoDBRawClient,
	#superclass : #AWSClient,
	#classInstVars : [
		'default'
	],
	#category : #'AWS-DynamoDB'
}

{ #category : #defaults }
DynamoDBRawClient >> defaultConfigClass [
	^ AWSDynamoDBConfig 
]

{ #category : #'low-level-api' }
DynamoDBRawClient >> operationName: operationName contents: json [
	| datetimeString request body |
	datetimeString := DateAndTime amzDatePrintString.
	"Send the JSON as explicit UTF-8 bytes so Content-Length and the SigV4
	 payload hash (computed from request contents) match what goes on the wire,
	 also for non-ASCII strings."
	body := json utf8Encoded.

	request := ZnRequest empty.
	request method: #POST.
	request url:'/'.
	request entity:((ZnEntity bytes: body) contentType: 'application/x-amz-json-1.0').
	request headers at:'Content-Length' put: body size asString.
	request headers contentType:'application/x-amz-json-1.0'.
	request headers at:'host' put: self awsConfig endpoint.
	request headers at:'x-amz-date' put: datetimeString.
	request headers at:'x-amz-target' put: ( self awsConfig serviceName, '_', self awsConfig apiVersion,'.', operationName ).
	self awsConfig sessionToken ifNotNil: [ :token |
		request headers at:'X-Amz-Security-Token' put: token ].
	request setAuthorization: ( SignatureV4 creatAuthorization: request andConfig: self awsConfig andDateTime: datetimeString andOption: nil ).
	^ self request: request andOption: nil.
	
]
