private
creatPreSignedUrlToRequest: request config: awsConfig dateTime: datetimeString option: aDictionary
	| sign credential url |
	credential := awsConfig accessKeyId , '/'
		, (self createCredentialScopeValue: awsConfig andDateTime: datetimeString).
	request uri queryAt: 'X-Amz-Algorithm' put: self signatureAlgorithm.
	request uri queryAt: 'X-Amz-Credential' put: credential.
	request uri queryAt: 'X-Amz-Date' put: datetimeString.
	request uri queryAt: 'X-Amz-SignedHeaders' put: (self createSignHeaders: request).
	(aDictionary at: #expire ifAbsent: [ nil ])
		ifNotNil: [ request uri queryAt: 'X-Amz-Expires' put: (aDictionary at: #expire) asString ].
	url := 'https://' , awsConfig hostUrl.
	
	sign := self
		createSign: request
		andConfig: awsConfig
		andDateTime: datetimeString
		andOption: nil.
	request uri query
		ifNil: [ url := url ]
		ifNotNil: [ url := url asString , '?' , (self getEncodedSortQueryString: request uri query) , '&' ].
	^ url , 'X-Amz-Signature=' , sign