versions
version151: spec
	<version: '1.5.1' imports: #('1.1.2-baseline')>
	
	spec for: #common do: [	
		"spec blessing: #development."
		spec project: 'JSON' with: #stable.
		spec
			baseline: 'AWS' with: [ spec repository:'github://newapplesho/aws-sdk-smalltalk:670be068cd8f5eda47469a1ddecdf7a8b1dadfbf/pharo-repository' ];
		import: 'AWS'
	].

	spec for: #'pharo3.x' do: [
		spec package: 'Cryptography' with: 'Cryptography-mtf.36'. ].