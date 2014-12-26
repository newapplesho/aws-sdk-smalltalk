private
loadItemString: anObject
	| jsonObject dict |
	jsonObject := Json readFrom: anObject readStream.

	dict := Dictionary new.
	jsonObject keys do:[:k | | value |
		value := jsonObject at: k .
		self  loadType: value  key: k on: dict.].
	^ dict
	