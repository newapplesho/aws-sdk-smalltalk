Class {
	#name : #DynamoDBQueryOrScanResultEnumerator,
	#superclass : #Object,
	#instVars : [
		'resultStream',
		'searcher'
	],
	#category : #'AWS-DynamoDB'
}

{ #category : #'instance creation' }
DynamoDBQueryOrScanResultEnumerator class >> with: aDynamoDbTable [
	| inst |
	inst := self new.
	inst searcher: aDynamoDbTable.
	inst resultStream nextPutAll: (aDynamoDbTable scanNumberOfResultsToFetch: aDynamoDbTable numberOfResultsToFetch).
	^inst
]

{ #category : #testing }
DynamoDBQueryOrScanResultEnumerator >> atEnd [
	^self searcher isLastEvaluatedKey not
]

{ #category : #fetching }
DynamoDBQueryOrScanResultEnumerator >> fetchNextUnits [
	| results |
	results := (self searcher scanNumberOfResultsToFetch: self searcher numberOfResultsToFetch andLastEvaluatedKey: self searcher lastEvaluatedKey).
	^self resultStream nextPutAll: results
]

{ #category : #accessing }
DynamoDBQueryOrScanResultEnumerator >> resultStream [
	^ resultStream ifNil: [resultStream := WriteStream on: OrderedCollection new]
]

{ #category : #accessing }
DynamoDBQueryOrScanResultEnumerator >> resultStream: anObject [
	resultStream := anObject
]

{ #category : #accessing }
DynamoDBQueryOrScanResultEnumerator >> searcher [
	^ searcher
]

{ #category : #accessing }
DynamoDBQueryOrScanResultEnumerator >> searcher: anObject [
	searcher := anObject
]
