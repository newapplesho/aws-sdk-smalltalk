versions
version142: spec
	<version: '1.4.2' imports: #('1.1.1-baseline')>
	
	spec for: #common do: [	
		"spec blessing: #development."
		spec project: 'JSON' with: #stable.
		spec package: 'MethodsDefiner' with: 'MethodsDefiner-Core-MasashiUmezawa.4'.
		spec
			baseline: 'AWS' with: [ spec repository:'github://newapplesho/aws-sdk-smalltalk:f5e9697d94aba9dc238db0bbb5b7fe48adab26c5/pharo-repository' ];
		import: 'AWS'
	].

	spec for: #'pharo3.x' do: [
		spec package: 'Cryptography' with: 'Cryptography-mtf.36'. ].