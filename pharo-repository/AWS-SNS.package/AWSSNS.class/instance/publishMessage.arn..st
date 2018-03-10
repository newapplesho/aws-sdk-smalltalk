as yet unclassified
publishMessage: aString arn: arn
	| url request requestBody |
	url := '/' asZnUrl.
	url := url 
		? (#Action -> #Publish)
		& (#TargetArn -> arn)
		& (#Message -> aString).
	requestBody := '{}'.
request := self createRequest: requestBody url: url method: #POST .
	^ self client request: request andOption: nil.