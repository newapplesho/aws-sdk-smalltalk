private
createDerivedSigningKey: awsConfig andDateTime: datetimeString
	
	|    hmac kDate kRegion kService kSigning  |
	
	"Task 3: Calculate the AWS Signature Version 4"
	"reference.
	 http://docs.aws.amazon.com/general/latest/gr/sigv4-calculate-signature.html"
	
	"kDate"
	hmac := SHA256 new hmac.
	hmac key: ('AWS4', awsConfig secretKey) asByteArray.
	kDate := hmac digestMessage: ( datetimeString first: 8 ).
	
	"kRegion"
	hmac := SHA256 new hmac.
	hmac key: kDate.
	kRegion := hmac digestMessage: awsConfig regionName.

	"kService"
	hmac := SHA256 new hmac.
	hmac key: kRegion.
	kService := hmac digestMessage: awsConfig serviceName asLowercase.

	"kSigning"
	hmac := SHA256 new hmac.
	hmac key: kService.
	kSigning := hmac digestMessage: 'aws4_request'.
	
	^ kSigning.
