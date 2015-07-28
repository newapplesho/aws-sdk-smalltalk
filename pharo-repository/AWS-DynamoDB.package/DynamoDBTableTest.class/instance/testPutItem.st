tests-api-putItem
testPutItem
	| dynamoTable  result dict uuid |
	uuid := UUID new primMakeUUID hex.
	dict := Dictionary newFrom: {'id'->uuid}.
	dynamoTable := DynamoDBTable tableNamed: self tableName.
	result := dynamoTable addItem: dict.
	self assert: (result isEmpty).