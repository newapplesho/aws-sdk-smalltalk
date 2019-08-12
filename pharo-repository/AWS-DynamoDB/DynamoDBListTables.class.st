Class {
	#name : #DynamoDBListTables,
	#superclass : #DynamoDBOperations,
	#category : 'AWS-DynamoDB-Operations'
}

{ #category : #public }
DynamoDBListTables >> exclusiveStartTableName: aString [
	self modifiers at: 'ExclusiveStartTableName' put: aString.
]

{ #category : #public }
DynamoDBListTables >> limit [
	^ self modifiers at: 'limit' ifAbsent: [].
]

{ #category : #public }
DynamoDBListTables >> limit: aNumberOrNumberString [
	| limitNumber |	
	limitNumber := aNumberOrNumberString isNumber 
		ifTrue:[ aNumberOrNumberString asString ]
		ifFalse:[ aNumberOrNumberString ].

	self modifiers at: 'limit' put: limitNumber.
]

{ #category : #constants }
DynamoDBListTables >> operationType [
	^ 'ListTables'.
]
