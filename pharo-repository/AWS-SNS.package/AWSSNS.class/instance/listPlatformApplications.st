public
listPlatformApplications
	| url request requestBody |
	url := '/' asZnUrl.
	url := url 
		? (#Action -> #ListPlatformApplications).
	requestBody := '{}'.
request := self createRequest: requestBody url: url method: #POST .
	^ self client request: request andOption: nil.