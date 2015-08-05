api-getItem
getItemBy: anObject
	| operation keyDynamoJson dict |
	dict := anObject asDictionary.
	operation := DynamoDBGetItem new.
	keyDynamoJson := (mapper convertDynamoDBJson: dict ).
	operation key: keyDynamoJson.
	^ self getItem: operation.