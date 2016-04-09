accessing
client
	^ client ifNil:[ client := self defaultDynamoDbClient. ]