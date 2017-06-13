printing
xmlWriteContentOn: aStream
	(XMLWriter on: aStream)
		writeWith: [:writer | 
			(writer tag: 'Items')
				with: [ 
					self pathCollections do:[:v |
						writer tag: 'Path' with: v ] ] ].