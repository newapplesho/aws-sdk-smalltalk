accessing
resultStream
	^ resultStream ifNil: [resultStream := WriteStream on: OrderedCollection new]