baselines
baseline110: spec 
	<version: '1.1-baseline'>
	
	spec for: #common do: [
		spec project: 'JSON' with: [
			spec
				className: 'ConfigurationOfJSON';
				versionString: #stable;
				repository: 'http://smalltalkhub.com/mc/PharoExtras/JSON/main'. ].
	].

	spec for: #(#'pharo3.x') do:[			
		spec package: 'Cryptography' with: [
			spec repository: 'http://smalltalkhub.com/mc/Cryptography/Cryptography/main'. ].
	].