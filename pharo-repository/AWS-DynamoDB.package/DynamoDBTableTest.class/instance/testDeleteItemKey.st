tests-api-deleteItem
testDeleteItemKey
	| dynamoTable dummy uuid result |
	uuid := UUID new primMakeUUID hex.
	dummy := DynamoDBDummyModel2 new.
	dummy id: uuid.
	dynamoTable := DynamoDBTable tableNamed: self tableName.
	dynamoTable putItem: dummy.
	
	result := dynamoTable deleteItemKey: (Dictionary newFrom:{#id->uuid}).