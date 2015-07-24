instance creation
with: aDynamoDbTable
	| inst |
	inst := self new.
	inst searcher: aDynamoDbTable.
	inst resultStream nextPutAll: (aDynamoDbTable scanNumberOfResultsToFetch: aDynamoDbTable numberOfResultsToFetch).
	^inst