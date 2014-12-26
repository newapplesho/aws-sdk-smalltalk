private
creatCanonicalHeaders: request
	| headers canonicalHeadersString |
	headers := Dictionary new.

	request headers keysAndValuesDo: [ :k :v |
		(k ~= 'Accept') ifTrue:[
			headers at: k put: v.
		].
	  ].

	canonicalHeadersString :=  String streamContents:[:s|
		headers keysSortedSafely do:[:key | 
			s nextPutAll: key urlEncoded asLowercase .
			s nextPutAll: ':'.
			s nextPutAll: ( (headers at: key ) copyWithRegex: '\s+' matchesReplacedWith: ' ') trimBoth .
			s nextPutAll: String lf.
		].
	].

	^ canonicalHeadersString