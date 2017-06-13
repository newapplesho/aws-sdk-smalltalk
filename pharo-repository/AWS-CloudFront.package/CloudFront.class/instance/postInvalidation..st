actions
postInvalidation: aXMLStringOrCFInvalidationBatch
	| amzDatePrintString request requestBody |
	requestBody  := aXMLStringOrCFInvalidationBatch.
	requestBody class = CFInvalidationBatch 
		ifTrue: [ requestBody := aXMLStringOrCFInvalidationBatch asXMLString ].
	amzDatePrintString := self amzDatePrintString.
	request := ZnRequest empty.
	request method: #POST.
	request url: self invalidationUri.
	request
		entity:
			(ZnEntity
				readBinaryFrom: requestBody asByteArray readStream
				usingType: ZnMimeType textXML
				andLength: requestBody byteSize).
	request headers at: 'host' put: self awsConfig endpoint.
	request headers at: 'x-amz-date' put: amzDatePrintString.
	request
		setAuthorization: (SignatureV4 creatAuthorization: request andConfig: self awsConfig andDateTime: amzDatePrintString).
	^ self client request: request andOption: nil