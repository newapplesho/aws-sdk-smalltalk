api-listTables
listTables
	| listTables |
	listTables := DynamoDBListTables new.
	^ self action: listTables.