private
convert: aDictionary
	| json |
	json := JsonObject new.
       aDictionary keys do:[:k | 
		| value boolean |
		value := aDictionary at: k .
		value isString ifTrue:[ boolean:= value isEmptyOrNil  ] ifFalse:[ boolean := value isNil ].
		boolean ifFalse:[ self  checkType: value  key: k on: json.] ].
	^ json. 