public
limit: aNumberOrNumberString
	| limitNumber |	
	limitNumber := aNumberOrNumberString isNumber 
		ifTrue:[ aNumberOrNumberString asString ]
		ifFalse:[ aNumberOrNumberString ].

	self modifiers at: 'limit' put: limitNumber.