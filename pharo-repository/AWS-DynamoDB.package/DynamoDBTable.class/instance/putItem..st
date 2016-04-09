api-putItem
putItem: aDictionary
	| operation dynamoDbJson |	
	operation := DynamoDBPutItem new.
	dynamoDbJson := self mapper convert: aDictionary.
	operation item: dynamoDbJson.
	^ self action: operation.