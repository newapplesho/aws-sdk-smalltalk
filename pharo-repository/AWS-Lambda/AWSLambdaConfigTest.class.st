"
An AWSLambdaConfigTest is a test class for testing the behavior of AWSLambdaConfig
"
Class {
	#name : #AWSLambdaConfigTest,
	#superclass : #TestCase,
	#category : #'AWS-Lambda-Tests'
}

{ #category : #test }
AWSLambdaConfigTest >> testEndpoint [
	| awsConfig |
	awsConfig := AWSLambdaConfig new.
	awsConfig regionName: 'us-east-1'.
	self
		assert: awsConfig endpoint
		equals: 'lambda.us-east-1.amazonaws.com'.
	awsConfig regionName: 'ap-northeast-1'.
	self
		assert: awsConfig endpoint
		equals: 'lambda.ap-northeast-1.amazonaws.com'
]

{ #category : #test }
AWSLambdaConfigTest >> testHostUrl [
	| awsConfig |
	awsConfig := AWSLambdaConfig new.
	awsConfig regionName: 'us-east-1'.
	self
		assert: awsConfig hostUrl
		equals: 'lambda.us-east-1.amazonaws.com'.
	awsConfig regionName: 'ap-northeast-1'.
	self
		assert: awsConfig hostUrl
		equals: 'lambda.ap-northeast-1.amazonaws.com'
]
