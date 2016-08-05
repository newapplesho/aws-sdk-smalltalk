public
getBucket
	| request requestBody |
	requestBody := ''.
	request := self service createRequest: requestBody url: '/' method: #GET andBucketName: self bucketName.
	^ self client request: request andOption: nil.
	
	