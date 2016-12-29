defaults
defaultSTSSetting
	| aws |
	aws := self new.
	aws serviceName:'sts'.
	"AWS Regions Asia Pacific (Tokyo)"
	aws regionName: 'ap-northeast-1'.
	aws apiVersion: '2011-06-15'.
	^ aws