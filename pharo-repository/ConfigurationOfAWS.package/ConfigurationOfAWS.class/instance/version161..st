versions
version161: spec
	<version: '1.6.1' imports: #('1.1.2-baseline')>
	
	spec for: #common do: [	
		spec project: 'JSON' with: #stable.
		spec
			baseline: 'AWS' with: [ spec repository:'github://newapplesho/aws-sdk-smalltalk:v1.6.1/pharo-repository' ];
		import: 'AWS'
	].

	spec for: #'pharo3.x' do: [
		spec package: 'Cryptography' with: 'Cryptography-mtf.36'. ].