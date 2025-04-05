Class {
	#name : #SNSClient,
	#superclass : #AWSClient,
	#category : #'AWS-SNS'
}

{ #category : #defaults }
SNSClient >> defaultResponseClass [
	^ SNSResponse 
]

{ #category : #'low-level-api' }
SNSClient >> request: request andOption: anObject [
	^ self readFromResponse: (super request: request andOption: anObject).
]
