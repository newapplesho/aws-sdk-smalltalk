Class {
	#name : #DynamoDBGetItem,
	#superclass : #DynamoDBOperations,
	#category : 'AWS-DynamoDB-Operations'
}

{ #category : #public }
DynamoDBGetItem >> consistentRead: aBoolean [
	self modifiers at:'ConsistentRead' put: aBoolean
]

{ #category : #public }
DynamoDBGetItem >> key: aJsonObject [
	self modifiers at:'Key' put: aJsonObject
]

{ #category : #constants }
DynamoDBGetItem >> operationType [
	^ 'GetItem'.
]
