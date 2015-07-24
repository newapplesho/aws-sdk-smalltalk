tests-public
testLimit
	| listTables |
	listTables := DynamoDBListTables new limit: 3.
	self assert: ((listTables at:'limit') = '3').	

	listTables := DynamoDBListTables new limit: '3'.
	self assert: ((listTables at:'limit') = '3').	