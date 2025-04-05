Class {
	#name : #AWSResponse,
	#superclass : #Object,
	#instVars : [
		'response'
	],
	#category : #'AWS-Core'
}

{ #category : #'instance creation' }
AWSResponse class >> on: znResponse [

	^ self new response: znResponse; yourself.
]

{ #category : #defaults }
AWSResponse >> defaultExceptionClass [
	^ AWSException 
]

{ #category : #accessing }
AWSResponse >> response [
	^ response
]

{ #category : #accessing }
AWSResponse >> response: anObject [
	response := anObject
]

{ #category : #accessing }
AWSResponse >> value [
	| responseJson exception |
	responseJson := Json readFrom: self response contents readStream.
	self response isSuccess 
		ifTrue:[ ^ responseJson ].
	
	exception := self defaultExceptionClass new.
	exception properties: responseJson.
	exception messageText: responseJson message.
	exception signal.
]
