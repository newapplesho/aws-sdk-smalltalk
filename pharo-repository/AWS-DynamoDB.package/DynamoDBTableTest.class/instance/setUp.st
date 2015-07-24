running
setUp
	| dy operationName requestBody resp |
	
	"AWSDynamoDBConfig initialize."
	"AWSDynamoDBConfig developmentDynamoDBSetting."
	
	dy := DynamoDBRawClient new.
	operationName := #CreateTable.
	requestBody := '{
    "AttributeDefinitions": [
        {
            "AttributeName": "id",
            "AttributeType": "S"
        }
    ],
    "TableName": "dmodeltest",
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

	resp := dy operationName:  operationName entityContents: requestBody.
	Json readFrom: (resp contents) readStream.
