Extension { #name : #String }

{ #category : #'*AWS-Core' }
String >> convertUTF8 [
	^ self convertToEncoding: #utf8.
]

{ #category : #'*AWS-Core' }
String >> utf8ToPharo [
	^self convertFromWithConverter: UTF8TextConverter new
]
