public
limit: aNumberOrNumberString
	| limitNumber |
	
	limitNumber := aNumberOrNumberString isNumber 
		ifTrue:[ aNumberOrNumberString asString ]
		ifFalse:[ aNumberOrNumberString ].

	self at: 'limit' put: limitNumber.