public
getObject: aString
	| request requestBody |
	requestBody := ''.
	request := self service createRequest: requestBody url: '/',aString method: #GET andBucketName: self bucketName.
	^ self client request: request andOption: nil.
	