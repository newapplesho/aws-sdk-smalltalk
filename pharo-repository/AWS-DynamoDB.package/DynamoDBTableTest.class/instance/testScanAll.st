tests-api-scan
testScanAll

	| dynamoTable uuid dict enu counter |
	
	counter := 0.

	dynamoTable := DynamoDBTable tableNamed: self tableName.	

	20 timesRepeat: [ 
		uuid := UUID new primMakeUUID hex.
		dict := Dictionary newFrom: {'id'->uuid}.
		dynamoTable addItem: dict. ].

	dynamoTable numberOfResultsToFetch: 5.
	enu := dynamoTable enumerator.
	[enu atEnd] whileFalse: [
		| result |
		result := enu fetchNextUnits.
		counter := counter + 1.
	].
	self assert: ( enu resultStream contents  size = 20 ) .
	self assert: (counter = 4). 
	"enu resultStream contents inspect."