running
tearDown

	| operationName requestBody dy resp |
	
	dy := DynamoDBRawClient new.
	operationName := #DeleteTable.
	requestBody := JsonObject new at:'TableName' put: self tableName; asJsonString .
	resp := dy operationName:  operationName contents: requestBody.
	Json readFrom: (resp contents) readStream.