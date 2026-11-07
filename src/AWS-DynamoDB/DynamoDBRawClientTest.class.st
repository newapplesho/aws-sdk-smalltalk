"
I am a live integration test for DynamoDBRawClient. I send requests to
DynamoDB Local instead of real AWS.

I need DynamoDB Local listening on localhost:8000. Start it with
`make ddb-up` (see docker-compose.yml). If DynamoDB Local is not running, my
tests fail with connection errors. In CI, the `integration` job starts
DynamoDB Local and runs me; the `build` job does not run me.

My setUp calls `AWSDynamoDBConfig developmentDynamoDBSetting`, which points
the shared default config at localhost:8000, and creates the table
dynamoDbTestTable. My tearDown deletes that table. testOperationNameContents
expects dynamoDbTestTable to be the only table, so DynamoDB Local must not
hold any other table while I run.
"
Class {
	#name : #DynamoDBRawClientTest,
	#superclass : #TestCase,
	#category : #'AWS-DynamoDB-Tests'
}

{ #category : #running }
DynamoDBRawClientTest >> setUp [
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

	resp := dy operationName:  operationName contents: requestBody.
	NeoJSONReader fromString: resp contents.

]

{ #category : #private }
DynamoDBRawClientTest >> tableName [
	^ 'dynamoDbTestTable'
]

{ #category : #running }
DynamoDBRawClientTest >> tearDown [

	| operationName requestBody dy resp |
	
	dy := DynamoDBRawClient new.
	operationName := #DeleteTable.
	requestBody := NeoJSONWriter toString: (Dictionary new at:'TableName' put: self tableName; yourself).
	resp := dy operationName:  operationName contents: requestBody.
	NeoJSONReader fromString: resp contents.
]

{ #category : #'tests-low-level-api' }
DynamoDBRawClientTest >> testOperationNameContents [

	| dy operationName  resp result requestJson |
	dy := DynamoDBRawClient new.
	operationName := #ListTables.
	requestJson := NeoJSONWriter toString: DynamoDBListTables new modifiers.
	resp := dy operationName:  operationName contents: requestJson.
	result := NeoJSONReader fromString: resp contents.
	
	self assertCollection:( result at:'TableNames' ) equals: ( Array with: self tableName  ).
]
