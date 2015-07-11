accessing
hostUrl
	
	^ self data at: #hostUrl ifAbsent: [
		
		(self regionName = 'us-east-1')
			ifTrue:[ 
				"If you create a client by specifying the US Standard region, it uses the following endpoint to communicate with Amazon S3."
				self hostUrl: self serviceName asLowercase, '.amazonaws.com'. ]
			ifFalse:[ 
				"If you create a client by specifying any other AWS region, each of these regions maps to the region-specific endpoint"
				self hostUrl: self serviceName asLowercase,'-', self regionName, '.amazonaws.com'.  ].	
	]