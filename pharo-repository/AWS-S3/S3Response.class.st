Class {
	#name : #S3Response,
	#superclass : #AWSResponse,
	#category : 'AWS-S3'
}

{ #category : #accessing }
S3Response >> value [
	| result exception |
	
	result := (self response hasEntity and:[ self response contentType sub = 'xml'])
					ifTrue:[ XMLDOMParser parse: self response contents readStream ]
				ifFalse:[ self response contents ].
	self response isSuccess 
		ifTrue:[ ^ result ].
	
	exception := self defaultExceptionClass new.
	exception properties: result.
	exception messageText: (result firstNode contentStringAt:'Code').
	exception signal.
]
