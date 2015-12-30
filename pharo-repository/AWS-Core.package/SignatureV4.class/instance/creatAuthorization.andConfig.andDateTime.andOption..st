private
creatAuthorization: request andConfig: awsConfig andDateTime: datetimeString andOption: aDictionary

	| sign credential |
	
	sign :=  self  createSign: request andConfig: awsConfig andDateTime: datetimeString andOption: nil.
	
	credential := awsConfig accessKeyId,'/', (self createCredentialScopeValue: awsConfig andDateTime: datetimeString).
	
	^ self  signatureAlgorithm, ' Credential=',credential,', SignedHeaders=', ( self createSignHeaders: request ),', Signature=',sign.