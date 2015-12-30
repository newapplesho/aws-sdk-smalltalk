private
createSign:  request andConfig: awsConfig andDateTime: datetimeString andOption: aDictionary
	|  cs sts hmac    kSigning sign |
	
	"Task 1: Create a Canonical Request For Signature Version 4"
	cs := self createCanonicalRequest:  request  andOption: nil. 
	
	"Task 2: Create a String to Sign for Signature Version 4"
	sts :=  self createStringtoSign: awsConfig andDateTime: datetimeString andCanonicalRequest: cs.
	
	"Task 3: Calculate the AWS Signature Version 4" 
	kSigning := self createDerivedSigningKey: awsConfig andDateTime: datetimeString.

	hmac := SHA256 new hmac.
	hmac key: kSigning.
	sign := hmac digestMessage: sts.
	^ sign hex.