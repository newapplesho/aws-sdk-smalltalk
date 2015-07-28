api-putItem
putItem: anObject conditionExpressionString: aString binding: aDictionary
	| dict operation  dynamoDBJson itemDynamoJson |
	dict := self checkRespondsToProperties: anObject.
	operation := DynamoDBPutItem new.
	operation conditionExpression: aString.
	aDictionary ifNotNil: [  
		dynamoDBJson := mapper convertDynamoDBJson: aDictionary.
		operation expressionAttributeValues: dynamoDBJson. ].
	itemDynamoJson := mapper convertDynamoDBJson: dict .
	operation item: itemDynamoJson.
	^ self action: operation.