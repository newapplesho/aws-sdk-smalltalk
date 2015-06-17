public
saveExpectedwithJson: jsonString
	| dy mapper  c json requestBody operationName resp result |
	
	operationName := 'PutItem'.
	json := JsonObject new at:'TableName' put: self class instanceSide name asLowercase; yourself.
	
	dy := self defaultRawClient.
	mapper := DynamoDBMapper new.
	c := (mapper convertItem: self ).
	json at:'Item' put: c .
	json at:'Expected' put: ( Json new readFrom: jsonString readStream ).
	requestBody := json asJsonString .
	
	resp := dy operationName:  operationName entityContents: requestBody.
	result := Json readFrom: (resp contents) readStream.
