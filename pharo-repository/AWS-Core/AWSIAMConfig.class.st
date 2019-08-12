Class {
	#name : #AWSIAMConfig,
	#superclass : #AWSConfig,
	#category : 'AWS-Core'
}

{ #category : #defaults }
AWSIAMConfig >> defaultServiceName [
	^ 'iam'
]

{ #category : #accessing }
AWSIAMConfig >> hostUrl [
	^ self
		at: #hostUrl
		ifAbsent: [self hostUrl: self serviceName asLowercase , '.amazonaws.com' ]
]
