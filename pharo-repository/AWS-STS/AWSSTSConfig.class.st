Class {
	#name : #AWSSTSConfig,
	#superclass : #AWSConfig,
	#classInstVars : [
		'default'
	],
	#category : 'AWS-STS'
}

{ #category : #'instance creation' }
AWSSTSConfig class >> default [
	default ifNil: [ default := self defaultSTSSetting ].
	^default
]

{ #category : #defaults }
AWSSTSConfig class >> defaultSTSSetting [
	| aws |
	aws := self new.
	aws serviceName:'sts'.
	"AWS Regions Asia Pacific (Tokyo)"
	aws regionName: 'ap-northeast-1'.
	aws apiVersion: '2011-06-15'.
	^ aws
]

{ #category : #'class initialization' }
AWSSTSConfig class >> initialize [
	default := nil
]

{ #category : #accessing }
AWSSTSConfig >> apiVersion [
	^ '2011-06-15'
]
