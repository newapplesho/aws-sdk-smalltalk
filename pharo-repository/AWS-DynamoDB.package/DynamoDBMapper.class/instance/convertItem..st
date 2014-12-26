private
convertItem: anObject
	| dict  json |
	dict := anObject perform:#data.
	
	json := JsonObject new.
       dict keys do:[:k | 
		| value boolean |
		value := dict at: k .
		value isString ifTrue:[ boolean:= value isEmptyOrNil  ] ifFalse:[ boolean := value isNil ].
		boolean ifFalse:[ self  checkType: value  key: k on: json.] ].
	^ json. 