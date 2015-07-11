tests-low-level-api
testOperationNameContents

	| dy operationName  resp result requestJson |
	dy := DynamoDBRawClient new.
	operationName := #ListTables.
	requestJson := DyListTables new asJsonString.
	resp := dy operationName:  operationName contents: requestJson.
	result := Json readFrom: (resp contents) readStream.
	
	self assertCollection:( result at:'TableNames' ) equals: ( Array with: self tableName  ).