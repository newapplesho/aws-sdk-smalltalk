Class {
	#name : #DynamoDBRawClient,
	#superclass : #AWSClient,
	#classInstVars : [
		'default'
	],
	#category : 'AWS-DynamoDB'
}

{ #category : #defaults }
DynamoDBRawClient >> defaultConfigClass [
	^ AWSDynamoDBConfig 
]

{ #category : #'low-level-api' }
DynamoDBRawClient >> operationName: operationName contents: json [
	| datetimeString request |
	datetimeString := DateAndTime amzDatePrintString.
	
	request := ZnRequest empty.
	request method: #POST.
	request url:'/'.
	request entity:((ZnEntity with: json) contentType: 'application/x-amz-json-1.0').
	request headers at:'Content-Length' put: json byteSize asString.
	request headers contentType:'application/x-amz-json-1.0'. 
	request headers at:'host' put: self awsConfig endpoint.
	request headers at:'x-amz-date' put: datetimeString.
	request headers at:'x-amz-target' put: ( self awsConfig serviceName, '_', self awsConfig apiVersion,'.', operationName ).	
	request setAuthorization: ( SignatureV4 creatAuthorization: request andConfig: self awsConfig andDateTime: datetimeString andOption: nil ).
	^ self request: request andOption: nil.
	
]
