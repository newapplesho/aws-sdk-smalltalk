instance creation
defaultS3Setting
	| aws |
	aws := self new.
	aws serviceName:'s3'.
	"AWS Regions Asia Pacific (Tokyo)"
	aws regionName: 'ap-northeast-1'.
	^ aws