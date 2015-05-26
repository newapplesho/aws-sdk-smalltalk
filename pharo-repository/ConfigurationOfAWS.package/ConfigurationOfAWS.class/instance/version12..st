versions
version12: spec
	<version: '1.2' imports: #('1.0-baseline')>
	
	spec for: #common do: [	
		"spec blessing: #development."
		spec project: 'JSON' with: '1.0'.
		spec package: 'Cryptography' with: 'Cryptography-mtf.36'.
		spec
                baseline: 'AWS' with: [ spec repository: 					'github://newapplesho/aws-sdk-smalltalk:8f9febb5ff3adb4550fc9e573598de93eb077ae6/pharo-repository' ];
                import: 'AWS'
	]