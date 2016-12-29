public
getSessionToken
	| amzDatePrintString request |
	amzDatePrintString := DateAndTime amzDatePrintString.
	request := ZnRequest empty.
	request method: #POST.
	request url: '/?Action=GetSessionToken&Version=2011-06-15'.
	request entity: (ZnEntity text: '').
	request headers at: 'host' put: self awsConfig endpoint.
	request headers at: 'x-amz-date' put: amzDatePrintString.
	request
		setAuthorization: (SignatureV4 creatAuthorization: request andConfig: self awsConfig andDateTime: amzDatePrintString).
	^ self client request: request andOption: nil