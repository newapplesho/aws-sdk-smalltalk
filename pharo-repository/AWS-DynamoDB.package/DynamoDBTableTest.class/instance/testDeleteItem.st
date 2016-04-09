tests-api-deleteItem
testDeleteItem
	| dynamoTable uuid result item1 item2 |
	
	uuid := UUID new primMakeUUID hex.
	item1 := Dictionary newFrom: {'id' -> uuid }.
	dynamoTable := DynamoDBTable tableNamed: self tableName.
	
	dynamoTable putItem: item1.
	
	result := dynamoTable getItemBy: {#id -> uuid} asDictionary.
	self assert: result isNotEmpty.
	
	result := dynamoTable deleteItem: item1.
	self assert: result isEmpty.
	
	uuid := UUID new primMakeUUID hex.
	item2 := Dictionary
		newFrom:
			{('id' -> uuid).
			('name' -> 'newapplesho')}.
	dynamoTable putItem: item2.
	
	result := dynamoTable getItemBy: {#id -> uuid} asDictionary.
	self assert: result isNotEmpty.
	
	result := dynamoTable deleteItem: {#id -> uuid} asDictionary.
	self assert: result isEmpty.
	
	result := dynamoTable getItemBy: {#id -> uuid} asDictionary.
	self assert: result isEmpty.