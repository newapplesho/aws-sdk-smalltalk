Class {
	#name : #STSClient,
	#superclass : #AWSClient,
	#category : #'AWS-STS'
}

{ #category : #defaults }
STSClient >> defaultResponseClass [
	^ STSResponse
]

{ #category : #'low-level-api' }
STSClient >> request: request andOption: anObject [
	^ self readFromResponse: (super request: request andOption: anObject)
]
