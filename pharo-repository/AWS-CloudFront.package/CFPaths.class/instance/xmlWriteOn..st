printing
xmlWriteOn: aStream
	(XMLWriter on: aStream)
		writeWith: [:writer | 
			(writer tag: 'Paths')
				with: [ 
					writer tag: 'Quantity' with: self pathCollections size asString.
					self xmlWriteContentOn: aStream. ] ].