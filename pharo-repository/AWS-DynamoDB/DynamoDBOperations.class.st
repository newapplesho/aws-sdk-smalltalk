Class {
	#name : #DynamoDBOperations,
	#superclass : #Object,
	#instVars : [
		'modifiers'
	],
	#category : 'AWS-DynamoDB-Operations'
}

{ #category : #printing }
DynamoDBOperations >> jsonWriteOn: aStream [
	self modifiers jsonWriteOn: aStream.
]

{ #category : #accessing }
DynamoDBOperations >> modifiers [
	^ modifiers ifNil: [modifiers := JsonObject new ]
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
