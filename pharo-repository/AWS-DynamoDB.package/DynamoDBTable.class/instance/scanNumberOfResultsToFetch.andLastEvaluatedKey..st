api-scan
scanNumberOfResultsToFetch:  aNumber andLastEvaluatedKey: aLastEvaluatedKeyObject
	|  resultCollection dynamoDbScan resultJson |
	resultCollection := OrderedCollection new.
	dynamoDbScan := DynamoDBScan new.
	dynamoDbScan setSelectAllAttributes.
	aLastEvaluatedKeyObject ifNotNil:[ dynamoDbScan exclusiveStartKey: aLastEvaluatedKeyObject. ].
	dynamoDbScan limit: aNumber.
	resultJson := self action: dynamoDbScan.
	lastEvaluatedKey := resultJson at:'LastEvaluatedKey'.
	(resultJson at:'Items') do:[:item | 
		resultCollection add: (mapper loadFrom:  item) ].
	
	^ resultCollection.