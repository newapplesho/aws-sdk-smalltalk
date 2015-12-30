low-level-api
operationName: operationName contents: requestBodyString
	|   datetimeString request |
	datetimeString := DateAndTime amzDatePrintString.
	
	request := ZnRequest empty.
	request method: #POST.
	request url:'/'.
	request entity:((ZnEntity with: requestBodyString) contentType: 'application/x-amz-json-1.0').
	request headers at:'Content-Length' put: requestBodyString byteSize asString.
	request headers contentType:'application/x-amz-json-1.0'. 
	request headers at:'host' put: awsConfig endpoint.
	request headers at:'x-amz-date' put: datetimeString.
	request headers at:'x-amz-target' put: ( awsConfig serviceName, '_', awsConfig apiVersion,'.', operationName ).	
	request setAuthorization: ( SignatureV4 creatAuthorization: request andConfig: awsConfig andDateTime: datetimeString andOption: nil ).

	^ self request: request andOption: nil.
	