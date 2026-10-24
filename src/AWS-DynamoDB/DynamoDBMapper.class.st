"
I map between plain Pharo values and DynamoDB's typed attribute-value form.

`convert:` encodes a Dictionary of attributeName -> Pharo value into the wire
form `{ name -> { type -> value } }`; `loadFrom:` decodes that back into a
Dictionary keyed by symbols. Supported types:

  nil        <-> NULL          Boolean   <-> BOOL
  Number     <-> N             String    <-> S
  ByteArray  <-> B (base64)
  set of Numbers    <-> NS     set of Strings <-> SS
  set of ByteArrays <-> BS (base64)

A Pharo `ByteArray` (e.g. `#[1 2 3]`) is a single binary (B); an array of
numbers (e.g. `#(1 2 3)`) is a number set (NS). Maps (M) and lists (L) are not
supported yet. NeoJSON handles UTF-8 encoding on the wire, so no manual byte
conversion happens here.
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
DynamoDBMapper >> decodeValue: aTypedValue [
	| type value |
	type := aTypedValue keys anyOne.
	value := aTypedValue at: type.
	type = 'S' ifTrue: [ ^ value ].
	type = 'N' ifTrue: [ ^ value asNumber ].
	type = 'BOOL' ifTrue: [ ^ value ].
	type = 'NULL' ifTrue: [ ^ nil ].
	type = 'B' ifTrue: [ ^ value base64Decoded ].
	type = 'SS' ifTrue: [ ^ value ].
	type = 'NS' ifTrue: [ ^ value collect: [ :each | each asNumber ] ].
	type = 'BS' ifTrue: [ ^ value collect: [ :each | each base64Decoded ] ].
	^ value
]

{ #category : #encoding }
DynamoDBMapper >> encodeSet: aCollection [
	aCollection isEmpty ifTrue: [ ^ self typed: 'SS' value: #() ].
	(aCollection anyOne isKindOf: ByteArray) ifTrue: [
		^ self typed: 'BS' value: (aCollection collect: [ :each | each base64Encoded ]) asArray ].
	aCollection anyOne isNumber ifTrue: [
		^ self typed: 'NS' value: (aCollection collect: [ :each | each asString ]) asArray ].
	^ self typed: 'SS' value: (aCollection collect: [ :each | each asString ]) asArray
]

{ #category : #encoding }
DynamoDBMapper >> encodeValue: aValue [
	aValue isNil ifTrue: [ ^ self typed: 'NULL' value: true ].
	(aValue isKindOf: Boolean) ifTrue: [ ^ self typed: 'BOOL' value: aValue ].
	aValue isNumber ifTrue: [ ^ self typed: 'N' value: aValue asString ].
	aValue isString ifTrue: [ ^ self typed: 'S' value: aValue ].
	(aValue isKindOf: ByteArray) ifTrue: [ ^ self typed: 'B' value: aValue base64Encoded ].
	aValue isCollection ifTrue: [ ^ self encodeSet: aValue ].
	^ self typed: 'S' value: aValue asString
]

{ #category : #decoding }
DynamoDBMapper >> loadFrom: anItem [
	| result |
	result := Dictionary new.
	anItem keysAndValuesDo: [ :name :typedValue |
		result at: name asSymbol put: (self decodeValue: typedValue) ].
	^ result
]

{ #category : #private }
DynamoDBMapper >> typed: aTypeString value: aValue [
	^ Dictionary new
		at: aTypeString put: aValue;
		yourself
]
