tests-api-putItem
testPutItemConditionExpressionString
	| dynamoDbTable  result uuid dummy1 dummy2 dummy3 dummy4 response enu |
	uuid := UUID new primMakeUUID hex.
	dummy1 := {'id'->uuid. 'username'->'newapplesho'. 'description'->'foobar' } asDictionary.
	dynamoDbTable := DynamoDBTable tableNamed: self tableName.
	result := dynamoDbTable putItem: dummy1.
	self assert: (result isEmpty).
	
	dummy2 := {'id'->uuid. 'username'->'newapplesho'. 'description'->'foobar' } asDictionary.
	dynamoDbTable := DynamoDBTable tableNamed: self tableName.
	dynamoDbTable putItem:  dummy2 conditionExpressionString: 'attribute_not_exists(id)'.
	
	response := dynamoDbTable response.
	self assert: (response status = 400).
	
	dummy3 := {'id'->uuid. 'username'->'newapplesho'. 'description'->'foobar' } asDictionary.
	dynamoDbTable := DynamoDBTable tableNamed: self tableName.
	dynamoDbTable putItem: dummy3 conditionExpressionString: 'attribute_not_exists(id)'.
	
	response := dynamoDbTable response.
	self assert: (response status = 400).
	
	uuid := UUID new primMakeUUID hex.
	dummy4 := {'id'->uuid. 'username'->'newapplesho'. 'description'->'foobar' } asDictionary.
	dynamoDbTable := DynamoDBTable tableNamed: self tableName.
	dynamoDbTable putItem: dummy4 conditionExpressionString: 'attribute_not_exists(id)'.
	
	response := dynamoDbTable response.
	self assert: (response status = 200).
	
	dynamoDbTable numberOfResultsToFetch: 5.
	enu := dynamoDbTable enumerator.
	[enu atEnd] whileFalse: [ enu fetchNextUnits. ].
	self assert: ( enu resultStream contents size = 2 ) .
	
