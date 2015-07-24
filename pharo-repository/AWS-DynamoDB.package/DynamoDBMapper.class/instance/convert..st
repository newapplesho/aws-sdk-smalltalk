private
convert: aDictionary
	| jsonObject |
	jsonObject := JsonObject new.
       aDictionary keysDo: [:k | 
		| value boolean |
		value := aDictionary at: k .
		boolean:= value isString 
			ifTrue:[ value isEmptyOrNil  ] 
			ifFalse:[ value isNil ].
		boolean ifFalse:[ self  checkType: value  key: k on: jsonObject.] ].
	^ jsonObject. 