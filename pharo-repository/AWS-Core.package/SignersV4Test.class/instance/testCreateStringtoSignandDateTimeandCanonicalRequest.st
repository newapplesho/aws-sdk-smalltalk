tests-private
testCreateStringtoSignandDateTimeandCanonicalRequest

	|  request awsConfig canonicalRequestString result answer |
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
	
	canonicalRequestString := SignersV4 new createCanonicalRequest:  request  andOption: nil. 
	
	result := SignersV4 new createStringtoSign: awsConfig andDateTime: '20110909T233600Z'  andCanonicalRequest: canonicalRequestString.
	
	answer := 'AWS4-HMAC-SHA256', String lf,
	'20110909T233600Z',String lf,
	'20110909/us-east-1/iam/aws4_request',String lf,
	'3511de7e95d28ecd39e9513b642aee07e54f4941150d8df8bf94b328ef7e55e2'.
	
	self assert:(result = answer)