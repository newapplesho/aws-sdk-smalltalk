test-api-query
testQueryKeyConditionExpressionStringBinding
	| dynamoTable  result uuid dummy |
	uuid := UUID new primMakeUUID hex.
	dummy := {'id'->uuid. 'username'->'newapplesho'. 'description'->'foobar' } asDictionary.
	dynamoTable := DynamoDBTable tableNamed: self tableName.
	result := dynamoTable putItem: dummy.
	self assert: (result isEmpty).
	
	dynamoTable := DynamoDBTable tableNamed: self tableName.
	result := dynamoTable queryKeyConditionExpressionString: 'id = :id' binding: (Dictionary newFrom: {':id'->uuid}).
	self assert:( result size = 1).
	
	self assert:( (result anyOne at: #username)= 'newapplesho' ).