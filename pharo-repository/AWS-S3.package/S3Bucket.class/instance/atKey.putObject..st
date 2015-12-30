public
atKey: key putObject: anObject
	| requestBody request |
	requestBody := anObject.
	request := self service createRequest: requestBody url: '/', key method: #PUT andBucketName: self bucketName.
	^ self client request: request andOption: nil.
