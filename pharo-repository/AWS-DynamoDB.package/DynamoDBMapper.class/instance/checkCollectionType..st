private
checkCollectionType: anObject
	anObject isEmpty ifTrue:[ ^ 'SS' ].
	anObject first isNumber ifTrue:[ ^ 'NS' ].
	anObject first isString ifTrue:[ ^ 'SS' ].
	 ^ 'BS'.