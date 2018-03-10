public
createPlatformEndpoint: token inApplication: application
	| url request requestBody |
	url := '/' asZnUrl.
	url := url 
		? (#Action -> #CreatePlatformEndpoint)
		& (#PlatformApplicationArn -> application)
		& (#Token -> token).
	requestBody := '{}'.
request := self createRequest: requestBody url: url method: #POST .
	^ self client request: request andOption: nil.