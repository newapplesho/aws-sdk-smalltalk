accessing
listTables
	| dy operationName requestBody resp  |
	
	dy := self defaultClient.
	
	operationName := #ListTables.
	requestBody := '{}'.
	resp := dy operationName:  operationName entityContents: requestBody.
	
	^ Json readFrom: (resp contents) readStream.