instance creation
default
	default ifNil: [ default := self defaultSNSSetting ].
	^default