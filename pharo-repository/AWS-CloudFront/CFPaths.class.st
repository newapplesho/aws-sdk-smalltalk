Class {
	#name : #CFPaths,
	#superclass : #CFModel,
	#instVars : [
		'pathCollections'
	],
	#category : 'AWS-CloudFront'
}

{ #category : #accessing }
CFPaths >> addPath: aString [
	self pathCollections add: aString.
]

{ #category : #initialization }
CFPaths >> initialize [
	super initialize.
	pathCollections := OrderedCollection new.
]

{ #category : #accessing }
CFPaths >> pathCollections [
	^ pathCollections
]

{ #category : #accessing }
CFPaths >> pathCollections: anObject [
	pathCollections := anObject
]

{ #category : #printing }
CFPaths >> xmlWriteContentOn: aStream [
	(XMLWriter on: aStream)
		writeWith: [:writer | 
			(writer tag: 'Items')
				with: [ 
					self pathCollections do:[:v |
						writer tag: 'Path' with: v ] ] ].
]

{ #category : #printing }
CFPaths >> xmlWriteOn: aStream [
	(XMLWriter on: aStream)
		writeWith: [:writer | 
			(writer tag: 'Paths')
				with: [ 
					writer tag: 'Quantity' with: self pathCollections size asString.
					self xmlWriteContentOn: aStream. ] ].
]
