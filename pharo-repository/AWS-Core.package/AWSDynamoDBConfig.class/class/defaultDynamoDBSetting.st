instance creation
defaultDynamoDBSetting
	| aws |
	aws := self new.
	aws serviceName:'DynamoDB'.
	"AWS Regions Asia Pacific (Tokyo)"
	aws regionName: 'ap-northeast-1'.
	aws api_version: '20120810'.
	^ aws