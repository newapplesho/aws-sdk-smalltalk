versions
version111: spec
	<version: '1.1.1' imports: #('1.0-baseline')>
	
	spec for: #common do: [	
		"spec blessing: #development."
		spec project: 'JSON' with: '1.0'.
		spec package: 'Cryptography' with: 'Cryptography-mtf.36'.
		spec
                baseline: 'AWS' with: [ spec repository:'github://newapplesho/aws-sdk-smalltalk:9dcc5be1cb7f995e8463d96989d4b5ab9fcd4307/pharo-repository' ];
                import: 'AWS'
	]