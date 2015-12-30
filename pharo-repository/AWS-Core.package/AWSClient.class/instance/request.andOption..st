low-level-api
request: request  andOption: anObject
	| client url  hostUrl  keyUrl |
	
	client := self defaultHttpClient.

	awsConfig useSSL 
		ifTrue:[ client https].
	client request: request.
	hostUrl := request headers at:'host'  ifAbsent: [ '' ].
	keyUrl := request url asString.
	url := ZnUrl fromString: hostUrl,keyUrl defaultScheme: #https.  
	
	awsConfig useSSL 
		ifFalse:[ url scheme: #http ].
	client url: url.
	client execute.
		
	^ client response.
	