low-level-api
operationName: operationName entityContents: requestBody
	| client  dt t   url datetimeString request |
	
	client := ZnClient new systemPolicy beOneShot.

	awsConfig useSSL 
		ifTrue:[ client https].
		
	dt :=DateAndTime now asUTC.
	t :=  (dt asTimeUTC print24 findTokens: '.')first copyReplaceAll:':' with:''.
	datetimeString := (dt asDate printFormat:#(3 2 1 0 1 1 2)),'T',t,'Z'.
	
	request := ZnRequest empty.
	request method: #POST.
	request url:'/'.
	request entity:(ZnEntity text:requestBody).
	request headers at:'Content-Length' put: requestBody byteSize asString.
	request headers contentType:'application/x-amz-json-1.0'. 
	request headers at:'host' put: awsConfig endpoint.
	"request header at:'x-amz-sha256' put: (SHA256 new hashMessage: requestBody) hex."
	request headers at:'x-amz-date' put: datetimeString.
	request headers at:'x-amz-target' put:  (awsConfig serviceName,'_', awsConfig api_version,'.', operationName).	
	request setAuthorization: ( SignersV4 creatAuthorization: request andConfig: awsConfig andDateTime: datetimeString andOption: nil ) .
	

	client request: request.	
	client contentWriter: [:o | (ZnEntity with: o) contentType: 'application/x-amz-json-1.0'].
	url := ZnUrl fromString: awsConfig endpoint defaultScheme: #https.  
	
	awsConfig useSSL 
		ifFalse:[ url scheme: #http ].
	[ client post: url contents: requestBody ] 
		on: NetworkError, ZnParseError, ZnCharacterEncodingError, ZnUnknownScheme, ZnPortNotANumber, Error 
		do:[:ex |  "self ng error: ex."  ex pass.  ].
	^ client response.
	