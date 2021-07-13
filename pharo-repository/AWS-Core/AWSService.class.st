"
I represent an AWS service such as S3 or the ElasticTranscoder service.
"
Class {
	#name : #AWSService,
	#superclass : #Object,
	#instVars : [
		'client',
		'profile'
	],
	#category : #'AWS-Core'
}

{ #category : #'instance creation' }
AWSService class >> profile: aProfileName [
	^(self new) profile: aProfileName; yourself
]

{ #category : #accessing }
AWSService >> amzDatePrintString [
	^ DateAndTime amzDatePrintString
	
]

{ #category : #accessing }
AWSService >> awsConfig [
	^ profile 
		ifNil: [ self defaultConfigClass default ] 
		ifNotNil: [ self defaultConfigClass profile: profile ]

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
	profile := aProfileName
]

{ #category : #private }
AWSService >> readJsonFromResponse: response [

	^ (self defaultResponseClass on: response) value.
]
