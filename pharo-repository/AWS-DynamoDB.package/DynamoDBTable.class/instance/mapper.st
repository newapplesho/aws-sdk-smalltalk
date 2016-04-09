accessing
mapper
	^ mapper ifNil:[ mapper := DynamoDBMapper new. ]