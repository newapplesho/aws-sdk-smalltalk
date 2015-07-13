versions
version141: spec
	<version: '1.4.1' imports: #('1.1.1-baseline')>
	
	spec for: #common do: [	
		"spec blessing: #development."
		spec project: 'JSON' with: #stable.
		spec package: 'MethodsDefiner' with: 'MethodsDefiner-Core-MasashiUmezawa.4'.
		spec
			baseline: 'AWS' with: [ spec repository:'github://newapplesho/aws-sdk-smalltalk:78d96f7a5f619a3eb92d48cd5a4e61844920dce9/pharo-repository' ];
		import: 'AWS'
	].

	spec for: #'pharo3.x' do: [
		spec package: 'Cryptography' with: 'Cryptography-mtf.36'. ].