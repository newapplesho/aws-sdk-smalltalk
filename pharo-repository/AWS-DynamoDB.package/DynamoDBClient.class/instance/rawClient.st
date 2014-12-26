accessing
rawClient
	
	^ rawClient ifNil: [rawClient := DynamoDBRawClient new]