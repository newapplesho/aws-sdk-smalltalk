accessing
hostUrl
	
	^ hostUrl ifNil:[ hostUrl := serviceName asLowercase,'.', regionName, '.amazonaws.com'. ]