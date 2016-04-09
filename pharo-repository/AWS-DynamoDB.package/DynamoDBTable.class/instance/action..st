action
action: aDynamoDbOperation
	aDynamoDbOperation tableName: self tableName.
	response := self client 
		operationName: aDynamoDbOperation operationType contents: aDynamoDbOperation asJsonString.
	^ Json readFrom: response contents readStream