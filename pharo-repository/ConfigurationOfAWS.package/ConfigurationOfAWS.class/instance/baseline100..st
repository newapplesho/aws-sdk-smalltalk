baselines
baseline100: spec 
	<version: '1.0-baseline'>
	
	spec for: #common do: [
		spec project: 'JSON' with: [
			spec
				className: 'ConfigurationOfJSON';
				file: 'ConfigurationOfJSON';
				repository: 'http://smalltalkhub.com/mc/PharoExtras/JSON/main'. ].
			
		spec package: 'Cryptography' with: [
			spec repository: 'http://smalltalkhub.com/mc/Cryptography/Cryptography/main'. ].
	].