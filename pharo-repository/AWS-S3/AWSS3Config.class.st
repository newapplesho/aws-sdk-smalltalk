Class {
	#name : #AWSS3Config,
	#superclass : #AWSConfig,
	#classInstVars : [
		'default'
	],
	#category : #'AWS-S3'
}

{ #category : #'instance creation' }
AWSS3Config class >> default [
	default ifNil: [ default := self defaultS3Setting ].
	^default
]

{ #category : #'instance creation' }
AWSS3Config class >> defaultS3Setting [
	| aws |
	aws := self new.
	aws serviceName:'s3'.
	"AWS Regions Asia Pacific (Tokyo)"
	aws regionName: 'ap-northeast-1'.
	^ aws
]

{ #category : #'class initialization' }
AWSS3Config class >> initialize [
	default := nil.
]

{ #category : #defaults }
AWSS3Config >> defaultServiceName [
	^ 's3'
]

{ #category : #accessing }
AWSS3Config >> hostUrl [
	
	^ self at: #hostUrl ifAbsent: [
		
		(self regionName = 'us-east-1')
			ifTrue:[ 
				"If you create a client by specifying the US Standard region, it uses the following endpoint to communicate with Amazon S3."
				self hostUrl: self serviceName asLowercase, '.amazonaws.com'. ]
			ifFalse:[ 
				"If you create a client by specifying any other AWS region, each of these regions maps to the region-specific endpoint"
				self hostUrl: self serviceName asLowercase,'-', self regionName, '.amazonaws.com'.  ].	
	]
]
