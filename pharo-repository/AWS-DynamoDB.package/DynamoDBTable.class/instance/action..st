action
action: aDynamoDBOperation
	aDynamoDBOperation tableName: self tableName.
	response :=  client operationName: aDynamoDBOperation operationType contents: aDynamoDBOperation asJsonString.
	^  Json readFrom: (response contents) readStream.