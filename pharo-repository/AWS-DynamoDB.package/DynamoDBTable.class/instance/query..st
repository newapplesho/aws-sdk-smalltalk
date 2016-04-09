api-query
query: aDynamoDbQuery
	| jsonObject |
	jsonObject := self action: aDynamoDbQuery.
	(jsonObject at:'Count') >  0 
		ifTrue:[ ^ (jsonObject at:'Items') collect:[:v | mapper loadFrom:  v ].]  
		ifFalse:[ ^#() ].