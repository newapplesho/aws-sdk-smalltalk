tests-private
testCreateCredentialScopeValueAndDateTime

	| awsConfig datetimeString result |
	awsConfig := AWSConfig new.
	awsConfig serviceName:'iam'.
	awsConfig regionName: 'us-east-1'.
	awsConfig secretKey: 'wJalrXUtnFEMI/K7MDENG+bPxRfiCYEXAMPLEKEY'.
	
	datetimeString := '20110909T233600Z'.
	
	result := SignersV4 new createCredentialScopeValue: awsConfig andDateTime: datetimeString.
	
	self assert:(  result = '20110909/us-east-1/iam/aws4_request').