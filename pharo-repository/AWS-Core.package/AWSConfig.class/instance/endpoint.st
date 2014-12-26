accessing
endpoint
	
	^ endpoint  ifNil:[ endpoint := self hostUrl ].