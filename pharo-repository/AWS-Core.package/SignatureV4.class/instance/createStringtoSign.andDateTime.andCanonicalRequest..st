private
createStringtoSign: awsConfig andDateTime: datetimeString andCanonicalRequest: canonicalRequestString
	| sts dateStamp |
	"Task 2: Create a String to Sign for Signature Version 4"
	"reference.
	 http://docs.aws.amazon.com/general/latest/gr/sigv4-create-string-to-sign.html"
	"datetimeString format 20110909T233600Z"
	"dateStamp format 20110909"
	dateStamp := datetimeString first: 8.
	sts := self signatureAlgorithm , String lf.
	sts := sts , datetimeString , String lf.
	sts := sts , (self createCredentialScopeValue: awsConfig andDateTime: datetimeString) , String lf.
	sts := sts , (SHA256 new hashMessage: canonicalRequestString) hex.
	^ sts