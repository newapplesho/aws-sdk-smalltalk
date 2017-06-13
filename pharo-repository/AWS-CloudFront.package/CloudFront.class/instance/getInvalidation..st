actions
getInvalidation: invalidationId
	| amzDatePrintString request |
	amzDatePrintString := self amzDatePrintString.
	request := ZnRequest empty.
	request method: #GET.
	request url: self invalidationUri, '/', invalidationId.
	request headers at: 'host' put: self awsConfig endpoint.
	request headers at: 'x-amz-date' put: amzDatePrintString.
	request
		setAuthorization: (SignatureV4 creatAuthorization: request andConfig: self awsConfig andDateTime: amzDatePrintString).
	^ self client request: request andOption: nil