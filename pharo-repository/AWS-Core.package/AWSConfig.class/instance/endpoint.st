accessing
endpoint

	^self data at: #endpoint ifAbsent: [ self endpoint: self hostUrl ]