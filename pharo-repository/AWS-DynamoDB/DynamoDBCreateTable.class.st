Class {
	#name : #DynamoDBCreateTable,
	#superclass : #DynamoDBOperations,
	#category : 'AWS-DynamoDB-Operations'
}

{ #category : #constants }
DynamoDBCreateTable >> operationType [
	^ 'CreateTable'.
]
