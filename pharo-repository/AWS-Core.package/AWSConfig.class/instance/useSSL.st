accessing
useSSL

	^self data at: #useSSL ifAbsent: [ self useSSL: true ]