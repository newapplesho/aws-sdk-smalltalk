tests-private
testCreateCanonicalRequestAndOption
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
	
	self assert:( (SignersV4 new createCanonicalRequest: request andOption: nil ) = ('POST', String lf,
'/', String lf,String lf,
'content-type:application/x-www-form-urlencoded; charset=utf-8', String lf,
'host:iam.amazonaws.com', String lf,
'x-amz-date:20110909T233600Z', String lf, String lf,
'content-type;host;x-amz-date', String lf,
'b6359072c78d70ebee1e81adcbab4f01bf2c23245fa365ef83fe8f1f955085e2' ) ).