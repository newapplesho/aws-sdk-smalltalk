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
	responseJson := NeoJSONReader fromString: self response contents.
	self response isSuccess
		ifTrue:[ ^ responseJson ].

	exception := self defaultExceptionClass new.
	exception properties: responseJson.
	exception messageText: (responseJson at: 'message' ifAbsent: [ nil ]).
	exception signal.
]
