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
