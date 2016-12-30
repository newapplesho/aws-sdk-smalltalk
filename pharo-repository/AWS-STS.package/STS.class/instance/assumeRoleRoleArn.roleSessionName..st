public
assumeRoleRoleArn: aRoleArnString roleSessionName: roleSessionName
	| amzDatePrintString urlFormat url request |
	amzDatePrintString := DateAndTime amzDatePrintString.
	urlFormat := '/?Action=AssumeRole&Version={Version}&RoleArn={RoleArn}&RoleSessionName={RoleSessionName}'.
	url := urlFormat format: (Dictionary with: 'Version'-> self awsConfig apiVersion with: 'RoleArn'-> aRoleArnString with:  'RoleSessionName'-> roleSessionName).
	
	request := ZnRequest empty.
	request method: #POST.
	request url: url.
	request entity: (ZnEntity text: '').
	request headers at: 'host' put: self awsConfig endpoint.
	request headers at: 'x-amz-date' put: amzDatePrintString.
	request
		setAuthorization:
			(SignatureV4
				creatAuthorization: request
				andConfig: self awsConfig
				andDateTime: amzDatePrintString).
	^ self client request: request andOption: nil