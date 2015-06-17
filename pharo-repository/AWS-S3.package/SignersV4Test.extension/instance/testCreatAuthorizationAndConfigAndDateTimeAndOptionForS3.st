*AWS-S3-Tests
testCreatAuthorizationAndConfigAndDateTimeAndOptionForS3

	|  request awsConfig  datetimeString result  |
	
	awsConfig := AWSS3Config new.
	awsConfig serviceName:'s3'.
	awsConfig regionName: 'us-east-1'.
	awsConfig accessKeyId: 'AKIAIOSFODNN7EXAMPLE'.
	awsConfig secretKey: 'wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY'.
	
	request := ZnRequest empty.
	request method: #GET.
	request url:'/test.txt'.
	request headers at:'host' put: 'examplebucket.', awsConfig endpoint.
	request headers at:'range' put: 'bytes=0-9'.
	request headers at:'x-amz-content-sha256' put: (SHA256 new hashMessage: '') hex.
	request headers at:'x-amz-date' put:'20130524T000000Z'.
	request headers removeKey:'User-Agent'.
	"request headers removeKey: 'Content-Length'."
	
	datetimeString := '20130524T000000Z'.
	
	result := SignersV4 new creatAuthorization: request andConfig: awsConfig andDateTime: datetimeString andOption: nil.
	
	self assert:(result = 'AWS4-HMAC-SHA256 Credential=AKIAIOSFODNN7EXAMPLE/20130524/us-east-1/s3/aws4_request, SignedHeaders=host;range;x-amz-content-sha256;x-amz-date, Signature=f0e8bdb87c964420e857bd35b5d6ed310bd44f0170aba48dd91039c6036bdb41')