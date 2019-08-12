Class {
	#name : #DynamoDBTable,
	#superclass : #Object,
	#instVars : [
		'tableName',
		'client',
		'indexKeys',
		'mapper',
		'response',
		'lastEvaluatedKey',
		'numberOfResultsToFetch'
	],
	#category : 'AWS-DynamoDB'
}

{ #category : #public }
DynamoDBTable class >> listTables [
]

{ #category : #public }
DynamoDBTable class >> tableNamed: aString [
	^ self new
		tableName: aString;
		yourself
]

{ #category : #action }
DynamoDBTable >> action: aDynamoDbOperation [
	aDynamoDbOperation tableName: self tableName.
	response := self client 
		operationName: aDynamoDbOperation operationType contents: aDynamoDbOperation asJsonString.
	^ Json readFrom: response contents readStream
]

{ #category : #private }
DynamoDBTable >> checkRespondsToProperties: anObject [
	(anObject respondsTo: #properties)
		ifTrue:[ ^anObject perform: #properties. ].
	^ anObject
]

{ #category : #accessing }
DynamoDBTable >> client [
	^ client ifNil:[ client := self defaultDynamoDbClient. ]
]

{ #category : #accessing }
DynamoDBTable >> client: anObject [
	client := anObject
]

{ #category : #default }
DynamoDBTable >> defaultDynamoDbClient [
	^ DynamoDBRawClient new
]

{ #category : #'api-deleteItem' }
DynamoDBTable >> deleteItem: anObject [
	| operation dynamoDbJson |
	operation := DynamoDBDeleteItem new.
	dynamoDbJson := mapper convert: anObject.
	operation key: dynamoDbJson.
	^ self action: operation
]

{ #category : #'api-describeTable' }
DynamoDBTable >> describeTable [
	| describeDbynamoDbTable |
	describeDbynamoDbTable := DynamoDBDescribeTable new.
	^ self action: describeDbynamoDbTable.
]

{ #category : #enumerating }
DynamoDBTable >> enumerator [
	^ DynamoDBQueryOrScanResultEnumerator with: self
]

{ #category : #'api-getItem' }
DynamoDBTable >> getItem: aDynamoDBGetItem [
	| jsonObject |
	jsonObject := self action: aDynamoDBGetItem.
	jsonObject ifEmpty:[ ^ jsonObject ].
	^ mapper loadFrom: (jsonObject at:'Item') .
]

{ #category : #'api-getItem' }
DynamoDBTable >> getItemBy: anObject [
	| operation keyDynamoJson |
	operation := DynamoDBGetItem new.
	keyDynamoJson := mapper convert: anObject.
	operation key: keyDynamoJson.
	^ self getItem: operation
]

{ #category : #accessing }
DynamoDBTable >> indexKeys [
	^ indexKeys
]

{ #category : #accessing }
DynamoDBTable >> indexKeys: anObject [
	indexKeys := anObject
]

{ #category : #testing }
DynamoDBTable >> isLastEvaluatedKey [
	^ lastEvaluatedKey isNotNil
]

{ #category : #accessing }
DynamoDBTable >> lastEvaluatedKey [
	^ lastEvaluatedKey
]

{ #category : #'api-listTables' }
DynamoDBTable >> listTables [
	| listTables |
	listTables := DynamoDBListTables new.
	^ self action: listTables.
]

{ #category : #accessing }
DynamoDBTable >> mapper [
	^ mapper ifNil:[ mapper := DynamoDBMapper new. ]
]

{ #category : #accessing }
DynamoDBTable >> mapper: anObject [
	mapper := anObject
]

{ #category : #accessing }
DynamoDBTable >> numberOfResultsToFetch [
	^ numberOfResultsToFetch
]

{ #category : #accessing }
DynamoDBTable >> numberOfResultsToFetch: anObject [
	numberOfResultsToFetch := anObject
]

{ #category : #'api-putItem' }
DynamoDBTable >> putItem: aDictionary [
	| operation dynamoDbJson |	
	operation := DynamoDBPutItem new.
	dynamoDbJson := self mapper convert: aDictionary.
	operation item: dynamoDbJson.
	^ self action: operation.
]

{ #category : #'api-putItem' }
DynamoDBTable >> putItem: anObject conditionExpressionString: aString [ 
	^ self putItem: anObject conditionExpressionString: aString binding: nil.
]

{ #category : #'api-putItem' }
DynamoDBTable >> putItem: anObject conditionExpressionString: aString binding: aDictionary [
	| dict operation  dynamoDbJson itemDynamoDbJson |
	dict := self checkRespondsToProperties: anObject.
	operation := DynamoDBPutItem new.
	operation conditionExpression: aString.
	aDictionary ifNotNil: [  
		dynamoDbJson := mapper convert: aDictionary.
		operation expressionAttributeValues: dynamoDbJson. ].
	itemDynamoDbJson := self mapper convert: dict .
	operation item: itemDynamoDbJson.
	^ self action: operation.
]

{ #category : #'api-query' }
DynamoDBTable >> query: aDynamoDbQuery [
	| jsonObject |
	jsonObject := self action: aDynamoDbQuery.
	(jsonObject at:'Count') >  0 
		ifTrue:[ ^ (jsonObject at:'Items') collect:[:v | mapper loadFrom:  v ].]  
		ifFalse:[ ^#() ].
]

{ #category : #'api-query' }
DynamoDBTable >> queryKeyConditionExpressionString: aString binding: aDictionary [
	| query dynamoDbJson |
	query := DynamoDBQuery new.
	query setSelectAllAttributes.
	query keyConditionExpression:  aString.
	dynamoDbJson := self mapper convert: aDictionary.
	query expressionAttributeValues: dynamoDbJson.
	^ self query: query.
	
]

{ #category : #accessing }
DynamoDBTable >> response [
	^ response
]

{ #category : #accessing }
DynamoDBTable >> response: anObject [
	response := anObject
]

{ #category : #'api-scan' }
DynamoDBTable >> scan: aDynamoDbScan [
	| jsonObject |
	jsonObject := self action: aDynamoDbScan.
	(jsonObject at:'Count') >  0 
		ifTrue:[ ^ (jsonObject at:'Items') collect:[:v | mapper loadFrom:  v ].]  
		ifFalse:[ ^#() ].
]

{ #category : #'api-scan' }
DynamoDBTable >> scanNumberOfResultsToFetch: aNumber [
	^ self scanNumberOfResultsToFetch: aNumber andLastEvaluatedKey:  nil.
]

{ #category : #'api-scan' }
DynamoDBTable >> scanNumberOfResultsToFetch:  aNumber andLastEvaluatedKey: aLastEvaluatedKeyObject [
	|  resultCollection dynamoDbScan resultJson |
	resultCollection := OrderedCollection new.
	dynamoDbScan := DynamoDBScan new.
	dynamoDbScan setSelectAllAttributes.
	aLastEvaluatedKeyObject ifNotNil:[ dynamoDbScan exclusiveStartKey: aLastEvaluatedKeyObject. ].
	dynamoDbScan limit: aNumber.
	resultJson := self action: dynamoDbScan.
	lastEvaluatedKey := resultJson at:'LastEvaluatedKey'.
	(resultJson at:'Items') do:[:item | 
		resultCollection add: (mapper loadFrom:  item) ].
	
	^ resultCollection.
]

{ #category : #accessing }
DynamoDBTable >> tableName [
	^ tableName.
]

{ #category : #accessing }
DynamoDBTable >> tableName: anObject [
	tableName := anObject
]
