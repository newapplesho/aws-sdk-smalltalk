instance creation
productionDynamoDBSetting
	| config |
	self initialize.
	config :=  self default.
	config accessKeyId:''.
	config secretKey:''. 