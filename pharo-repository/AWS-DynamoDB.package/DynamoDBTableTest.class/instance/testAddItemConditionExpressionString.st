tests-api-putItem
testAddItemConditionExpressionString
	| dynamoTable  result uuid dummy1 dummy2 dummy3 response enu |
	uuid := UUID new primMakeUUID hex.
	dummy1 := DynamoDBDummyModel2 new.
	dummy1 id: uuid.
	dummy1 username: 'newapplesho'.
	dummy1 description: 'hogehoge'.
	dynamoTable := DynamoDBTable tableNamed: self tableName.
	result := dynamoTable addItem: dummy1.
	self assert: (result isEmpty).
	
	dummy2 := DynamoDBDummyModel2 new.
	dummy2 id: uuid.
	dummy2 username: 'newapplesho'.
	dummy2 description: 'hogehoge'.
	dynamoTable := DynamoDBTable tableNamed: self tableName.
	dynamoTable addItem:  dummy2 conditionExpressionString: 'attribute_not_exists(id)'.
	
	response := dynamoTable response.
	self assert: (response status = 400).
	
	dummy3 := DynamoDBDummyModel2 new.
	dummy3 id: UUID new primMakeUUID hex.
	dummy3 username: 'newapplesho'.
	dummy3 description: 'hogehoge'.
	dynamoTable := DynamoDBTable tableNamed: self tableName.
	dynamoTable addItem:  dummy3 conditionExpressionString: 'attribute_not_exists(id)'.
	
	response := dynamoTable response.
	self assert: (response status = 200).
	
	dynamoTable numberOfResultsToFetch: 5.
	enu := dynamoTable enumerator.
	[enu atEnd] whileFalse: [ enu fetchNextUnits. ].
	self assert: ( enu resultStream contents  size = 2 ) .
	
