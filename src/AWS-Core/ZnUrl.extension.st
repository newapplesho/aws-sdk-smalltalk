Extension { #name : #ZnUrl }

{ #category : #'*AWS-Core' }
ZnUrl >> awsEncodeCanonicalUri [
	^ String
		streamContents: [ :stream | 
			self hasPath
				ifFalse: [ stream nextPut: $/ ]
				ifTrue: [ segments
						do: [ :each | 
							stream nextPut: $/.
							each == #/
								ifFalse: [ self encode: each on: stream ] ] ] ]
]
