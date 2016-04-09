api-deleteItem
deleteItem: anObject
	| operation dynamoDbJson |
	operation := DynamoDBDeleteItem new.
	dynamoDbJson := mapper convert: anObject.
	operation key: dynamoDbJson.
	^ self action: operation