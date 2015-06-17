instance creation
default
	default ifNil: [ default := self defaultS3Setting ].
	^default