public
delete
	| dy mapper  c json requestBody operationName resp result key |
	
	operationName := 'DeleteItem'.
	json := JsonObject new at:'TableName' put: self class instanceSide name asLowercase; yourself.
	
	dy := self defaultRawClient.
	mapper := DynamoDBMapper new.
	
	key := self class instanceSide perform:#new.
	
	self primaryKeys do:[:v |  key data at: v put: (self data at: v ) ].
	
	c := (mapper convertDynamoDBJson: key ).
	json at:'Key' put: c .
	requestBody := json asJsonString .
	
	resp := dy operationName:  operationName entityContents: requestBody.
	result := Json readFrom: (resp contents) readStream.
