Class {
	#name : #SNSPlatformApplication,
	#superclass : #Object,
	#instVars : [
		'arn'
	],
	#category : 'AWS-SNS'
}

{ #category : #accessing }
SNSPlatformApplication >> arn [
	^ arn
]

{ #category : #accessing }
SNSPlatformApplication >> arn: anObject [
	arn := anObject
]
