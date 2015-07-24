test-api-query
testQueryKeyConditionExpressionStringBinding
	| dynamoTable  result uuid dummy |
	uuid := UUID new primMakeUUID hex.
	dummy := DynamoDBDummyModel2 new.
	dummy id: uuid.
	dummy username: 'newapplesho'.
	dummy description: 'hogehoge'.
	dynamoTable := DynamoDBTable tableNamed: self tableName.
	result := dynamoTable addItem: dummy.
	self assert: (result isEmpty).
	
	dynamoTable := DynamoDBTable tableNamed: self tableName.
	result := dynamoTable queryKeyConditionExpressionString: 'id = :id' binding: (Dictionary newFrom: {':id'->uuid}).
	self assert:( result size = 1).
	
	self assert:( (result anyOne at: #username)= 'newapplesho' ).