tests-private
testCreateSignHeaders
	|  request |
	
	request := ZnRequest empty.
	request headers at:'host' put:'iam.amazonaws.com'.
	request headers at:'content-type' put:'application/x-www-form-urlencoded; charset=utf-8'.
	request headers at:'x-amz-date' put:'20110909T233600Z'.
	request headers removeKey:'User-Agent'.
	
	self assert:( (SignatureV4 new createSignHeaders: request) = 'content-type;host;x-amz-date' ).