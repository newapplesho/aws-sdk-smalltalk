"
A DynamoDBRawClientTest is a test class for testing the behavior of DynamoDBRawClient
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
	Json readFrom: (resp contents) readStream.

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
	requestBody := JsonObject new at:'TableName' put: self tableName; asJsonString .
	resp := dy operationName:  operationName contents: requestBody.
	Json readFrom: (resp contents) readStream.
]

{ #category : #'tests-low-level-api' }
DynamoDBRawClientTest >> testOperationNameContents [

	| dy operationName  resp result requestJson |
	dy := DynamoDBRawClient new.
	operationName := #ListTables.
	requestJson := DynamoDBListTables new asJsonString.
	resp := dy operationName:  operationName contents: requestJson.
	result := Json readFrom: (resp contents) readStream.
	
	self assertCollection:( result at:'TableNames' ) equals: ( Array with: self tableName  ).
]
