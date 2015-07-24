tests-api-listTables
testListTables
	| dynamoTable  result |
	dynamoTable := DynamoDBTable tableNamed: self tableName.
	result := dynamoTable listTables.
	self assertCollection:( result at:'TableNames' ) equals: ( Array with: self tableName  ).