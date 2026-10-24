"
I test how AWSS3 builds and signs a request, and — through the shared
AWSService>>signRequest: helper it relies on — the SigV4 date, credential
scope and session-token handling common to every service.

Pure offline unit tests: I inject a fixed config and a pinned amz date-time,
build a request, and assert on the produced headers and Authorization value.
No network is used.
"
Class {
	#name : #AWSS3RequestTest,
	#superclass : #TestCase,
	#category : #'AWS-S3-Tests'
}

{ #category : #fixtures }
AWSS3RequestTest >> s3 [
	| service |
	service := AWSS3 new.
	service awsConfig: (AWSS3Config new
		accessKeyId: 'AKIDEXAMPLE';
		secretKey: 'wJalrXUtnFEMI/K7MDENG+bPxRfiCYEXAMPLEKEY';
		regionName: 'us-east-1';
		yourself).
	service amzDatePrintString: '20110909T233600Z'.
	^ service
]

{ #category : #'tests-signing' }
AWSS3RequestTest >> testCreateRequestSetsSignedDateAndAuthorization [
	| request auth |
	request := self s3 createRequest: 'hello' url: '/' method: #PUT.
	self assert: (request headers at: 'x-amz-date') equals: '20110909T233600Z'.
	auth := request headers at: 'Authorization'.
	self assert: (auth beginsWith:
		'AWS4-HMAC-SHA256 Credential=AKIDEXAMPLE/20110909/us-east-1/s3/aws4_request').
	self assert: (auth includesSubstring: ';host;').
]

{ #category : #'tests-signing' }
AWSS3RequestTest >> testCreateRequestSetsPayloadHash [
	| request |
	request := self s3 createRequest: 'hello' url: '/' method: #PUT.
	self
		assert: (request headers at: 'x-amz-content-sha256')
		equals: (SHA256 new hashMessage: 'hello') hex.
]

{ #category : #'tests-signing' }
AWSS3RequestTest >> testCreateRequestWithBucketNameSetsVirtualHostedHost [
	| request |
	request := self s3 createRequest: 'x' url: '/' method: #PUT andBucketName: 'my-bucket'.
	self assert: (request headers at: 'host') equals: 'my-bucket.s3.amazonaws.com'.
]

{ #category : #'tests-session-token' }
AWSS3RequestTest >> testNoSessionTokenOmitsSecurityTokenHeader [
	| request |
	request := self s3 createRequest: 'hello' url: '/' method: #PUT.
	self assert: (request headers at: 'X-Amz-Security-Token' ifAbsent: [ nil ]) isNil.
	self deny: ((request headers at: 'Authorization')
		includesSubstring: 'x-amz-security-token').
]

{ #category : #'tests-session-token' }
AWSS3RequestTest >> testSessionTokenAddsSignedSecurityTokenHeader [
	| service request |
	service := self s3.
	service awsConfig sessionToken: 'session-token-xyz'.
	request := service createRequest: 'hello' url: '/' method: #PUT.
	self assert: (request headers at: 'X-Amz-Security-Token') equals: 'session-token-xyz'.
	self assert: ((request headers at: 'Authorization')
		includesSubstring: 'x-amz-security-token').
]
