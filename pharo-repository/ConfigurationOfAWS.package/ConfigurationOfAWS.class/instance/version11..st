versions
version11: spec
	<version: '1.0' imports: #('1.0-baseline')>
	
	spec for: #common do: [	
		"spec blessing: #development."
		spec project: 'JSON' with: '1.0'.
		spec package: 'Cryptography' with: 'Cryptography-mtf.36'.
		spec
                baseline: 'AWS' with: [ spec repository: 					'github://newapplesho/aws-sdk-smalltalk:67c4bac33be6d16c72c40a52ebe272c6623e3054/pharo-repository' ];
                import: 'AWS'
	]