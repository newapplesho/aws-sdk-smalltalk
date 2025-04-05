Class {
	#name : #DynamoDBDescribeTable,
	#superclass : #DynamoDBOperations,
	#category : #'AWS-DynamoDB-Operations'
}

{ #category : #constants }
DynamoDBDescribeTable >> operationType [
	^ 'DescribeTable'.
]
