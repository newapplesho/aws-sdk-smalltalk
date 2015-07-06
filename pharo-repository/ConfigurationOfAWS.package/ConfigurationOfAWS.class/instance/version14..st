versions
version14: spec
	<version: '1.4' imports: #('1.1-baseline')>
	
	spec for: #common do: [	
		"spec blessing: #development."
		spec project: 'JSON' with: #stable.
		spec
			baseline: 'AWS' with: [ spec repository:'github://newapplesho/aws-sdk-smalltalk:7978adb9ffba30c43dabd82eb6750b1234aa6e9f/pharo-repository' ];
		import: 'AWS'
	].

	spec for: #'pharo3.x' do: [
		spec package: 'Cryptography' with: 'Cryptography-mtf.36'. ].