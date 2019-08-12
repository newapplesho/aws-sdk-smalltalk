Class {
	#name : #DynamoDBPutItem,
	#superclass : #DynamoDBOperations,
	#category : 'AWS-DynamoDB-Operations'
}

{ #category : #public }
DynamoDBPutItem >> conditionExpression: asString [
	self modifiers at:'ConditionExpression' put: asString.
]

{ #category : #public }
DynamoDBPutItem >> expressionAttributeValues: aJsonObject [
	self modifiers at:'ExpressionAttributeValues' put: aJsonObject.
]

{ #category : #public }
DynamoDBPutItem >> item: anJsonObject [
	self modifiers at:'Item' put: anJsonObject.
]

{ #category : #constants }
DynamoDBPutItem >> operationType [
	^ 'PutItem'.
]
