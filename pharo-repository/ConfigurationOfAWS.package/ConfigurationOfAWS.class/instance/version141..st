versions
version141: spec
	<version: '1.4.1' imports: #('1.1-baseline')>
	
	spec for: #common do: [	
		"spec blessing: #development."
		spec project: 'JSON' with: #stable.
		spec package: 'MethodsDefiner' with: 'MethodsDefiner-Core-MasashiUmezawa.4'.
		spec
			baseline: 'AWS' with: [ spec repository:'github://newapplesho/aws-sdk-smalltalk:9b8a8559d29f08bfd0020bd022800d3fcbd61a17/pharo-repository' ];
		import: 'AWS'
	].

	spec for: #'pharo3.x' do: [
		spec package: 'Cryptography' with: 'Cryptography-mtf.36'. ].