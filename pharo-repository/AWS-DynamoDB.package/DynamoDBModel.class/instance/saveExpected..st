public
saveExpected: anObject
	| dy mapper  c json requestBody operationName resp result |
	
	operationName := 'PutItem'.
	json := JsonObject new at:'TableName' put: self class instanceSide name asLowercase; yourself.
	
	dy := self defaultRawClient.
	mapper := DynamoDBMapper new.
	c := (mapper convertItem: self ).
	json at:'Item' put: c .
	json at:'Expected' put:  anObject.
	requestBody := json asJsonString .
	
	resp := dy operationName:  operationName entityContents: requestBody.
	result := Json readFrom: (resp contents) readStream.
