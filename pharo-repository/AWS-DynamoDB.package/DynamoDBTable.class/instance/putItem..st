api-putItem
putItem: anObject
	| dict operation  dynamoJson |
	dict := self checkRespondsToProperties: anObject.
	operation := DynamoDBPutItem new.
	dynamoJson := (mapper convertDynamoDBJson: dict ).
	operation item: dynamoJson.
	^ self action: operation.