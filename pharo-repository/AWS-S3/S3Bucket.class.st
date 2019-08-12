Class {
	#name : #S3Bucket,
	#superclass : #Object,
	#instVars : [
		'bucketName',
		'service'
	],
	#category : 'AWS-S3'
}

{ #category : #'instance creation' }
S3Bucket class >> named: bucketName [
	^ self new
		bucketName: bucketName;
		yourself
]

{ #category : #public }
S3Bucket >> atKey: key putObject: anObject [
	| requestBody request |
	requestBody := anObject.
	request := self service createRequest: requestBody url: '/', key method: #PUT andBucketName: self bucketName.
	^ self client request: request andOption: nil.

]

{ #category : #accessing }
S3Bucket >> bucketName [
	
	^ bucketName
]

{ #category : #accessing }
S3Bucket >> bucketName: anObject [
	
	bucketName := anObject
]

{ #category : #accessing }
S3Bucket >> client [
	^ self service client
]

{ #category : #public }
S3Bucket >> deleteObject: key [
	| request requestBody |
	requestBody := ''.
	request := self service createRequest: requestBody url: '/', key method: #DELETE andBucketName: self bucketName.
	^ self client request: request  andOption: nil.
	
]

{ #category : #public }
S3Bucket >> getBucket [
	| request requestBody |
	requestBody := ''.
	request := self service createRequest: requestBody url: '/' method: #GET andBucketName: self bucketName.
	^ self client request: request andOption: nil.
	
	
]

{ #category : #public }
S3Bucket >> getBucketPrefix: aString [
	| request requestBody |
	requestBody := ''.
	request := self service createRequest: requestBody url: '/?prefix=',aString method: #GET andBucketName: self bucketName.
	^ self client request: request andOption: nil.
	
	
]

{ #category : #public }
S3Bucket >> getObject: aString [
	| request requestBody |
	requestBody := ''.
	request := self service createRequest: requestBody url: '/',aString method: #GET andBucketName: self bucketName.
	^ self client request: request andOption: nil.
	
]

{ #category : #'public-listing' }
S3Bucket >> listObjectPrefix: aString [
	^ self getBucketPrefix: aString
	
]

{ #category : #'public-listing' }
S3Bucket >> listObjects [
	^ self getBucket
	
]

{ #category : #'public-listing' }
S3Bucket >> listObjectsPrefix: aString [
	^ self getBucketPrefix: aString
	
]

{ #category : #accessing }
S3Bucket >> service [
	^ service ifNil:[ service := AWSS3 new].
]

{ #category : #accessing }
S3Bucket >> service: anObject [
	^ service := anObject
]
