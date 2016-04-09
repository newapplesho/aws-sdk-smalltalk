tests-api-getItem
testGetItemBy
	| dynamoDbTable  result dummy uuid |
	uuid := UUID new primMakeUUID hex.
	dummy := Dictionary new.
	dummy at:'id' put: uuid.
	dummy at:'username' put: 'newapplesho'.
	dummy at: 'description' put: 'foobar'.
	dynamoDbTable := DynamoDBTable tableNamed: self tableName.
	result := dynamoDbTable putItem: dummy.
	self assert: (result isEmpty).
	
	result := dynamoDbTable getItemBy: {#id->uuid} asDictionary.
	self assert: ( (result at:#description) =  'foobar' ).