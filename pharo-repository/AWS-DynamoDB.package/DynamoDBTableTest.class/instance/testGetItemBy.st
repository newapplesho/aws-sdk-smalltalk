tests-api-getItem
testGetItemBy
	| dynamoTable  result dummy uuid |
	uuid := UUID new primMakeUUID hex.
	dummy := DynamoDBDummyModel2 new.
	dummy id: uuid.
	dummy username: 'newapplesho'.
	dummy description: 'hogehoge'.
	dynamoTable := DynamoDBTable tableNamed: self tableName.
	result := dynamoTable putItem: dummy.
	self assert: (result isEmpty).
	
	result := dynamoTable getItemBy: {#id->uuid}.
	self assert: ( (result at:#description) =  'hogehoge' ).