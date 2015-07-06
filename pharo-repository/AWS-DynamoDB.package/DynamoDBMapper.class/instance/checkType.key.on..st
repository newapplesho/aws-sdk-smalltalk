private
checkType: anObject key: aSymbol on: jsonObject
	anObject isNumber 
		ifTrue:[ ^ jsonObject at: aSymbol asString put: (JsonObject new at:'N' put: anObject asString; yourself)  ].
	anObject isString 
		ifTrue:[  ^ jsonObject at: aSymbol asString put: (JsonObject new at:'S' put: anObject convertUTF8; yourself)   ].
	anObject isCollection
		 ifTrue:[ 
			| result |
			result := self checkCollectionType: anObject.
			
			(result ='NS') ifTrue:[ 
				| c |
				c := anObject collect:[:v | v asString ].
				^ jsonObject at: aSymbol asString put: (JsonObject new  at:'NS' put: c; yourself)  ].
			
			(result ='SS') ifTrue:[ 
				| c |
				c := anObject collect:[:v | v convertUTF8 ].
				^ jsonObject at: aSymbol asString put: (JsonObject new at:'SS' put: c; yourself)  ].
			
			(result ='BS') ifTrue:[ 
				| c |
				c := anObject collect:[:v | v asString ].
				^ jsonObject at: aSymbol asString put: (JsonObject new at:'BS' put: c; yourself) . ].
		 ].
	^ jsonObject at: aSymbol asString put: (JsonObject new at:'B' put: anObject asString ; yourself) 
		