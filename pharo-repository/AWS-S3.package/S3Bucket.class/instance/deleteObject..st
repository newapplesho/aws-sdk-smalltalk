public
deleteObject: key
	| request requestBody |
	requestBody := ''.
	request := self service createRequest: requestBody url: '/', key method: #DELETE andBucketName: self bucketName.
	^ self client request: request  andOption: nil.
	