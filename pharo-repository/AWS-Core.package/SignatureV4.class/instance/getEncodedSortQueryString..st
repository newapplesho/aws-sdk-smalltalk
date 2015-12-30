private
getEncodedSortQueryString: aDictionary
	| queryString |

	aDictionary isEmptyOrNil ifTrue:[ ^ '' ].

	queryString := String streamContents:[:s|
		aDictionary keysSortedSafely do:[:key|
			(aDictionary at:key) isArray 
				ifTrue:[
					(aDictionary at:key) do: [ :each | 
						s nextPutAll: key urlEncoded.
						s nextPutAll: '='.
						s nextPutAll: each urlEncoded.
					] separatedBy:[s nextPutAll: '&'].
				]
				ifFalse:[
					s nextPutAll: key urlEncoded.
					s nextPutAll: '='.
					s nextPutAll: (aDictionary at:key) urlEncoded . ].
		] separatedBy:[s nextPutAll: '&'].
	].

	^ queryString