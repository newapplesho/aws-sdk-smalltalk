private
checkRespondsToProperties: anObject
	(anObject respondsTo: #properties)
		ifTrue:[ ^anObject perform: #properties. ].
	^ anObject