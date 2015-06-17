tests-accessing
testHostUrl
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