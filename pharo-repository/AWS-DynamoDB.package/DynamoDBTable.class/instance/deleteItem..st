api-deleteItem
deleteItem: anObject
	| dict operation keyJson keyDynamoJson |
	dict := self checkRespondsToProperties: anObject.

	operation := DynamoDBDeleteItem new.
	keyJson := JsonObject new.
	
	(anObject respondsTo: #dynamoIndexKeys)
		ifTrue:[ anObject dynamoIndexKeys do:[:key |  keyJson at: key put: (dict at: key ) ].  ]
		ifFalse:[ self indexKeys do:[:key |  keyJson at: key put: (dict at: key ) ]. ].
	
	keyDynamoJson := (mapper convertDynamoDBJson: keyJson ).
	operation key: keyDynamoJson.
	^ self action: operation.