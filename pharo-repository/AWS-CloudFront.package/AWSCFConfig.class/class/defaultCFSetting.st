defaults
defaultCFSetting
	| aws |
	aws := self new.
	aws serviceName:'cloudfront'.
	aws regionName: 'us-east-1'.
	aws apiVersion: '2016-09-29'.
	^ aws