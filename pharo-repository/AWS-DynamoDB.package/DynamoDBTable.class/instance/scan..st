api-scan
scan: aDynamoDBScan
	| jsonObject |
	jsonObject := self action: aDynamoDBScan.
	(jsonObject at:'Count') >  0 
		ifTrue:[ ^ (jsonObject at:'Items') collect:[:v | mapper loadFrom:  v ].]  
		ifFalse:[ ^#() ].