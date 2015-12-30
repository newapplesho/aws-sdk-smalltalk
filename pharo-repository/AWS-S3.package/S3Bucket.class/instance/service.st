accessing
service
	^ service ifNil:[ service := AWSS3 new].