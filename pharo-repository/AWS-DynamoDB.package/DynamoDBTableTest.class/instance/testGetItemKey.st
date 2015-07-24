tests-api-getItem
testGetItemKey
	| dynamoTable  result dummy uuid |
	uuid := UUID new primMakeUUID hex.
	dummy := DynamoDBDummyModel2 new.
	dummy id: uuid.
	dummy username: 'newapplesho'.
	dummy description: 'hogehoge'.
	dynamoTable := DynamoDBTable tableNamed: self tableName.
	result := dynamoTable addItem: dummy.
	self assert: (result isEmpty).
	
	result := dynamoTable getItemKey: (Dictionary newFrom:{#id->uuid}).
	self assert: ( (result at:#description) =  'hogehoge' ).