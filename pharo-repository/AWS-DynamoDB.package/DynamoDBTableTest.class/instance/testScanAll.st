tests-api-scan
testScanAll

	| dynamoDbTable  enu counter |
	
	counter := 0.
	dynamoDbTable := DynamoDBTable tableNamed: self tableName.	

	20 timesRepeat: [ 
		dynamoDbTable putItem: {'id'->UUID new primMakeUUID hex} asDictionary. ].

	dynamoDbTable numberOfResultsToFetch: 5.
	enu := dynamoDbTable enumerator.
	[enu atEnd] whileFalse: [
		| result |
		result := enu fetchNextUnits.
		counter := counter + 1.
	].
	self assert: ( enu resultStream contents size = 20 ) .
	self assert: (counter = 4). 