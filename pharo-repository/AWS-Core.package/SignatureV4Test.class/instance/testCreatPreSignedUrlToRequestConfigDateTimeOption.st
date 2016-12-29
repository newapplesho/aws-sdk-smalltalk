tests-private
testCreatPreSignedUrlToRequestConfigDateTimeOption
	| request awsConfig datetimeString result |
	request := ZnRequest empty.
	request method: #GET.
	request url: '/'.
	request uri queryAt: 'Action' put: 'ListUsers'.
	request uri queryAt: 'Version' put: '2010-05-08'.
	request headers at: 'host' put: 'iam.amazonaws.com'.
	request headers at: 'content-type' put: 'application/x-www-form-urlencoded; charset=utf-8'.
	"request headers at: 'X-Amz-Date' put: '20150830T123600Z'."
	request headers removeKey: 'User-Agent'.
	request headers removeKey: 'Content-Length' ifAbsent: [ '' ].
	awsConfig := AWSIAMConfig new.
	awsConfig serviceName: 'iam'.
	awsConfig regionName: 'us-east-1'.
	awsConfig accessKeyId: 'AKIDEXAMPLE'.
	awsConfig secretKey: 'wJalrXUtnFEMI/K7MDENG+bPxRfiCYEXAMPLEKEY'.
	datetimeString := '20150830T123600Z'.
	result := SignatureV4 new
		creatPreSignedUrlToRequest: request
		config: awsConfig
		dateTime: datetimeString
		option:
			(Dictionary new
				at: #expire put: 60;
				yourself).
	self
		assert:
			result
				=
					'https://iam.amazonaws.com?Action=ListUsers&Version=2010-05-08&X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=AKIDEXAMPLE%2F20150830%2Fus-east-1%2Fiam%2Faws4_request&X-Amz-Date=20150830T123600Z&X-Amz-Expires=60&X-Amz-SignedHeaders=content-type%3Bhost&X-Amz-Signature=37ac2f4fde00b0ac9bd9eadeb459b1bbee224158d66e7ae5fcadb70b2d181d02'