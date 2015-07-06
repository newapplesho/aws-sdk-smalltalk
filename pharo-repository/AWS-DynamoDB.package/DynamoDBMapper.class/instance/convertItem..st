private
convertItem: anObject
	| dict   |
	(anObject respondsTo: #data)
		ifTrue:[
			dict := anObject perform:#data.]
		ifFalse:[
			dict := anObject ].
	
	^ self convert: dict
	"json := JsonObject new.
       dict keys do:[:k | 
		| value boolean |
		value := dict at: k .
		value isString ifTrue:[ boolean:= value isEmptyOrNil  ] ifFalse:[ boolean := value isNil ].
		boolean ifFalse:[ self  checkType: value  key: k on: json.] ].
	^ json. "