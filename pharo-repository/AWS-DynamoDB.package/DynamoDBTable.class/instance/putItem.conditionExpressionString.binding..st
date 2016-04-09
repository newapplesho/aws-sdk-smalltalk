api-putItem
putItem: anObject conditionExpressionString: aString binding: aDictionary
	| dict operation  dynamoDbJson itemDynamoDbJson |
	dict := self checkRespondsToProperties: anObject.
	operation := DynamoDBPutItem new.
	operation conditionExpression: aString.
	aDictionary ifNotNil: [  
		dynamoDbJson := mapper convert: aDictionary.
		operation expressionAttributeValues: dynamoDbJson. ].
	itemDynamoDbJson := self mapper convert: dict .
	operation item: itemDynamoDbJson.
	^ self action: operation.