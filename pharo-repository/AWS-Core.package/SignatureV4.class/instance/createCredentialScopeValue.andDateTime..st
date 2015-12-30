private
createCredentialScopeValue: awsConfig andDateTime: datetimeString
	^ ( datetimeString first: 8 ),'/',awsConfig regionName,'/', awsConfig serviceName asLowercase, '/aws4_request'.