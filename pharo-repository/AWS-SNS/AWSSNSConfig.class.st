Class {
	#name : #AWSSNSConfig,
	#superclass : #AWSConfig,
	#classInstVars : [
		'default'
	],
	#category : 'AWS-SNS'
}

{ #category : #'instance creation' }
AWSSNSConfig class >> default [
	default ifNil: [ default := self defaultSNSSetting ].
	^default
]

{ #category : #'instance creation' }
AWSSNSConfig class >> defaultSNSSetting [
	| aws |
	aws := self new.
	aws serviceName:'sns'.
	aws regionName: 'eu-west-1'.
	^ aws
]

{ #category : #'class initialization' }
AWSSNSConfig class >> initialize [
	default := nil.
]

{ #category : #defaults }
AWSSNSConfig >> defaultServiceName [
	^ 'sns'
]

{ #category : #accessing }
AWSSNSConfig >> hostUrl [
	
	^ 'sns.eu-west-1.amazonaws.com'
]
