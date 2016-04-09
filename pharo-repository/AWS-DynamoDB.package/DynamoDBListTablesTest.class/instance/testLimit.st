tests-public
testLimit
	| listTables |
	listTables := DynamoDBListTables new limit: 3.
	self assert: ((listTables limit) = '3').	

	listTables := DynamoDBListTables new limit: '3'.
	self assert: ((listTables limit) = '3').	