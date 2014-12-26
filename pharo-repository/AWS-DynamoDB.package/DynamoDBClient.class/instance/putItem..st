private
putItem: anObject

	| dy mapper  c json requestBody operationName resp result |
	
	operationName := 'PutItem'.
	json := JsonObject new at:'TableName' put: anObject class instanceSide name asLowercase; yourself.
	
	dy := self rawClient.
	mapper := DynamoDBMapper new.
	c := (mapper convertItem: anObject ).
	json at:'Item' put: c .
	requestBody := json asJsonString .
	
	resp := dy operationName:  operationName entityContents: requestBody.
	result := Json readFrom: (resp contents) readStream.
