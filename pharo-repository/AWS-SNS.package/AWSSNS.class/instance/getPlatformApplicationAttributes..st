public
getPlatformApplicationAttributes: aString
	| url request requestBody |
	url := '/' asZnUrl.
	url := url 
		? (#Action -> #GetPlatformApplicationAttributes)
		& (#PlatformApplicationArn -> aString).
	requestBody := '{}'.
request := self createRequest: requestBody url: url method: #POST .
	^ self client request: request andOption: nil.