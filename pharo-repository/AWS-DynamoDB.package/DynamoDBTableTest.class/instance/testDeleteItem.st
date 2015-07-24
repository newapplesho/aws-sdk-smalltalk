tests-api-deleteItem
testDeleteItem
	| dynamoTable dummy uuid result |
	uuid := UUID new primMakeUUID hex.
	dummy := DynamoDBDummyModel2 new.
	dummy id: uuid.
	dynamoTable := DynamoDBTable tableNamed: self tableName.
	dynamoTable addItem: dummy.
	
	result := dynamoTable deleteItem: dummy.
	self assert: (result isEmpty).