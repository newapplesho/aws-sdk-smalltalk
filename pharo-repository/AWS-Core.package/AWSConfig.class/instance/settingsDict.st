accessing
settingsDict
	^ settingsDict ifNil: [settingsDict := IdentityDictionary new]