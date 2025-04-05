Class {
	#name : #CFModel,
	#superclass : #Object,
	#category : #'AWS-CloudFront'
}

{ #category : #converting }
CFModel >> asXMLString [
	^ String streamContents: [:str |
		self xmlWriteOn: str ].
]

{ #category : #utility }
CFModel >> cfTimeStampPrintString [
	| dt t  |
	dt := DateAndTime now asUTC.
	t := (dt asTimeUTC print24 findTokens: '.')first copyReplaceAll:':' with:''.
	^ (dt asDate printFormat:#(3 2 1 0 1 1 2)),t.
]

{ #category : #printing }
CFModel >> xmlWriteContentOn: aStream [
]

{ #category : #printing }
CFModel >> xmlWriteOn: aStream [
	(XMLWriter on: aStream) xml
		version: '1.0';
		encoding: 'UTF-8';
		write.
	self xmlWriteContentOn: aStream.
]
