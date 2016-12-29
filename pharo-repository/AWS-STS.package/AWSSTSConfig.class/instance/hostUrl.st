accessing
hostUrl
	^ self at: #hostUrl ifAbsent: [ self hostUrl: self serviceName asLowercase , '.amazonaws.com' ]