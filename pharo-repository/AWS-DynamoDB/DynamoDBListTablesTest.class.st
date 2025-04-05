"
A DyListTablesTest is a test class for testing the behavior of DyListTables
"
Class {
	#name : #DynamoDBListTablesTest,
	#superclass : #TestCase,
	#category : #'AWS-DynamoDB-Tests'
}

{ #category : #'tests-public' }
DynamoDBListTablesTest >> testLimit [
	| listTables |
	listTables := DynamoDBListTables new limit: 3.
	self assert: ((listTables limit) = '3').	

	listTables := DynamoDBListTables new limit: '3'.
	self assert: ((listTables limit) = '3').	
]
