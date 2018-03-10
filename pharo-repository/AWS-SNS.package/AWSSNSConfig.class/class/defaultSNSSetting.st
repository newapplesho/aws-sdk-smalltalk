instance creation
defaultSNSSetting
	| aws |
	aws := self new.
	aws serviceName:'sns'.
	aws regionName: 'eu-west-1'.
	^ aws