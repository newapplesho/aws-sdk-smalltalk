tests-private
testCreatAuthorizationAndConfigAndDateTimeAndOption

	|  request awsConfig  datetimeString result  |
	request := ZnRequest empty.
	request method: #POST.
	request url:'/'.
	request entity:(ZnEntity text:'Action=ListUsers&Version=2010-05-08').
	request headers at:'host' put:'iam.amazonaws.com'.
	request headers at:'content-type' put:'application/x-www-form-urlencoded; charset=utf-8'.
	request headers at:'x-amz-date' put:'20110909T233600Z'.
	request headers removeKey:'User-Agent'.
	request headers removeKey: 'Content-Length'.
	
	awsConfig := AWSConfig new.
	awsConfig serviceName:'iam'.
	awsConfig regionName: 'us-east-1'.
	awsConfig accessKeyId: 'AKIDEXAMPLE'.
	awsConfig secretKey: 'wJalrXUtnFEMI/K7MDENG+bPxRfiCYEXAMPLEKEY'.
	
	datetimeString := '20110909T233600Z'.
	
	result := SignersV4 new creatAuthorization: request andConfig: awsConfig andDateTime: datetimeString andOption: nil.
	
	self assert:(result = 'AWS4-HMAC-SHA256 Credential=AKIDEXAMPLE/20110909/us-east-1/iam/aws4_request, SignedHeaders=content-type;host;x-amz-date, Signature=ced6826de92d2bdeed8f846f0bf508e8559e98e4b0199114b84c54174deb456c')