private
convertDynamoDBJson: anObject
	| dict   |
	dict := (anObject respondsTo: #data)
		ifTrue:[ anObject perform:#data.]
		ifFalse:[ anObject ].
	
	^ self convert: dict