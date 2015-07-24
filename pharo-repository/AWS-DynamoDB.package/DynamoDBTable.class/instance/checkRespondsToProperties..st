private
checkRespondsToProperties: anObject
	(anObject respondsTo: #properties)
		ifTrue:[ ^anObject perform: #properties. ].
 	(anObject respondsTo: #data)
		ifTrue:[ ^anObject perform: #data. ].
	^ anObject