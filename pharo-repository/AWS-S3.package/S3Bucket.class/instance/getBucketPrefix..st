public
getBucketPrefix: aString
	| request requestBody |
	requestBody := ''.
	request := self service createRequest: requestBody url: '/?prefix=',aString method: #GET andBucketName: self bucketName.
	^ self client request: request andOption: nil.
	
	