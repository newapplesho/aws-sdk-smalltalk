public
setEndpointAttributes: token endpoint: anEndpoint
	| url request requestBody |
	url := '/' asZnUrl.
	url := url 
		? (#Action -> #SetEndpointAttributes)
		& (#EndpointArn -> anEndpoint)
		& (#'Attributes.entry.1.key' -> #Token)
		& (#'Attributes.entry.1.value'-> token).
	requestBody := '{}'.
request := self createRequest: requestBody url: url method: #POST .
	^ self client request: request andOption: nil.