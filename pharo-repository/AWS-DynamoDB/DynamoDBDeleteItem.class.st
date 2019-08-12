Class {
	#name : #DynamoDBDeleteItem,
	#superclass : #DynamoDBOperations,
	#category : 'AWS-DynamoDB-Operations'
}

{ #category : #public }
DynamoDBDeleteItem >> expected: anJsonObject [
	self modifiers at:'Expected' put: anJsonObject.
]

{ #category : #public }
DynamoDBDeleteItem >> key: anJsonObject [
	self modifiers at:'Key' put: anJsonObject.
]

{ #category : #constants }
DynamoDBDeleteItem >> operationType [
	^ 'DeleteItem'.
]

{ #category : #public }
DynamoDBDeleteItem >> returnValues: anJsonObject [
	self modifiers at:'ReturnValues' put: anJsonObject.
]
