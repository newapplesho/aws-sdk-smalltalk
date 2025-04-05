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
	Json readFrom: (resp contents) readStream.

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
	requestBody := JsonObject new at:'TableName' put: self tableName; asJsonString .
	resp := dy operationName:  operationName contents: requestBody.
	Json readFrom: (resp contents) readStream.
]

{ #category : #'tests-api-deleteItem' }
DynamoDBTableTest >> testDeleteItem [
	| dynamoTable uuid result item1 item2 |
	
	uuid := UUID new primMakeUUID hex.
	item1 := Dictionary newFrom: {'id' -> uuid }.
	dynamoTable := DynamoDBTable tableNamed: self tableName.
	
	dynamoTable putItem: item1.
	
	result := dynamoTable getItemBy: {#id -> uuid} asDictionary.
	self assert: result isNotEmpty.
	
	result := dynamoTable deleteItem: item1.
	self assert: result isEmpty.
	
	uuid := UUID new primMakeUUID hex.
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
	uuid := UUID new primMakeUUID hex.
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
	uuid := UUID new primMakeUUID hex.
	item := Dictionary newFrom: {'id'-> uuid.}.
	dynamoDbTable := DynamoDBTable tableNamed: self tableName.
	result := dynamoDbTable putItem: item.
	self assert: (result isEmpty).
	
	uuid := UUID new primMakeUUID hex.
	item := Dictionary newFrom: {'id'-> uuid. 'name'-> 'newapplesho' }.
	dynamoDbTable := DynamoDBTable tableNamed: self tableName.
	result := dynamoDbTable putItem: item.
	self assert: (result isEmpty).
]

{ #category : #'tests-api-putItem' }
DynamoDBTableTest >> testPutItemConditionExpressionString [
	| dynamoDbTable  result uuid dummy1 dummy2 dummy3 dummy4 response enu |
	uuid := UUID new primMakeUUID hex.
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
	
	uuid := UUID new primMakeUUID hex.
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
	uuid := UUID new primMakeUUID hex.
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
		dynamoDbTable putItem: {'id'->UUID new primMakeUUID hex} asDictionary. ].

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
