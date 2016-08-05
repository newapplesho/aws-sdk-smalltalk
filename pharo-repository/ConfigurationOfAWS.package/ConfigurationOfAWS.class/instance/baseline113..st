baselines
baseline113: spec 
	<version: '1.1.3-baseline'>
	
	spec for: #common do: [
		spec project: 'JSON' with: [
			spec
				className: 'ConfigurationOfJSON';
				versionString: #stable;
				repository: 'http://smalltalkhub.com/mc/PharoExtras/JSON/main'. ].																	
	].

	spec project: 'XMLParser' with: [
		spec
			className: 'ConfigurationOfXMLParser'; 
			file: 'ConfigurationOfXMLParser'; 
			repository: 'http://smalltalkhub.com/mc/PharoExtras/XMLParser/main'. ].

	spec for: #(#'pharo3.x') do:[			
		spec package: 'Cryptography' with: [
			spec repository: 'http://smalltalkhub.com/mc/Cryptography/Cryptography/main'. ].
	].