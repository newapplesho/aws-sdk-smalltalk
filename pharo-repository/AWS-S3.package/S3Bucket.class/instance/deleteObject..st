public
deleteObject: key
	| s3  datetimeString hostUrl request  requestBody |
	
	requestBody := ''.
	
	s3 := S3Client new.
	
	datetimeString := self datetimeString.
	
	hostUrl := self bucketName , '.', s3 awsConfig endpoint.
	
	request := ZnRequest empty.
	request method: #DELETE.
	request url: '/', key.
	request headers at:'Content-Length' put: requestBody byteSize asString.
	request headers at:'host' put: hostUrl.
	request headers at:'x-amz-content-sha256' put: (SHA256 new hashMessage: requestBody) hex.
	request headers at:'x-amz-date' put: datetimeString.
	request setAuthorization: ( SignersV4 creatAuthorization: request andConfig: s3 awsConfig andDateTime: datetimeString andOption: nil ) .
	
	^ s3 request: request  andOption: nil.
	