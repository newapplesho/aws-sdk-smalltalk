"
I test AWSClient, in particular that request:andOption: honours an injected
httpClient (an AWSHttpClientStub) instead of building a default one. Pure
offline unit tests: no network is used.
"
Class {
	#name : #AWSClientTest,
	#superclass : #TestCase,
	#category : #'AWS-Core-Tests'
}

{ #category : #fixtures }
AWSClientTest >> clientWithStub: aStub [
	| client |
	client := AWSClient awsConfig: (AWSConfig new useSSL: false; yourself).
	client httpClient: aStub.
	^ client
]

{ #category : #fixtures }
AWSClientTest >> getRequestToHost: aHost [
	| request |
	request := ZnRequest empty.
	request method: #GET.
	request url: '/'.
	request headers at: 'host' put: aHost.
	^ request
]

{ #category : #'tests-http-client' }
AWSClientTest >> testDefaultsToNilHttpClient [
	"With nothing injected, request:andOption: falls back to defaultHttpClient."
	| client |
	client := AWSClient new.
	self assert: client httpClient isNil.
	self assert: client defaultHttpClient class equals: ZnClient.
]

{ #category : #'tests-http-client' }
AWSClientTest >> testRequestReturnsInjectedClientResponse [
	| stub client response |
	stub := AWSHttpClientStub new cannedResponse: 'CANNED-RESPONSE'; yourself.
	client := self clientWithStub: stub.
	response := client request: (self getRequestToHost: 'example.com') andOption: nil.
	self assert: response equals: 'CANNED-RESPONSE'.
]

{ #category : #'tests-http-client' }
AWSClientTest >> testRequestUsesInjectedHttpClient [
	| stub client request |
	stub := AWSHttpClientStub new cannedResponse: 'ok'; yourself.
	client := self clientWithStub: stub.
	request := self getRequestToHost: 'example.com'.
	client request: request andOption: nil.
	self assert: stub recordedRequest == request.
	self assert: stub isExecuted.
	self assert: stub recordedUrl notNil.
]
