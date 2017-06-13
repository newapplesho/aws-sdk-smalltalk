accessing
hostUrl
	^self at: #hostUrl ifAbsent: [ self hostUrl: self serviceName asLowercase,'.', self regionName, '.amazonaws.com'. ]