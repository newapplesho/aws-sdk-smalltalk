accessing
awsConfig
	
	^ awsConfig ifNil:[ awsConfig := self defaultConfigClass default. ]