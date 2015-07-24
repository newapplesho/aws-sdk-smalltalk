accessing
useSSL

	^self at: #useSSL ifAbsent: [ self useSSL: true ]