api-scan
scan: aDynamoDbScan
	| jsonObject |
	jsonObject := self action: aDynamoDbScan.
	(jsonObject at:'Count') >  0 
		ifTrue:[ ^ (jsonObject at:'Items') collect:[:v | mapper loadFrom:  v ].]  
		ifFalse:[ ^#() ].