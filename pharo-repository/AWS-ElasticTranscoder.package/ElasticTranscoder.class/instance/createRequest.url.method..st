private
createRequest: aRequestBody url: url method: method

	| amzDatePrintString request  requestBodyString |
	amzDatePrintString := DateAndTime amzDatePrintString.
	
	request := ZnRequest empty.
	request method: method.
	request url: url.

	aRequestBody ifNotNil:[ 
		requestBodyString := aRequestBody asJsonString.
		request entity:((ZnEntity with: requestBodyString) contentType: 'application/x-amz-json-1.0'). ].
	
	request headers contentType:'application/x-amz-json-1.0'. 
	request headers at:'host' put: self awsConfig endpoint.
	request headers at:'x-amz-date' put: amzDatePrintString.
	request setAuthorization: ( SignatureV4 creatAuthorization: request andConfig: self awsConfig andDateTime: amzDatePrintString ).
	^ request