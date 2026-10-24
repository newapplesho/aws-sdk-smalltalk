Class {
	#name : #CloudFront,
	#superclass : #AWSService,
	#instVars : [
		'distributionId'
	],
	#category : #'AWS-CloudFront'
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
	| request |
	request := ZnRequest empty.
	request method: #GET.
	request url: self invalidationUri, '/', invalidationId.
	request headers at: 'host' put: self awsConfig endpoint.
	^ self client request: (self signRequest: request) andOption: nil
]

{ #category : #actions }
CloudFront >> getInvalidationList [
	| request |
	request := ZnRequest empty.
	request method: #GET.
	request url: self invalidationUri.
	request headers at: 'host' put: self awsConfig endpoint.
	^ self client request: (self signRequest: request) andOption: nil
]

{ #category : #constants }
CloudFront >> invalidationUri [
	^ self defaultUri, '/', self distributionId, '/invalidation'
]

{ #category : #actions }
CloudFront >> postInvalidation: aXMLStringOrCFInvalidationBatch [
	| request requestBody |
	requestBody  := aXMLStringOrCFInvalidationBatch.
	requestBody class = CFInvalidationBatch
		ifTrue: [ requestBody := aXMLStringOrCFInvalidationBatch asXMLString ].
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
	^ self client request: (self signRequest: request) andOption: nil
]
