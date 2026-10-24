"
A DynamoDBTableTest is a test class for testing the behavior of DynamoDBTable
"
Class {
	#name : #DynamoDBTableTest,
	#superclass : #TestCase,
	#category : #'AWS-DynamoDB-Tests'
}

{ #category : #running }
DynamoDBTableTest >> setUp [
	| dy operationName requestBody resp |
	
	AWSDynamoDBConfig initialize.
	AWSDynamoDBConfig developmentDynamoDBSetting.
	
	dy := DynamoDBRawClient new.
	operationName := #CreateTable.
	requestBody := '{
    "AttributeDefinitions": [
        {
            "AttributeName": "id",
            "AttributeType": "S"
        }
    ],
    "TableName": "dynamoDbTestTable",
    "KeySchema": [
        {
            "AttributeName": "id",
            "KeyType": "HASH"
        }
    ],
    "ProvisionedThroughput": {
        "ReadCapacityUnits": 10,
        "WriteCapacityUnits": 10
    }
}'.

	resp := dy operationName: operationName contents: requestBody.
	NeoJSONReader fromString: resp contents.

]

{ #category : #constants }
DynamoDBTableTest >> tableName [
	^ 'dynamoDbTestTable'
]

{ #category : #running }
DynamoDBTableTest >> tearDown [

	| operationName requestBody dy resp |
	
	dy := DynamoDBRawClient new.
	operationName := #DeleteTable.
	requestBody := NeoJSONWriter toString: (Dictionary new at:'TableName' put: self tableName; yourself).
	resp := dy operationName:  operationName contents: requestBody.
	NeoJSONReader fromString: resp contents.
]

{ #category : #'tests-api-deleteItem' }
DynamoDBTableTest >> testDeleteItem [
	| dynamoTable uuid result item1 item2 |
	
	uuid := UUID new asString.
	item1 := Dictionary newFrom: {'id' -> uuid }.
	dynamoTable := DynamoDBTable tableNamed: self tableName.
	
	dynamoTable putItem: item1.
	
	result := dynamoTable getItemBy: {#id -> uuid} asDictionary.
	self assert: result isNotEmpty.
	
	result := dynamoTable deleteItem: item1.
	self assert: result isEmpty.
	
	uuid := UUID new asString.
	item2 := Dictionary
		newFrom:
			{('id' -> uuid).
			('name' -> 'newapplesho')}.
	dynamoTable putItem: item2.
	
	result := dynamoTable getItemBy: {#id -> uuid} asDictionary.
	self assert: result isNotEmpty.
	
	result := dynamoTable deleteItem: {#id -> uuid} asDictionary.
	self assert: result isEmpty.
	
	result := dynamoTable getItemBy: {#id -> uuid} asDictionary.
	self assert: result isEmpty.
]

{ #category : #'tests-api-getItem' }
DynamoDBTableTest >> testDescribeTable [
	| dynamoTable  result |
	dynamoTable := DynamoDBTable tableNamed: self tableName.
	result := dynamoTable describeTable.
	result asString.
]

{ #category : #'tests-api-getItem' }
DynamoDBTableTest >> testGetItemBy [
	| dynamoDbTable  result dummy uuid |
	uuid := UUID new asString.
	dummy := Dictionary new.
	dummy at:'id' put: uuid.
	dummy at:'username' put: 'newapplesho'.
	dummy at: 'description' put: 'foobar'.
	dynamoDbTable := DynamoDBTable tableNamed: self tableName.
	result := dynamoDbTable putItem: dummy.
	self assert: (result isEmpty).
	
	result := dynamoDbTable getItemBy: {#id->uuid} asDictionary.
	self assert: ( (result at:#description) =  'foobar' ).
]

{ #category : #'tests-api-getItem' }
DynamoDBTableTest >> testGetItemByInitialisesMapperOnFreshTable [
	"getItemBy: is the first mapper-using call on this fresh table; it must
	 lazily create the mapper rather than fail on a nil ivar."
	| dynamoTable result |
	dynamoTable := DynamoDBTable tableNamed: self tableName.
	result := dynamoTable getItemBy: { #id -> UUID new asString } asDictionary.
	self assert: result isEmpty.
]

{ #category : #'tests-api-putItem' }
DynamoDBTableTest >> testNonAsciiStringRoundTrip [
	| dynamoTable uuid original result |
	uuid := UUID new asString.
	original := String withAll: {
		$c. $a. $f. $e.
		(Character value: 233).
		(Character value: 26085).
		(Character value: 26412) }.
	dynamoTable := DynamoDBTable tableNamed: self tableName.
	dynamoTable putItem: (Dictionary newFrom: { 'id' -> uuid. 'name' -> original }).
	result := dynamoTable getItemBy: { #id -> uuid } asDictionary.
	self assert: (result at: #name) equals: original.
]

{ #category : #'tests-types' }
DynamoDBTableTest >> putItem: aDictionary thenGet: aUuid [
	| table |
	table := DynamoDBTable tableNamed: self tableName.
	table putItem: aDictionary.
	^ table getItemBy: { #id -> aUuid } asDictionary
]

{ #category : #'tests-types' }
DynamoDBTableTest >> testNumberRoundTrip [
	| uuid result |
	uuid := UUID new asString.
	result := self putItem: (Dictionary newFrom: { 'id' -> uuid. 'age' -> 42 }) thenGet: uuid.
	self assert: (result at: #age) equals: 42.
]

{ #category : #'tests-types' }
DynamoDBTableTest >> testBooleanRoundTrip [
	| uuid result |
	uuid := UUID new asString.
	result := self
		putItem: (Dictionary newFrom: { 'id' -> uuid. 'active' -> true. 'deleted' -> false })
		thenGet: uuid.
	self assert: (result at: #active).
	self deny: (result at: #deleted).
]

{ #category : #'tests-types' }
DynamoDBTableTest >> testNullRoundTrip [
	| uuid result |
	uuid := UUID new asString.
	result := self putItem: (Dictionary newFrom: { 'id' -> uuid. 'note' -> nil }) thenGet: uuid.
	self assert: (result includesKey: #note).
	self assert: (result at: #note) isNil.
]

{ #category : #'tests-types' }
DynamoDBTableTest >> testNumberSetRoundTrip [
	| uuid result |
	uuid := UUID new asString.
	result := self
		putItem: (Dictionary newFrom: { 'id' -> uuid. 'scores' -> (Set withAll: #(3 1 2)) })
		thenGet: uuid.
	self assert: (result at: #scores) equals: (Set withAll: #(1 2 3)).
]

{ #category : #'tests-types' }
DynamoDBTableTest >> testStringSetRoundTrip [
	| uuid result |
	uuid := UUID new asString.
	result := self
		putItem: (Dictionary newFrom: { 'id' -> uuid. 'tags' -> (Set withAll: #('b' 'a')) })
		thenGet: uuid.
	self assert: (result at: #tags) equals: (Set withAll: #('a' 'b')).
]

{ #category : #'tests-types' }
DynamoDBTableTest >> testListRoundTrip [
	| uuid result |
	uuid := UUID new asString.
	result := self
		putItem: (Dictionary newFrom: { 'id' -> uuid. 'steps' -> #(3 'a' 3 true) })
		thenGet: uuid.
	self assert: (result at: #steps) equals: #(3 'a' 3 true).
]

{ #category : #'tests-types' }
DynamoDBTableTest >> testMapRoundTrip [
	| uuid address result |
	uuid := UUID new asString.
	address := Dictionary newFrom: { 'city' -> 'Tokyo'. 'zip' -> 1000001 }.
	result := self
		putItem: (Dictionary newFrom: { 'id' -> uuid. 'address' -> address })
		thenGet: uuid.
	self assert: ((result at: #address) at: #city) equals: 'Tokyo'.
	self assert: ((result at: #address) at: #zip) equals: 1000001.
]

{ #category : #'tests-types' }
DynamoDBTableTest >> testBinaryRoundTrip [
	| uuid original result |
	uuid := UUID new asString.
	original := #[1 2 3 255 0 128].
	result := self putItem: (Dictionary newFrom: { 'id' -> uuid. 'blob' -> original }) thenGet: uuid.
	self assert: (result at: #blob) equals: original.
]

{ #category : #'tests-api-listTables' }
DynamoDBTableTest >> testListTables [
	| dynamoTable  result |
	dynamoTable := DynamoDBTable tableNamed: self tableName.
	result := dynamoTable listTables.
	self assertCollection:( result at:'TableNames' ) equals: ( Array with: self tableName  ).
]

{ #category : #'tests-api-putItem' }
DynamoDBTableTest >> testPutItem [
	| dynamoDbTable  result  uuid item |
	uuid := UUID new asString.
	item := Dictionary newFrom: {'id'-> uuid.}.
	dynamoDbTable := DynamoDBTable tableNamed: self tableName.
	result := dynamoDbTable putItem: item.
	self assert: (result isEmpty).
	
	uuid := UUID new asString.
	item := Dictionary newFrom: {'id'-> uuid. 'name'-> 'newapplesho' }.
	dynamoDbTable := DynamoDBTable tableNamed: self tableName.
	result := dynamoDbTable putItem: item.
	self assert: (result isEmpty).
]

{ #category : #'tests-api-putItem' }
DynamoDBTableTest >> testPutItemConditionExpressionString [
	| dynamoDbTable  result uuid dummy1 dummy2 dummy3 dummy4 response enu |
	uuid := UUID new asString.
	dummy1 := {'id'->uuid. 'username'->'newapplesho'. 'description'->'foobar' } asDictionary.
	dynamoDbTable := DynamoDBTable tableNamed: self tableName.
	result := dynamoDbTable putItem: dummy1.
	self assert: (result isEmpty).
	
	dummy2 := {'id'->uuid. 'username'->'newapplesho'. 'description'->'foobar' } asDictionary.
	dynamoDbTable := DynamoDBTable tableNamed: self tableName.
	dynamoDbTable putItem:  dummy2 conditionExpressionString: 'attribute_not_exists(id)'.
	
	response := dynamoDbTable response.
	self assert: (response status = 400).
	
	dummy3 := {'id'->uuid. 'username'->'newapplesho'. 'description'->'foobar' } asDictionary.
	dynamoDbTable := DynamoDBTable tableNamed: self tableName.
	dynamoDbTable putItem: dummy3 conditionExpressionString: 'attribute_not_exists(id)'.
	
	response := dynamoDbTable response.
	self assert: (response status = 400).
	
	uuid := UUID new asString.
	dummy4 := {'id'->uuid. 'username'->'newapplesho'. 'description'->'foobar' } asDictionary.
	dynamoDbTable := DynamoDBTable tableNamed: self tableName.
	dynamoDbTable putItem: dummy4 conditionExpressionString: 'attribute_not_exists(id)'.
	
	response := dynamoDbTable response.
	self assert: (response status = 200).
	
	dynamoDbTable numberOfResultsToFetch: 5.
	enu := dynamoDbTable enumerator.
	[enu atEnd] whileFalse: [ enu fetchNextUnits. ].
	self assert: ( enu resultStream contents size = 2 ) .
	

]

{ #category : #'test-api-query' }
DynamoDBTableTest >> testQueryKeyConditionExpressionStringBinding [
	| dynamoTable  result uuid dummy |
	uuid := UUID new asString.
	dummy := {'id'->uuid. 'username'->'newapplesho'. 'description'->'foobar' } asDictionary.
	dynamoTable := DynamoDBTable tableNamed: self tableName.
	result := dynamoTable putItem: dummy.
	self assert: (result isEmpty).
	
	dynamoTable := DynamoDBTable tableNamed: self tableName.
	result := dynamoTable queryKeyConditionExpressionString: 'id = :id' binding: (Dictionary newFrom: {':id'->uuid}).
	self assert:( result size = 1).
	
	self assert:( (result anyOne at: #username)= 'newapplesho' ).
]

{ #category : #'tests-api-scan' }
DynamoDBTableTest >> testScanAll [

	| dynamoDbTable  enu counter |
	
	counter := 0.
	dynamoDbTable := DynamoDBTable tableNamed: self tableName.	

	20 timesRepeat: [ 
		dynamoDbTable putItem: {'id'->UUID new asString} asDictionary. ].

	dynamoDbTable numberOfResultsToFetch: 5.
	enu := dynamoDbTable enumerator.
	[enu atEnd] whileFalse: [
		| result |
		result := enu fetchNextUnits.
		counter := counter + 1.
	].
	self assert: ( enu resultStream contents size = 20 ) .
	self assert: (counter = 4). 
]
