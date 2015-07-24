versions
version15: spec
	<version: '1.5' imports: #('1.1.1-baseline')>
	
	spec for: #common do: [	
		"spec blessing: #development."
		spec project: 'JSON' with: #stable.
		spec package: 'MethodsDefiner' with: 'MethodsDefiner-Core-MasashiUmezawa.4'.
		spec
			baseline: 'AWS' with: [ spec repository:'github://newapplesho/aws-sdk-smalltalk:b31f0844a0320a995035dd54d86bbe5585bc08a8/pharo-repository' ];
		import: 'AWS'
	].

	spec for: #'pharo3.x' do: [
		spec package: 'Cryptography' with: 'Cryptography-mtf.36'. ].