Class {
	#name : #AWSLambdaConfig,
	#superclass : #AWSConfig,
	#classInstVars : [
		'default'
	],
	#category : #'AWS-Lambda'
}

{ #category : #'instance creation' }
AWSLambdaConfig class >> default [
	default ifNil: [ default := self new ].
	^default
]

{ #category : #'class initialization' }
AWSLambdaConfig class >> initialize [
	default := nil.
]

{ #category : #defaults }
AWSLambdaConfig >> defaultServiceName [
	^ 'lambda'
]

{ #category : #accessing }
AWSLambdaConfig >> hostUrl [
	^ self
		at: #hostUrl
		ifAbsent: [ self
				hostUrl:
					self serviceName asLowercase , '.' , self regionName
						, '.amazonaws.com' ]
]
