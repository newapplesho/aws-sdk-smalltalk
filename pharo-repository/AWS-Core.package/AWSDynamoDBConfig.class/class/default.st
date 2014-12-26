instance creation
default
	default ifNil: [ default := self defaultDynamoDBSetting ].
	^default