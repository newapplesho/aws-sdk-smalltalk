versions
version10: spec
	<version: '1.0' imports: #('1.0-baseline')>
	
	spec for: #common do: [	
		spec blessing: #development.
		spec project: 'JSON' with: '1.0'.
		spec package: 'Cryptography' with: 'Cryptography-mtf.36'.
		spec
                baseline: 'AWS' with: [ spec repository: 					'github://newapplesho/aws-sdk-smalltalk:9380f510a34a3b0aeb0f6907304ccf6aec07b129/pharo-repository' ];
                import: 'AWS'
	]