"
I test DynamoDBMapper's encoding of Pharo values into DynamoDB attribute
values and back: the list / set / map split, number formatting, and the
values DynamoDB would reject (empty or mixed sets, NaN, Fractions).

Pure offline unit tests: no network (and no DynamoDB Local) is used.
"
Class {
	#name : #DynamoDBMapperTest,
	#superclass : #TestCase,
	#category : #'AWS-DynamoDB-Tests'
}

{ #category : #fixtures }
DynamoDBMapperTest >> encode: aValue [
	^ DynamoDBMapper new encodeValue: aValue
]

{ #category : #fixtures }
DynamoDBMapperTest >> roundTrip: aValue [
	| mapper |
	mapper := DynamoDBMapper new.
	^ mapper decodeValue: (mapper encodeValue: aValue)
]

{ #category : #'tests-collections' }
DynamoDBMapperTest >> testArrayEncodesAsList [
	| encoded |
	encoded := self encode: #(3 1 3).
	self assert: encoded keys asArray equals: #('L').
	self
		assert: ((encoded at: 'L') collect: [ :each | each at: 'N' ])
		equals: #('3' '1' '3')
]

{ #category : #'tests-collections' }
DynamoDBMapperTest >> testDictionaryEncodesAsMap [
	| encoded |
	encoded := self encode: (Dictionary newFrom: { 'city' -> 'Tokyo' }).
	self assert: encoded keys asArray equals: #('M').
	self assert: ((encoded at: 'M') at: 'city') equals: (Dictionary newFrom: { 'S' -> 'Tokyo' })
]

{ #category : #'tests-collections' }
DynamoDBMapperTest >> testEmptySetIsRejected [
	self should: [ self encode: Set new ] raise: AWSException
]

{ #category : #'tests-numbers' }
DynamoDBMapperTest >> testFloatEncodesAsPlainDecimal [
	self assert: ((self encode: 0.1) at: 'N') equals: '0.1'.
	self assert: ((self encode: 1.0e-10) at: 'N') equals: '0.0000000001'.
	self assert: ((self encode: 2.5e20) at: 'N') equals: '250000000000000000000'
]

{ #category : #'tests-numbers' }
DynamoDBMapperTest >> testFractionIsRejected [
	self should: [ self encode: 1 / 3 ] raise: AWSException
]

{ #category : #'tests-collections' }
DynamoDBMapperTest >> testListRoundTripKeepsOrderAndDuplicates [
	self assert: (self roundTrip: #(3 1 3)) equals: #(3 1 3)
]

{ #category : #'tests-collections' }
DynamoDBMapperTest >> testMapRoundTrip [
	| result |
	result := self roundTrip: (Dictionary newFrom: { 'tags' -> #('a') . 'n' -> 1 }).
	self assert: (result at: #tags) equals: #('a').
	self assert: (result at: #n) equals: 1
]

{ #category : #'tests-collections' }
DynamoDBMapperTest >> testMixedSetIsRejected [
	self should: [ self encode: (Set withAll: #(1 'a')) ] raise: AWSException
]

{ #category : #'tests-numbers' }
DynamoDBMapperTest >> testNaNAndInfinityAreRejected [
	self should: [ self encode: Float nan ] raise: AWSException.
	self should: [ self encode: Float infinity ] raise: AWSException
]

{ #category : #'tests-collections' }
DynamoDBMapperTest >> testNumberSetRoundTrip [
	self assert: (self roundTrip: (Set withAll: #(1 2 3))) equals: (Set withAll: #(1 2 3))
]

{ #category : #'tests-numbers' }
DynamoDBMapperTest >> testScaledDecimalKeepsItsScale [
	self assert: ((self encode: 1.50s2) at: 'N') equals: '1.50'
]

{ #category : #'tests-collections' }
DynamoDBMapperTest >> testStringSetRoundTrip [
	self
		assert: (self roundTrip: (Set withAll: #('b' 'a')))
		equals: (Set withAll: #('a' 'b'))
]
