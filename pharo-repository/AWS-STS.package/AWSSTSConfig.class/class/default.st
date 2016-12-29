instance creation
default
	default ifNil: [ default := self defaultSTSSetting ].
	^default