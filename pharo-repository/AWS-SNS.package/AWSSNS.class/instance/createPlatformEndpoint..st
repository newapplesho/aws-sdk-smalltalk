public
createPlatformEndpoint: token
	| url request requestBody |
	url := '/' asZnUrl.
	url := url 
		? (#Action -> #CreatePlatformEndpoint)
		& (#PlatformApplicationArn -> 'arn:aws:sns:eu-west-1:670495117295:app/APNS_SANDBOX/flinkster.dev')
		& (#Token -> #deadbeef4f990dae2042a3e053f81c67aa01bcd63417de6d22c01706deadbeef).
	requestBody := '{}'.
request := self createRequest: requestBody url: url method: #POST .
	^ self client request: request andOption: nil.