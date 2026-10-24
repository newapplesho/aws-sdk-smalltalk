"
I map between plain Pharo values and DynamoDB's typed attribute-value form.

`convert:` encodes a Dictionary of attributeName -> Pharo value into the wire
form `{ name -> { type -> value } }`; `loadFrom:` decodes that back into a
Dictionary keyed by symbols. Supported types (the same split between lists,
sets and maps as the official AWS SDKs):

  nil        <-> NULL          Boolean   <-> BOOL
  Number     <-> N             String    <-> S
  ByteArray  <-> B (base64)    Dictionary <-> M
  Array / OrderedCollection (any non-Set collection) <-> L
  Set of Numbers    <-> NS     Set of Strings <-> SS
  Set of ByteArrays <-> BS (base64)

Numbers are sent as plain decimal strings: Integers as-is, Floats in their
shortest exact decimal form, ScaledDecimals with their scale. NaN, Infinity
and Fractions are rejected, as are empty Sets and Sets of mixed or
unsupported types (DynamoDB would reject them too). A whole-number Float
(e.g. 2.0) is sent as '2' and so reads back as an Integer.

NeoJSON handles UTF-8 encoding on the wire, so no manual byte conversion
happens here.
"
Class {
	#name : #DynamoDBMapper,
	#superclass : #Object,
	#category : #'AWS-DynamoDB'
}

{ #category : #encoding }
DynamoDBMapper >> convert: aDictionary [
	| item |
	item := Dictionary new.
	aDictionary keysAndValuesDo: [ :name :value |
		item at: name asString put: (self encodeValue: value) ].
	^ item
]

{ #category : #decoding }
DynamoDBMapper >> decodeType: aTypeString collection: aValue [
	aTypeString = 'SS' ifTrue: [ ^ aValue asSet ].
	aTypeString = 'NS' ifTrue: [ ^ (aValue collect: [ :each | each asNumber ]) asSet ].
	aTypeString = 'BS' ifTrue: [ ^ (aValue collect: [ :each | each base64Decoded ]) asSet ].
	aTypeString = 'L' ifTrue: [ ^ aValue collect: [ :each | self decodeValue: each ] ].
	aTypeString = 'M' ifTrue: [ ^ self loadFrom: aValue ].
	^ aValue
]

{ #category : #decoding }
DynamoDBMapper >> decodeValue: aTypedValue [
	| type value |
	type := aTypedValue keys anyOne.
	value := aTypedValue at: type.
	type = 'S' ifTrue: [ ^ value ].
	type = 'N' ifTrue: [ ^ value asNumber ].
	type = 'BOOL' ifTrue: [ ^ value ].
	type = 'NULL' ifTrue: [ ^ nil ].
	type = 'B' ifTrue: [ ^ value base64Decoded ].
	^ self decodeType: type collection: value
]

{ #category : #encoding }
DynamoDBMapper >> encodeList: aCollection [
	^ self
		typed: 'L'
		value: (aCollection asArray collect: [ :each | self encodeValue: each ])
]

{ #category : #encoding }
DynamoDBMapper >> encodeSet: aSet [
	aSet isEmpty ifTrue: [ ^ AWSException signal: 'DynamoDB does not allow an empty set' ].
	(aSet allSatisfy: [ :each | each isKindOf: ByteArray ]) ifTrue: [
		^ self typed: 'BS' value: (aSet asArray collect: [ :each | each base64Encoded ]) ].
	(aSet allSatisfy: [ :each | each isNumber ]) ifTrue: [
		^ self
			typed: 'NS'
			value: (self uniqueStrings: aSet with: [ :each | self numberString: each ]) ].
	(aSet allSatisfy: [ :each | each isString ]) ifTrue: [
		^ self typed: 'SS' value: (self uniqueStrings: aSet with: [ :each | each asString ]) ].
	^ AWSException signal:
		'A DynamoDB set must contain only Numbers, only Strings or only ByteArrays'
]

{ #category : #encoding }
DynamoDBMapper >> encodeValue: aValue [
	aValue ifNil: [ ^ self typed: 'NULL' value: true ].
	(aValue isKindOf: Boolean) ifTrue: [ ^ self typed: 'BOOL' value: aValue ].
	aValue isNumber ifTrue: [ ^ self typed: 'N' value: (self numberString: aValue) ].
	aValue isString ifTrue: [ ^ self typed: 'S' value: aValue asString ].
	(aValue isKindOf: ByteArray) ifTrue: [ ^ self typed: 'B' value: aValue base64Encoded ].
	aValue isDictionary ifTrue: [ ^ self typed: 'M' value: (self convert: aValue) ].
	(aValue isKindOf: Set) ifTrue: [ ^ self encodeSet: aValue ].
	aValue isCollection ifTrue: [ ^ self encodeList: aValue ].
	^ self typed: 'S' value: aValue asString
]

{ #category : #encoding }
DynamoDBMapper >> floatString: aFloat [
	| fraction places |
	(aFloat isNaN or: [ aFloat isInfinite ]) ifTrue: [
		^ AWSException signal: 'NaN and Infinity cannot be stored as DynamoDB numbers' ].
	fraction := aFloat asMinimalDecimalFraction.
	fraction isInteger ifTrue: [ ^ fraction printString ].
	places := 1.
	[ (10 raisedTo: places) \\ fraction denominator = 0 ]
		whileFalse: [ places := places + 1 ].
	^ fraction printShowingDecimalPlaces: places
]

{ #category : #decoding }
DynamoDBMapper >> loadFrom: anItem [
	| result |
	result := Dictionary new.
	anItem keysAndValuesDo: [ :name :typedValue |
		result at: name asSymbol put: (self decodeValue: typedValue) ].
	^ result
]

{ #category : #encoding }
DynamoDBMapper >> numberString: aNumber [
	aNumber isInteger ifTrue: [ ^ aNumber printString ].
	aNumber isFloat ifTrue: [ ^ self floatString: aNumber ].
	(aNumber isKindOf: ScaledDecimal) ifTrue: [
		^ aNumber printShowingDecimalPlaces: aNumber scale ].
	^ AWSException signal:
		'A DynamoDB number must be an Integer, Float or ScaledDecimal, not '
		, aNumber class name
]

{ #category : #private }
DynamoDBMapper >> typed: aTypeString value: aValue [
	^ Dictionary new
		at: aTypeString put: aValue;
		yourself
]

{ #category : #private }
DynamoDBMapper >> uniqueStrings: aSet with: aBlock [
	^ (aSet collect: aBlock) asSet asArray
]
