accessing
hostUrl
	
	^ hostUrl ifNil:[ 
		
		(regionName = 'us-east-1')
			ifTrue:[ 
				"If you create a client by specifying the US Standard region, it uses the following endpoint to communicate with Amazon S3."
				hostUrl := serviceName asLowercase, '.amazonaws.com'. ]
			ifFalse:[ 
				"If you create a client by specifying any other AWS region, each of these regions maps to the region-specific endpoint"
				hostUrl := serviceName asLowercase,'-', regionName, '.amazonaws.com'.  ].	
	]