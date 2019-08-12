Class {
	#name : #AWSException,
	#superclass : #Error,
	#instVars : [
		'properties'
	],
	#category : 'AWS-Core'
}

{ #category : #accessing }
AWSException >> message [
	^ self properties message
]

{ #category : #accessing }
AWSException >> properties [
	^ properties
]

{ #category : #accessing }
AWSException >> properties: anObject [
	properties := anObject
]
