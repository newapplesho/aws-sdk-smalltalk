Class {
	#name : #AWSClient,
	#superclass : #Object,
	#instVars : [
		'awsConfig',
		'httpClient'
	],
	#category : 'AWS-Core'
}

{ #category : #'instance creation' }
AWSClient class >> awsConfig: awsConfig [
	^ self new awsConfig: awsConfig
]

{ #category : #accessing }
AWSClient >> awsConfig [
	
	^ awsConfig ifNil:[ awsConfig := self defaultConfigClass default. ]
]

{ #category : #accessing }
AWSClient >> awsConfig: anObject [
	
	awsConfig := anObject
]

{ #category : #convencience }
AWSClient >> dateTimeString [	
	| dt t  |
	dt :=DateAndTime now asUTC.
	t :=  (dt asTimeUTC print24 findTokens: '.')first copyReplaceAll:':' with:''.
	^ (dt asDate printFormat:#(3 2 1 0 1 1 2)),'T',t,'Z'.
]

{ #category : #defaults }
AWSClient >> defaultConfigClass [
	^ AWSConfig
]

{ #category : #defaults }
AWSClient >> defaultHttpClient [
	^ZnClient new
]

{ #category : #accessing }
AWSClient >> httpClient [
	
	^ httpClient
]

{ #category : #accessing }
AWSClient >> httpClient: anObject [
	
	httpClient := anObject
]

{ #category : #private }
AWSClient >> readFromResponse: response [

	^ (self defaultResponseClass on: response) value.
]

{ #category : #'low-level-api' }
AWSClient >> request: request andOption: anObject [
	| client url hostUrl keyUrl |
	client := self defaultHttpClient.
	awsConfig useSSL
		ifTrue: [ client https ].
	client request: request.
	hostUrl := request headers at: 'host' ifAbsent: [ '' ].
	keyUrl := request url asString.
	url := ZnUrl fromString: hostUrl , keyUrl defaultScheme: #https.
	awsConfig useSSL
		ifFalse: [ url scheme: #http ].
	client url: url.
	client execute.
	^ client response
]
