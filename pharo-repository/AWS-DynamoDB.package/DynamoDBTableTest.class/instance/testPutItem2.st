tests-api-addItem
testPutItem2
	| dynamoTable  result dict uuid |
	uuid := UUID new primMakeUUID hex.
	dict := DynamoDBDummyModel1 new at:'id' put: uuid; yourself.
	dynamoTable := DynamoDBTable tableNamed: self tableName.
	result := dynamoTable addItem: dict.
	self assert: (result isEmpty).