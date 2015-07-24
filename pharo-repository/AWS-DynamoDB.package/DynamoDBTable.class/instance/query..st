api-query
query: aDynamoDBQuery
	| jsonObject |
	jsonObject := self action: aDynamoDBQuery.
	(jsonObject at:'Count') >  0 
		ifTrue:[ ^ (jsonObject at:'Items') collect:[:v | mapper loadFrom:  v ].]  
		ifFalse:[ ^#() ].