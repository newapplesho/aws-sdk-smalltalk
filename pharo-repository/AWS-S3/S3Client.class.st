Class {
	#name : #S3Client,
	#superclass : #AWSClient,
	#category : 'AWS-S3'
}

{ #category : #defaults }
S3Client >> defaultResponseClass [
	^ S3Response 
]

{ #category : #'low-level-api' }
S3Client >> request: request andOption: anObject [
	^ self readFromResponse: (super request: request andOption: anObject).
]
