tests-api-getItem
testDescribeTable
	| dynamoTable  result |
	dynamoTable := DynamoDBTable tableNamed: self tableName.
	result := dynamoTable describeTable.
	result asString.