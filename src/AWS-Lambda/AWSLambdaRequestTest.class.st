"
I test that AWSLambda keeps its invocation-control headers and now carries a
session token through the shared AWSService>>signRequest: helper (previously it
set X-Amz-Security-Token itself). Pure offline unit test: no network is used.
"
Class {
	#name : #AWSLambdaRequestTest,
	#superclass : #TestCase,
	#category : #'AWS-Lambda-Tests'
}

{ #category : #fixtures }
AWSLambdaRequestTest >> lambdaWithToken [
	| service |
	service := AWSLambda new.
	service awsConfig: (AWSLambdaConfig new
		accessKeyId: 'AKIDEXAMPLE';
		secretKey: 'wJalrXUtnFEMI/K7MDENG+bPxRfiCYEXAMPLEKEY';
		regionName: 'us-east-1';
		sessionToken: 'session-token-xyz';
		yourself).
	service amzDatePrintString: '20110909T233600Z'.
	^ service
]

{ #category : #'tests-session-token' }
AWSLambdaRequestTest >> testCarriesInvocationHeadersAndSessionToken [
	| request |
	request := self lambdaWithToken createRequest: '{}' url: '/f' method: #POST.
	self assert: (request headers at: 'X-Amz-Invocation-Type') equals: 'RequestResponse'.
	self assert: (request headers at: 'LogType') equals: 'None'.
	self assert: (request headers at: 'X-Amz-Security-Token') equals: 'session-token-xyz'.
	self assert: ((request headers at: 'Authorization')
		includesSubstring: 'x-amz-security-token').
]
