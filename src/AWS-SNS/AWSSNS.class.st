Class {
	#name : #AWSSNS,
	#superclass : #AWSService,
	#category : #'AWS-SNS'
}

{ #category : #public }
AWSSNS >> createPlatformEndpoint: token [
	| url request requestBody |
	url := '/' asZnUrl.
	url := url 
		? (#Action -> #CreatePlatformEndpoint)
		& (#PlatformApplicationArn -> 'arn:aws:sns:eu-west-1:670495117295:app/APNS_SANDBOX/flinkster.dev')
		& (#Token -> #deadbeef4f990dae2042a3e053f81c67aa01bcd63417de6d22c01706deadbeef).
	requestBody := '{}'.
request := self createRequest: requestBody url: url method: #POST .
	^ self client request: request andOption: nil.
]

{ #category : #public }
AWSSNS >> createPlatformEndpoint: token inApplication: application [
	| url request requestBody |
	url := '/' asZnUrl.
	url := url 
		? (#Action -> #CreatePlatformEndpoint)
		& (#PlatformApplicationArn -> application)
		& (#Token -> token).
	requestBody := '{}'.
request := self createRequest: requestBody url: url method: #POST .
	^ self client request: request andOption: nil.
]

{ #category : #private }
AWSSNS >> createRequest: aRequestBody url: url method: method [ 
		
	| datetimeString hostUrl request |
	datetimeString := DateAndTime amzDatePrintString.
	hostUrl := self awsConfig endpoint.
	
	request := ZnRequest empty.
	request method: method.
	request url: url.

	request entity:(ZnEntity with: aRequestBody type: (ZnMimeType textPlain)). 
	request headers at:'host' put: hostUrl.
	request headers at:'x-amz-content-sha256' put: (SHA256 new hashMessage: aRequestBody) hex.
	request headers at:'x-amz-date' put: datetimeString.
	request setAuthorization: ( SignatureV4 creatAuthorization: request andConfig: self awsConfig andDateTime: datetimeString andOption: nil ) .
	^ request
]

{ #category : #defaults }
AWSSNS >> defaultClientClass [
	^ SNSClient 
]

{ #category : #defaults }
AWSSNS >> defaultConfigClass [
	^ AWSSNSConfig
]

{ #category : #public }
AWSSNS >> getPlatformApplicationAttributes: aString [
	| url request requestBody |
	url := '/' asZnUrl.
	url := url 
		? (#Action -> #GetPlatformApplicationAttributes)
		& (#PlatformApplicationArn -> aString).
	requestBody := '{}'.
request := self createRequest: requestBody url: url method: #POST .
	^ self client request: request andOption: nil.
]

{ #category : #public }
AWSSNS >> listEndpointsByPlatformApplication: aString [
	| url request requestBody |
	url := '/' asZnUrl.
	url := url 
		? (#Action -> #ListEndpointsByPlatformApplication)
		& (#PlatformApplicationArn -> aString).
	requestBody := '{}'.
request := self createRequest: requestBody url: url method: #POST .
	^ self client request: request andOption: nil.
]

{ #category : #public }
AWSSNS >> listPlatformApplications [
	| url request requestBody |
	url := '/' asZnUrl.
	url := url 
		? (#Action -> #ListPlatformApplications).
	requestBody := '{}'.
request := self createRequest: requestBody url: url method: #POST .
	^ self client request: request andOption: nil.
]

{ #category : #'as yet unclassified' }
AWSSNS >> publishMessage: aString arn: arn [
	| url request requestBody |
	url := '/' asZnUrl.
	url := url 
		? (#Action -> #Publish)
		& (#TargetArn -> arn)
		& (#Message -> aString).
	requestBody := '{}'.
request := self createRequest: requestBody url: url method: #POST .
	^ self client request: request andOption: nil.
]

{ #category : #public }
AWSSNS >> setEndpointAttributes: token endpoint: anEndpoint [
	| url request requestBody |
	url := '/' asZnUrl.
	url := url 
		? (#Action -> #SetEndpointAttributes)
		& (#EndpointArn -> anEndpoint)
		& (#'Attributes.entry.1.key' -> #Token)
		& (#'Attributes.entry.1.value'-> token).
	requestBody := '{}'.
request := self createRequest: requestBody url: url method: #POST .
	^ self client request: request andOption: nil.
]
