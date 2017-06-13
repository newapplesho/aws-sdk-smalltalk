printing
xmlWriteOn: aStream
	(XMLWriter on: aStream) xml
		version: '1.0';
		encoding: 'UTF-8';
		write.
	self xmlWriteContentOn: aStream.