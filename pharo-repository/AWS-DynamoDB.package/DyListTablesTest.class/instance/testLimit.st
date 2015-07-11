tests-public
testLimit
	| listTables |
	listTables := DyListTables new limit: 3.
	self assert: ((listTables at:'limit') = '3').	

	listTables := DyListTables new limit: '3'.
	self assert: ((listTables at:'limit') = '3').	