tests-private
testGetEncodedSortQueryString
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