Class {
	#name : #AWSService,
	#superclass : #Object,
	#instVars : [
		'client'
	],
	#category : 'AWS-Core'
}

{ #category : #accessing }
AWSService >> amzDatePrintString [
	^ DateAndTime amzDatePrintString
	
]

{ #category : #accessing }
AWSService >> awsConfig [
	^ self defaultConfigClass default
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

{ #category : #private }
AWSService >> readJsonFromResponse: response [

	^ (self defaultResponseClass on: response) value.
]
