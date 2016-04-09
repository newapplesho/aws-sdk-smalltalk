tests-api-putItem
testPutItem
	| dynamoDbTable  result  uuid item |
	uuid := UUID new primMakeUUID hex.
	item := Dictionary newFrom: {'id'-> uuid.}.
	dynamoDbTable := DynamoDBTable tableNamed: self tableName.
	result := dynamoDbTable putItem: item.
	self assert: (result isEmpty).
	
	uuid := UUID new primMakeUUID hex.
	item := Dictionary newFrom: {'id'-> uuid. 'name'-> 'newapplesho' }.
	dynamoDbTable := DynamoDBTable tableNamed: self tableName.
	result := dynamoDbTable putItem: item.
	self assert: (result isEmpty).