tests-low-level-api
testOperationNameEntityContents

	| dy operationName requestBody resp result |
	dy := DynamoDBRawClient new.
	operationName := #ListTables.
	requestBody := '{}'.
	resp := dy operationName:  operationName entityContents: requestBody.
	result := Json readFrom: (resp contents) readStream.
	
	self assertCollection:( result at:'TableNames' ) equals: ( Array with: self tableName  ).