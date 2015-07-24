api-getItem
getItemKey: aDictionary
	|  operation  keyDynamoJson |
	operation := DynamoDBGetItem new.
	keyDynamoJson := (mapper convertDynamoDBJson: aDictionary ).
	operation key: keyDynamoJson.
	^ self getItem: operation.