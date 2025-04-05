Class {
	#name : #DynamoDBQuery,
	#superclass : #DynamoDBOperations,
	#category : #'AWS-DynamoDB-Operations'
}

{ #category : #public }
DynamoDBQuery >> attributesToGet: aStringArray [
	self modifiers at:'AttributesToGet' put: aStringArray
]

{ #category : #public }
DynamoDBQuery >> exclusiveStartKey: anObject [
	self modifiers at:'ExclusiveStartKey' put: anObject
]

{ #category : #public }
DynamoDBQuery >> expressionAttributeValues: aJsonObject [
	self modifiers at:'ExpressionAttributeValues' put: aJsonObject
]

{ #category : #public }
DynamoDBQuery >> keyConditionExpression: aString [
	self modifiers at:'KeyConditionExpression' put: aString
]

{ #category : #public }
DynamoDBQuery >> keyConditions: aJsonObject [
	self modifiers at:'KeyConditions' put: aJsonObject
]

{ #category : #public }
DynamoDBQuery >> limit: asInteger [
	self modifiers at:'Limit' put: asInteger
]

{ #category : #constants }
DynamoDBQuery >> operationType [
	^ 'Query'.
]

{ #category : #public }
DynamoDBQuery >> setSelect: aString [
	self modifiers at:'Select' put: aString
]

{ #category : #convenience }
DynamoDBQuery >> setSelectAllAttributes [
	self modifiers at:'Select' put: 'ALL_ATTRIBUTES'
]
