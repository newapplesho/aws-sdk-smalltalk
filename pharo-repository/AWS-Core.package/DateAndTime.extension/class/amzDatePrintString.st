*AWS-Core
amzDatePrintString

	| dt t  |
	dt := DateAndTime now asUTC.
	t := (dt asTimeUTC print24 findTokens: '.')first copyReplaceAll:':' with:''.
	^ (dt asDate printFormat:#(3 2 1 0 1 1 2)),'T',t,'Z'.