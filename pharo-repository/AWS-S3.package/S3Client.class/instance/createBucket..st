low-level-api
createBucket: bucketNameString
	| dt t datetimeString hostUrl request requestBody |
	
	requestBody := '<CreateBucketConfiguration xmlns="http://s3.amazonaws.com/doc/2006-03-01/"> 
  <LocationConstraint>', awsConfig regionName ,'</LocationConstraint> 
</CreateBucketConfiguration >'.
		
	dt :=DateAndTime now asUTC.
	t :=  (dt asTimeUTC print24 findTokens: '.')first copyReplaceAll:':' with:''.
	datetimeString := (dt asDate printFormat:#(3 2 1 0 1 1 2)),'T',t,'Z'.
	
	hostUrl := bucketNameString, '.', awsConfig endpoint.
	
	request := ZnRequest empty.
	request method: #PUT.
	request url:'/'.
	request entity:( ZnEntity readBinaryFrom: requestBody asByteArray readStream usingType: ZnMimeType textPlain andLength: requestBody size).
	"request headers at:'Content-Length' put: requestBody byteSize asString."
	request headers at:'host' put: hostUrl.
	request headers at:'x-amz-content-sha256' put: (SHA256 new hashMessage: requestBody) hex.
	request headers at:'x-amz-date' put: datetimeString.
	request setAuthorization: ( SignersV4 creatAuthorization: request andConfig: awsConfig andDateTime: datetimeString andOption: nil ) .

	^ self request: request andOption: nil.