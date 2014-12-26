instance creation
developmentDynamoDBSetting
	| config |
	self initialize.
	config :=  self default.
	"sample access key and secret key"
	config accessKeyId:'AKIDEXAMPLE'.
	config secretKey:'wJalrXUtnFEMI/K7MDENG+bPxRfiCYEXAMPLEKEY'. 
	"use DynamoDB Local"
	config useSSL: false.
	config endpoint: 'localhost:8000'.