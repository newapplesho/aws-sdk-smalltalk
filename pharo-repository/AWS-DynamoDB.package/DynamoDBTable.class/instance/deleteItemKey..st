api-deleteItem
deleteItemKey: anDictionary
	| dict operation keyJson keyDynamoJson |
	dict := self checkRespondsToProperties: anDictionary.

	operation := DynamoDBDeleteItem new.
	keyJson := JsonObject new.
	
	(anDictionary respondsTo: #dynamoIndexKeys)
		ifTrue:[ anDictionary dynamoIndexKeys do:[:key |  keyJson at: key put: (dict at: key ) ].  ]
		ifFalse:[ self indexKeys do:[:key |  keyJson at: key put: (dict at: key ) ]. ].
	
	keyDynamoJson := (mapper convertDynamoDBJson: keyJson ).
	operation key: keyDynamoJson.
	^ self action: operation.