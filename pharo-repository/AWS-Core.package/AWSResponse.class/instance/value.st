accessing
value
	| responseJson exception |
	responseJson := Json readFrom: self response contents readStream.
	self response isSuccess 
		ifTrue:[ ^ responseJson ].
	
	exception := self defaultExceptionClass new.
	exception properties: responseJson.
	exception messageText: responseJson message.
	exception signal.