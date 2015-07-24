accessing
tableName
	^ tableName ifNil:[ tableName := self class instanceSide name asLowercase ].