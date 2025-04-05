"
An AWSS3ConfigTest is a test class for testing the behavior of AWSS3Config
"
Class {
	#name : #AWSS3ConfigTest,
	#superclass : #TestCase,
	#category : #'AWS-S3-Tests'
}

{ #category : #'tests-accessing' }
AWSS3ConfigTest >> testHostUrl [
	| awsConfig |
	awsConfig := AWSS3Config new.
	awsConfig serviceName:'s3'.
	awsConfig regionName: 'us-east-1'.
	
	self assert:( awsConfig endpoint = 's3.amazonaws.com' ).
	
	awsConfig := AWSS3Config new.
	awsConfig serviceName:'s3'.
	awsConfig regionName: 'ap-northeast-1'.
	
	self assert:( awsConfig endpoint ~= 's3.amazonaws.com' ).
	
	awsConfig := AWSS3Config new.
	awsConfig serviceName:'s3'.
	awsConfig regionName: 'ap-northeast-1'.
	
	self assert:( awsConfig endpoint = 's3-ap-northeast-1.amazonaws.com' ).
]
