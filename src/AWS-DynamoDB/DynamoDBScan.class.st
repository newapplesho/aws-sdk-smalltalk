Class {
	#name : #DynamoDBScan,
	#superclass : #DynamoDBOperations,
	#category : #'AWS-DynamoDB-Operations'
}

{ #category : #public }
DynamoDBScan >> attributesToGet: aStringArray [
	self modifiers at:'AttributesToGet' put: aStringArray
]

{ #category : #public }
DynamoDBScan >> exclusiveStartKey: anObject [
	self modifiers at:'ExclusiveStartKey' put: anObject
]

{ #category : #public }
DynamoDBScan >> limit: asInteger [
	self modifiers at:'Limit' put: asInteger
]

{ #category : #constants }
DynamoDBScan >> operationType [
	^ 'Scan'.
]

{ #category : #public }
DynamoDBScan >> setSelect: aString [
	self modifiers at:'Select' put: aString
]

{ #category : #convenience }
DynamoDBScan >> setSelectAllAttributes [
	self modifiers at:'Select' put: 'ALL_ATTRIBUTES'
]
