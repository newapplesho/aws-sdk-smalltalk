private
getItem: anObject
	| operationName json dy mapper  c requestBody resp result |

	operationName := 'GetItem'.
	json := JsonObject new at:'TableName' put: self class instanceSide name asLowercase; yourself.
	
	dy := self defaultRawClient.
	
	mapper := DynamoDBMapper new.
	c := mapper convertItem: anObject.
	json at:'Key' put: c .

	requestBody := json asJsonString .
	resp := dy operationName:  operationName entityContents: requestBody.
	result := Json readFrom: (resp contents) readStream.
	
	^ mapper loadItem: (result at:'Item') .