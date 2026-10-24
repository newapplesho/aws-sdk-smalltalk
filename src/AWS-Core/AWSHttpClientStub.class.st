"
I am a stub standing in for a ZnClient, used to test AWSClient>>request:andOption:
without a network. I implement the small slice of the ZnClient protocol that
method uses (https, request:, url:, execute, response): I record the request and
url handed to me and return a canned response object.
"
Class {
	#name : #AWSHttpClientStub,
	#superclass : #Object,
	#instVars : [
		'recordedRequest',
		'recordedUrl',
		'cannedResponse',
		'executed'
	],
	#category : #'AWS-Core-Tests'
}

{ #category : #accessing }
AWSHttpClientStub >> cannedResponse: anObject [
	cannedResponse := anObject
]

{ #category : #'zn-client-api' }
AWSHttpClientStub >> execute [
	executed := true
]

{ #category : #'zn-client-api' }
AWSHttpClientStub >> https [
	^ self
]

{ #category : #testing }
AWSHttpClientStub >> isExecuted [
	^ executed == true
]

{ #category : #accessing }
AWSHttpClientStub >> recordedRequest [
	^ recordedRequest
]

{ #category : #accessing }
AWSHttpClientStub >> recordedUrl [
	^ recordedUrl
]

{ #category : #'zn-client-api' }
AWSHttpClientStub >> request: aRequest [
	recordedRequest := aRequest
]

{ #category : #'zn-client-api' }
AWSHttpClientStub >> response [
	^ cannedResponse
]

{ #category : #'zn-client-api' }
AWSHttpClientStub >> url: aUrl [
	recordedUrl := aUrl
]
