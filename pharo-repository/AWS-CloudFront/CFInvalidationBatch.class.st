Class {
	#name : #CFInvalidationBatch,
	#superclass : #CFModel,
	#instVars : [
		'paths'
	],
	#category : #'AWS-CloudFront'
}

{ #category : #convenience }
CFInvalidationBatch >> addPath: aString [
	self paths addPath: aString
]

{ #category : #printing }
CFInvalidationBatch >> cfPathsXmlContentOn: aStream [
	^ self paths asXMLString.
]

{ #category : #accessing }
CFInvalidationBatch >> paths [
	^ paths ifNil:[ paths := CFPaths new ] .
]

{ #category : #accessing }
CFInvalidationBatch >> paths: anObject [
	paths := anObject
]

{ #category : #printing }
CFInvalidationBatch >> xmlWriteOn: aStream [
	super xmlWriteOn: aStream.
	(XMLWriter on: aStream)
		writeWith: [:writer | 
			(writer tag: 'InvalidationBatch')
				xmlns: 'http://cloudfront.amazonaws.com/doc/2016-09-29/';
				with:[ 
					writer raw: (self cfPathsXmlContentOn: aStream).
					writer tag: 'CallerReference' with: self cfTimeStampPrintString. ]].
]
