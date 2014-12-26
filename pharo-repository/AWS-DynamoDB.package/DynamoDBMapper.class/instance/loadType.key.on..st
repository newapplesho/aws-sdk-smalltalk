private
loadType: anObject key: aSymbol on: aDictionaryObject

	(anObject keys includes:'N') ifTrue:[ ^ aDictionaryObject at: aSymbol asSymbol put:  (anObject at:'N') asNumber ].
	
	(anObject keys includes:'S')  ifTrue:[  ^ aDictionaryObject at: aSymbol asSymbol put: (anObject at:'S') utf8ToPharo ].
	
	(#('NS' 'SS' 'BS') includesAll: anObject keys  )
		 ifTrue:[ 
			
			(anObject keys includes:'NS')   ifTrue:[ 
				| c |
				c := (anObject at:'NS')  collect:[:v | v asNumber ].
				^ aDictionaryObject at: aSymbol asSymbol put: c ].
			
			(anObject keys includes:'SS') ifTrue:[ 
				| c |
				c := (anObject at:'NS')  collect:[:v | v utf8ToPharo ].
				^ aDictionaryObject at: aSymbol asSymbol put:  c ].
			
			(anObject keys includes:'BS')  ifTrue:[ 
				| c |
				c := anObject collect:[:v | v asString ].
				^ aDictionaryObject at: aSymbol asSymbol put: c. ].
		 ].
	^ aDictionaryObject at: aSymbol asSymbol put: (anObject at:'B').
		