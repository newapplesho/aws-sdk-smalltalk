Class {
	#name : #AETConfig,
	#superclass : #AWSConfig,
	#classInstVars : [
		'default'
	],
	#category : #'AWS-ElasticTranscoder'
}

{ #category : #defaults }
AETConfig class >> default [
	default ifNil: [ default := self new ].
	^default
]

{ #category : #initialize }
AETConfig class >> initialize [
	default := nil.
]

{ #category : #defaults }
AETConfig >> defaultServiceName [
	^ 'elastictranscoder'
]
