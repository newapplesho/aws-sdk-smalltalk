instance creation
default
	default ifNil: [ default := self defaultCFSetting ].
	^default