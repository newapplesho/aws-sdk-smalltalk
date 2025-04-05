Class {
	#name : #AWSCFConfig,
	#superclass : #AWSConfig,
	#classInstVars : [
		'default'
	],
	#category : #'AWS-CloudFront'
}

{ #category : #'instance creation' }
AWSCFConfig class >> default [
	default ifNil: [ default := self defaultCFSetting ].
	^default
]

{ #category : #defaults }
AWSCFConfig class >> defaultCFSetting [
	| aws |
	aws := self new.
	aws serviceName:'cloudfront'.
	aws regionName: 'us-east-1'.
	aws apiVersion: '2016-09-29'.
	^ aws
]

{ #category : #'class initialization' }
AWSCFConfig class >> initialize [
	default := nil
]

{ #category : #defaults }
AWSCFConfig >> defaultServiceName [
	^ 'CloudFront'
]

{ #category : #accessing }
AWSCFConfig >> hostUrl [
	"Amazon CloudFront distributions have a single endpoint: cloudfront.amazonaws.com and only supports HTTPS requests. http://docs.aws.amazon.com/general/latest/gr/rande.html#cf_region"
	^self at: #hostUrl ifAbsent: [ self hostUrl: self serviceName asLowercase, '.amazonaws.com'. ]
]
