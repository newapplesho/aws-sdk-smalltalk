fetching
fetchNextUnits
	| results |
	results := (self searcher scanNumberOfResultsToFetch: self searcher numberOfResultsToFetch andLastEvaluatedKey: self searcher lastEvaluatedKey).
	^self resultStream nextPutAll: results