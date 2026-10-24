"
I represent an AWS service such as S3 or Lambda.
"
Class {
	#name : #AWSService,
	#superclass : #Object,
	#instVars : [
		'client',
		'profile',
		'dateTimeOverride',
		'awsConfig'
	],
	#category : #'AWS-Core'
}

{ #category : #'instance creation' }
AWSService class >> profile: aProfileName [
	^(self new) profile: aProfileName; yourself
]

{ #category : #accessing }
AWSService >> amzDatePrintString [
	"Return the amz date-time used for signing. Tests can pin it via
	 amzDatePrintString: to make signatures deterministic offline."
	^ dateTimeOverride ifNil: [ DateAndTime amzDatePrintString ]
]

{ #category : #accessing }
AWSService >> amzDatePrintString: aString [
	dateTimeOverride := aString
]

{ #category : #accessing }
AWSService >> awsConfig [
	"An injected or profile-resolved config is cached, so it is a stable object
	 across calls (mutating it — e.g. sessionToken: — sticks). With no profile
	 the shared default singleton is returned each time."
	awsConfig ifNotNil: [ ^ awsConfig ].
	profile ifNotNil: [ ^ awsConfig := self defaultConfigClass profile: profile ].
	^ self defaultConfigClass default
]

{ #category : #accessing }
AWSService >> awsConfig: aConfig [
	"Use aConfig from now on. The cached client captured the previous config,
	 so drop it; the next request builds a fresh one."
	awsConfig := aConfig.
	client := nil
]

{ #category : #accessing }
AWSService >> client [
	^ client ifNil:[ client := self defaultClient ]
]

{ #category : #private }
AWSService >> createRequest: aRequestBody url: url method: method [
	self subclassResponsibility 
]

{ #category : #defaults }
AWSService >> defaultClient [
	^ self defaultClientClass awsConfig: self awsConfig
]

{ #category : #defaults }
AWSService >> defaultClientClass [
	^ AWSClient
]

{ #category : #defaults }
AWSService >> defaultConfigClass [
	^ AWSConfig 
]

{ #category : #defaults }
AWSService >> defaultResponseClass [
	^ AWSResponse 
]

{ #category : #accessing }
AWSService >> profile: aProfileName [
	"Switch to aProfileName. Drop the config and client cached for the previous
	 profile (or injected via awsConfig:) so the next request re-resolves them."
	profile := aProfileName.
	awsConfig := nil.
	client := nil
]

{ #category : #signing }
AWSService >> signRequest: request [
	"Apply the SigV4 signature to a request whose service-specific headers
	 (host, content-type, x-amz-content-sha256, x-amz-target, ...) are already
	 set. Sets x-amz-date and, when the config carries a session token,
	 X-Amz-Security-Token, then computes the Authorization header. Both are
	 signed, so they must be set before the signature is computed."
	| datetimeString config |
	config := self awsConfig.
	datetimeString := self amzDatePrintString.
	request headers at: 'x-amz-date' put: datetimeString.
	config sessionToken ifNotNil: [ :token |
		request headers at: 'X-Amz-Security-Token' put: token ].
	request setAuthorization: (SignatureV4
		creatAuthorization: request
		andConfig: config
		andDateTime: datetimeString
		andOption: nil).
	^ request
]
