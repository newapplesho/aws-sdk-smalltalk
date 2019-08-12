Class {
	#name : #SignatureV4Test,
	#superclass : #TestCase,
	#category : 'AWS-Core-Tests'
}

{ #category : #'tests-private' }
SignatureV4Test >> canonicalHeadersString [
	^ ('content-length:2', String lf,
				'content-type:application/x-amz-json-1.0', String lf,
				'host:dynamodb.ap-northeast-1.amazonaws.com', String lf,
				'user-agent:Zinc HTTP Components 1.0 ({1})', String lf,
				'x-amz-date:20141215T104253Z', String lf,
				'x-amz-target:application/x-amz-json-1.0', String lf) format: { self systemVersion }.
]

{ #category : #running }
SignatureV4Test >> setUp [

]

{ #category : #'tests-private' }
SignatureV4Test >> systemVersion [
	^ SystemVersion current type , '/' , SystemVersion current dottedMajorMinor 
]

{ #category : #running }
SignatureV4Test >> tearDown [
]

{ #category : #'tests-private' }
SignatureV4Test >> testCreatAuthorizationAndConfigAndDateTimeAndOption [

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
	
	result := SignatureV4 new creatAuthorization: request andConfig: awsConfig andDateTime: datetimeString andOption: nil.
	
	self assert:(result = 'AWS4-HMAC-SHA256 Credential=AKIDEXAMPLE/20110909/us-east-1/iam/aws4_request, SignedHeaders=content-type;host;x-amz-date, Signature=ced6826de92d2bdeed8f846f0bf508e8559e98e4b0199114b84c54174deb456c')
]

{ #category : #'tests-private' }
SignatureV4Test >> testCreatCanonicalHeaders [
	|  request |
	
	request := ZnRequest empty.
	request headers at:'host' put:'iam.amazonaws.com'.
	request headers at:'content-type' put:'application/x-www-form-urlencoded; charset=utf-8'.
	request headers at:'My-header1' put:'    a   b   c '.
	request headers at:'x-amz-date' put:'20120228T024136Z'.
	request headers at:'My-Header2' put:'    "a b c"'.
	request headers removeKey:'User-Agent'.
	
	self assert:( (SignatureV4 new creatCanonicalHeaders: request) = ('content-type:application/x-www-form-urlencoded; charset=utf-8', String lf,
'host:iam.amazonaws.com', String lf,
'my-header1:a b c', String lf,
'my-header2:"a b c"', String lf,
'x-amz-date:20120228T024136Z', String lf) ).

	request := ZnRequest empty.
	request entity:(ZnEntity text:'{}').
	request headers contentType:'application/x-amz-json-1.0'. 
	request headers at:'host' put:'dynamodb.ap-northeast-1.amazonaws.com'.
	request headers at:'x-amz-date' put: '20141215T104253Z'.
	request headers at:'x-amz-target' put:'application/x-amz-json-1.0'.
	
	Smalltalk version >= 'Pharo6.0'
		ifTrue:[
			self assert:(SignatureV4 new creatCanonicalHeaders: request ) = self canonicalHeadersString .]
		ifFalse:[
			self assert:( (SignatureV4 new creatCanonicalHeaders: request) = ('content-length:2', String lf,
				'content-type:application/x-amz-json-1.0', String lf,
				'host:dynamodb.ap-northeast-1.amazonaws.com', String lf,
				'user-agent:Zinc HTTP Components 1.0', String lf,
				'x-amz-date:20141215T104253Z', String lf,
				'x-amz-target:application/x-amz-json-1.0', String lf )). ].
]

{ #category : #'tests-private' }
SignatureV4Test >> testCreatPreSignedUrlToRequestConfigDateTimeOption [
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
]

{ #category : #'tests-private' }
SignatureV4Test >> testCreateCanonicalRequestAndOption [
	| request |
	request := ZnRequest empty.
	request method: #POST.
	request url:'/'.
	request entity:(ZnEntity text:'Action=ListUsers&Version=2010-05-08').
	request headers at:'host' put:'iam.amazonaws.com'.
	request headers at:'content-type' put:'application/x-www-form-urlencoded; charset=utf-8'.
	request headers at:'x-amz-date' put:'20110909T233600Z'.
	request headers removeKey:'User-Agent'.
	request headers removeKey: 'Content-Length'.
	
	self assert:( (SignatureV4 new createCanonicalRequest: request andOption: nil ) = ('POST', String lf,
'/', String lf,String lf,
'content-type:application/x-www-form-urlencoded; charset=utf-8', String lf,
'host:iam.amazonaws.com', String lf,
'x-amz-date:20110909T233600Z', String lf, String lf,
'content-type;host;x-amz-date', String lf,
'b6359072c78d70ebee1e81adcbab4f01bf2c23245fa365ef83fe8f1f955085e2' ) ).
]

{ #category : #'tests-private' }
SignatureV4Test >> testCreateCredentialScopeValueAndDateTime [

	| awsConfig datetimeString result |
	awsConfig := AWSConfig new.
	awsConfig serviceName:'iam'.
	awsConfig regionName: 'us-east-1'.
	awsConfig secretKey: 'wJalrXUtnFEMI/K7MDENG+bPxRfiCYEXAMPLEKEY'.
	
	datetimeString := '20110909T233600Z'.
	
	result := SignatureV4 new createCredentialScopeValue: awsConfig andDateTime: datetimeString.
	
	self assert:(  result = '20110909/us-east-1/iam/aws4_request').
]

{ #category : #'tests-private' }
SignatureV4Test >> testCreateDerivedSigningKeyAndDateTime [
	| awsConfig datetimeString result |
	awsConfig := AWSConfig new.
	awsConfig serviceName:'iam'.
	awsConfig regionName: 'us-east-1'.
	awsConfig secretKey: 'wJalrXUtnFEMI/K7MDENG+bPxRfiCYEXAMPLEKEY'.
	
	datetimeString := '20110909T233600Z'.
	
	result := SignatureV4 new createDerivedSigningKey: awsConfig andDateTime: datetimeString.
	
	self assertCollection: result equals: #(152 241 216 137 254 196 244 66 26 220 82 43 171 12 225 248 46 105 41 194 98 237 21 229 169 76 144 239 209 227 176 231) asByteArray.
]

{ #category : #'tests-private' }
SignatureV4Test >> testCreateSignAndConfigAndDateTimeAndOption [

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
	awsConfig secretKey: 'wJalrXUtnFEMI/K7MDENG+bPxRfiCYEXAMPLEKEY'.
	
	datetimeString := '20110909T233600Z'.
	
	result := SignatureV4 new createSign:  request andConfig: awsConfig andDateTime: datetimeString andOption: nil.
	
	self assert:(result = 'ced6826de92d2bdeed8f846f0bf508e8559e98e4b0199114b84c54174deb456c')
]

{ #category : #'tests-private' }
SignatureV4Test >> testCreateSignHeaders [
	|  request |
	
	request := ZnRequest empty.
	request headers at:'host' put:'iam.amazonaws.com'.
	request headers at:'content-type' put:'application/x-www-form-urlencoded; charset=utf-8'.
	request headers at:'x-amz-date' put:'20110909T233600Z'.
	request headers removeKey:'User-Agent'.
	
	self assert:( (SignatureV4 new createSignHeaders: request) = 'content-type;host;x-amz-date' ).
]

{ #category : #'tests-private' }
SignatureV4Test >> testCreateStringtoSignandDateTimeandCanonicalRequest [

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
	
	canonicalRequestString := SignatureV4 new createCanonicalRequest:  request  andOption: nil. 
	
	result := SignatureV4 new createStringtoSign: awsConfig andDateTime: '20110909T233600Z'  andCanonicalRequest: canonicalRequestString.
	
	answer := 'AWS4-HMAC-SHA256', String lf,
	'20110909T233600Z',String lf,
	'20110909/us-east-1/iam/aws4_request',String lf,
	'3511de7e95d28ecd39e9513b642aee07e54f4941150d8df8bf94b328ef7e55e2'.
	
	self assert:(result = answer)
]

{ #category : #'tests-private' }
SignatureV4Test >> testGetEncodedSortQueryString [
	| dict |
	
	dict := '/' asUrl query.
	self assert:( (SignatureV4 new getEncodedSortQueryString: dict) = '' ).
	
	dict := '/?b=2&Z=1' asUrl query.
	self assert:( (SignatureV4 new getEncodedSortQueryString: dict) = 'Z=1&b=2' ).
	
	dict := '/?a c=2' asUrl query.
	self assert:( (SignatureV4 new getEncodedSortQueryString: dict) = 'a%20c=2' ).
	
	dict := '/?D=3&b=2&Z=1' asUrl query.
	self assert:( (SignatureV4 new getEncodedSortQueryString: dict) = 'D=3&Z=1&b=2' ).
	
	dict := '/?foasdfasd  o=Zoo&foo=aha&D=aaaa&GS=xxxx' asUrl query.
	self assert:( (SignatureV4 new getEncodedSortQueryString: dict) = 'D=aaaa&GS=xxxx&foasdfasd%20%20o=Zoo&foo=aha').
]
