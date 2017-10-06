tests-private
testCreatCanonicalHeaders
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
	
	Smalltalk version = 'Pharo6.0'
		ifTrue:[
			self assert:( (SignatureV4 new creatCanonicalHeaders: request) = ('content-length:2', String lf,
				'content-type:application/x-amz-json-1.0', String lf,
				'host:dynamodb.ap-northeast-1.amazonaws.com', String lf,
				'user-agent:Zinc HTTP Components 1.0 (Pharo/6.0)', String lf,
				'x-amz-date:20141215T104253Z', String lf,
				'x-amz-target:application/x-amz-json-1.0', String lf )).]
		ifFalse:[
			self assert:( (SignatureV4 new creatCanonicalHeaders: request) = ('content-length:2', String lf,
				'content-type:application/x-amz-json-1.0', String lf,
				'host:dynamodb.ap-northeast-1.amazonaws.com', String lf,
				'user-agent:Zinc HTTP Components 1.0', String lf,
				'x-amz-date:20141215T104253Z', String lf,
				'x-amz-target:application/x-amz-json-1.0', String lf )). ].