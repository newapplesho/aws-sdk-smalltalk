api-describeTable
describeTable
	| describeDbynamoDbTable |
	describeDbynamoDbTable := DynamoDBDescribeTable new.
	^ self action: describeDbynamoDbTable.