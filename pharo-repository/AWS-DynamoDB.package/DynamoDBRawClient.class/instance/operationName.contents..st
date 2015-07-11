low-level-api
operationName: operationName contents: requestBodyString
	| dt t datetimeString request |
	dt := DateAndTime now asUTC.
	t := ( dt asTimeUTC print24 findTokens: '.' ) first copyReplaceAll:':' with:''.
	datetimeString := ( dt asDate printFormat:#(3 2 1 0 1 1 2) ),'T',t,'Z'.
	
	request := ZnRequest empty.
	request method: #POST.
	request url:'/'.
	request entity:((ZnEntity with: requestBodyString) contentType: 'application/x-amz-json-1.0').
	request headers at:'Content-Length' put: requestBodyString byteSize asString.
	request headers contentType:'application/x-amz-json-1.0'. 
	request headers at:'host' put: awsConfig endpoint.
	request headers at:'x-amz-date' put: datetimeString.
	request headers at:'x-amz-target' put: ( awsConfig serviceName, '_', awsConfig apiVersion,'.', operationName ).	
	request setAuthorization: ( SignersV4 creatAuthorization: request andConfig: awsConfig andDateTime: datetimeString andOption: nil ).
	
	^ self request: request andOption: nil.
	