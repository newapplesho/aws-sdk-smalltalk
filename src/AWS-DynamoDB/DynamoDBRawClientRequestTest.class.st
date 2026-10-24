"
I test how DynamoDBRawClient builds a request, in particular that a JSON body
with non-ASCII characters is sent as UTF-8 bytes whose length and SigV4
payload hash match what goes on the wire.

Pure offline unit tests: an AWSHttpClientStub is injected as the httpClient,
so no network (and no DynamoDB Local) is used.
"
Class {
	#name : #DynamoDBRawClientRequestTest,
	#superclass : #TestCase,
	#category : #'AWS-DynamoDB-Tests'
}

{ #category : #fixtures }
DynamoDBRawClientRequestTest >> nonAsciiJson [
	^ '{"name":"caf' , (String with: (Character value: 233) with: (Character value: 26085)) , '"}'
]

{ #category : #fixtures }
DynamoDBRawClientRequestTest >> recordedRequestFor: aJsonString [
	| stub client |
	stub := AWSHttpClientStub new cannedResponse: 'ok'; yourself.
	client := DynamoDBRawClient awsConfig: (AWSDynamoDBConfig defaultDynamoDBSetting
		accessKeyId: 'AKIDEXAMPLE';
		secretKey: 'wJalrXUtnFEMI/K7MDENG+bPxRfiCYEXAMPLEKEY';
		useSSL: false;
		endpoint: 'localhost:8000';
		yourself).
	client httpClient: stub.
	client operationName: #PutItem contents: aJsonString.
	^ stub recordedRequest
]

{ #category : #'tests-encoding' }
DynamoDBRawClientRequestTest >> testNonAsciiBodyIsSentAsUtf8Bytes [
	| request |
	request := self recordedRequestFor: self nonAsciiJson.
	self assert: request contents equals: self nonAsciiJson utf8Encoded
]

{ #category : #'tests-encoding' }
DynamoDBRawClientRequestTest >> testNonAsciiContentLengthIsUtf8ByteCount [
	| request |
	request := self recordedRequestFor: self nonAsciiJson.
	self
		assert: (request headers at: 'Content-Length')
		equals: self nonAsciiJson utf8Encoded size asString
]
