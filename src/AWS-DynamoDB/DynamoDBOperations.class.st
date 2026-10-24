Class {
	#name : #DynamoDBOperations,
	#superclass : #Object,
	#instVars : [
		'modifiers'
	],
	#category : #'AWS-DynamoDB-Operations'
}

{ #category : #accessing }
DynamoDBOperations >> modifiers [
	^ modifiers ifNil: [modifiers := Dictionary new ]
]

{ #category : #accessing }
DynamoDBOperations >> modifiers: anObject [
	modifiers := anObject
]

{ #category : #constants }
DynamoDBOperations >> operationName [
	^ self operationType
]

{ #category : #constants }
DynamoDBOperations >> operationType [
	self subclassResponsibility 
]

{ #category : #accessing }
DynamoDBOperations >> tableName: tableNamStringOrSymbol [
	self modifiers at:'TableName' put: tableNamStringOrSymbol
]
