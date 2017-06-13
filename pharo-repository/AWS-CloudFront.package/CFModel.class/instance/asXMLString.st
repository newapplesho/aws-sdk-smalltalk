converting
asXMLString
	^ String streamContents: [:str |
		self xmlWriteOn: str ].