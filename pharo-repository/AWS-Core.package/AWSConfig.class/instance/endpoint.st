accessing
endpoint
	^self  at: #endpoint ifAbsent: [ self endpoint: self hostUrl ]