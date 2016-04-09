api-getItem
getItemBy: anObject
	| operation keyDynamoJson |
	operation := DynamoDBGetItem new.
	keyDynamoJson := mapper convert: anObject.
	operation key: keyDynamoJson.
	^ self getItem: operation