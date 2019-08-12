Class {
	#name : #CloudFront,
	#superclass : #AWSService,
	#instVars : [
		'distributionId'
	],
	#category : 'AWS-CloudFront'
}

{ #category : #defaults }
CloudFront >> defaultClientClass [
	^ CloudFrontClient 
]

{ #category : #defaults }
CloudFront >> defaultConfigClass [
	^ AWSCFConfig 
]

{ #category : #defaults }
CloudFront >> defaultUri [
	^ '/', self awsConfig apiVersion, '/distribution'
]

{ #category : #accessing }
CloudFront >> distributionId [
	^ distributionId
]

{ #category : #accessing }
CloudFront >> distributionId: anObject [
	distributionId := anObject
]

{ #category : #actions }
CloudFront >> getInvalidation: invalidationId [
	| amzDatePrintString request |
	amzDatePrintString := self amzDatePrintString.
	request := ZnRequest empty.
	request method: #GET.
	request url: self invalidationUri, '/', invalidationId.
	request headers at: 'host' put: self awsConfig endpoint.
	request headers at: 'x-amz-date' put: amzDatePrintString.
	request
		setAuthorization: (SignatureV4 creatAuthorization: request andConfig: self awsConfig andDateTime: amzDatePrintString).
	^ self client request: request andOption: nil
]

{ #category : #actions }
CloudFront >> getInvalidationList [
	| amzDatePrintString request |
	amzDatePrintString := self amzDatePrintString.
	request := ZnRequest empty.
	request method: #GET.
	request url: self invalidationUri.
	request headers at: 'host' put: self awsConfig endpoint.
	request headers at: 'x-amz-date' put: amzDatePrintString.
	request
		setAuthorization: (SignatureV4 creatAuthorization: request andConfig: self awsConfig andDateTime: amzDatePrintString).
	^ self client request: request andOption: nil
]

{ #category : #constants }
CloudFront >> invalidationUri [
	^ self defaultUri, '/', self distributionId, '/invalidation'
]

{ #category : #actions }
CloudFront >> postInvalidation: aXMLStringOrCFInvalidationBatch [
	| amzDatePrintString request requestBody |
	requestBody  := aXMLStringOrCFInvalidationBatch.
	requestBody class = CFInvalidationBatch 
		ifTrue: [ requestBody := aXMLStringOrCFInvalidationBatch asXMLString ].
	amzDatePrintString := self amzDatePrintString.
	request := ZnRequest empty.
	request method: #POST.
	request url: self invalidationUri.
	request
		entity:
			(ZnEntity
				readBinaryFrom: requestBody asByteArray readStream
				usingType: ZnMimeType textXML
				andLength: requestBody byteSize).
	request headers at: 'host' put: self awsConfig endpoint.
	request headers at: 'x-amz-date' put: amzDatePrintString.
	request
		setAuthorization: (SignatureV4 creatAuthorization: request andConfig: self awsConfig andDateTime: amzDatePrintString).
	^ self client request: request andOption: nil
]
