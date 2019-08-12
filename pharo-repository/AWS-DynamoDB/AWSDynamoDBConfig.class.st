Class {
	#name : #AWSDynamoDBConfig,
	#superclass : #AWSConfig,
	#classInstVars : [
		'default'
	],
	#category : 'AWS-DynamoDB'
}

{ #category : #'instance creation' }
AWSDynamoDBConfig class >> default [
	default ifNil: [ default := self defaultDynamoDBSetting ].
	^default
]

{ #category : #'instance creation' }
AWSDynamoDBConfig class >> defaultDynamoDBSetting [
	| aws |
	aws := self new.
	aws serviceName:'DynamoDB'.
	"AWS Regions Asia Pacific (Tokyo)"
	aws regionName: 'ap-northeast-1'.
	aws apiVersion: '20120810'.
	^ aws
]

{ #category : #'instance creation' }
AWSDynamoDBConfig class >> developmentDynamoDBSetting [
	| config |
	self initialize.
	config :=  self default.
	"sample access key and secret key"
	config accessKeyId:'AKIDEXAMPLE'.
	config secretKey:'wJalrXUtnFEMI/K7MDENG+bPxRfiCYEXAMPLEKEY'. 
	"use DynamoDB Local"
	config useSSL: false.
	config endpoint: 'localhost:8000'.
]

{ #category : #'class initialization' }
AWSDynamoDBConfig class >> initialize [
	default := nil.
]

{ #category : #defaults }
AWSDynamoDBConfig >> defaultServiceName [
	^ 'DynamoDB'
]
