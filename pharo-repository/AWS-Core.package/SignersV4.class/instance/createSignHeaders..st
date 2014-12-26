private
createSignHeaders: request
	| headers signHeadersString |
	headers := Dictionary new.

	request headers keysAndValuesDo: [ :k :v |
		(k ~= 'Accept') ifTrue:[
			headers at: k put: v.
		].
	  ].

	signHeadersString :=  String streamContents:[:s|
		headers keysSortedSafely do:[:key | 
			s nextPutAll: key asLowercase .
		] separatedBy: [ s nextPutAll: ';' ]
	].

	^ signHeadersString