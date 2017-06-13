printing
xmlWriteOn: aStream
	super xmlWriteOn: aStream.
	(XMLWriter on: aStream)
		writeWith: [:writer | 
			(writer tag: 'InvalidationBatch')
				xmlns: 'http://cloudfront.amazonaws.com/doc/2016-09-29/';
				with:[ 
					writer raw: (self cfPathsXmlContentOn: aStream).
					writer tag: 'CallerReference' with: self cfTimeStampPrintString. ]].