versions
version110: spec
	<version: '1.10' imports: #('1.1.3-baseline')>
	spec
		for: #common
		do: [ spec project: 'JSON' with: #stable.
			spec
				baseline: 'AWS'
					with: [ spec repository: 'github://newapplesho/aws-sdk-smalltalk:v1.10/pharo-repository' ];
				import: 'AWS' ].
	spec for: #'pharo3.x' do: [ spec package: 'Cryptography' with: 'Cryptography-mtf.36' ]