baselines
baseline: spec 
	 <baseline>
	
	spec for: #common do: [
		spec project: 'JSON' with: [
			spec
				className: 'ConfigurationOfJSON';
				file: 'ConfigurationOfJSON';
				repository: 'http://smalltalkhub.com/mc/PharoExtras/JSON/main'. ].
			
		spec package: 'Cryptography' with: [
			spec repository: 'http://smalltalkhub.com/mc/Cryptography/Cryptography/main'. ].
		
		 spec 
			package: 'AWS';
			package: 'AWS-Core'
        	  		with: [ spec requires: #('AWS') ];
			package: 'AWS-DynamoDB'
        	  		with: [ spec requires: #('AWS-Core') ].
	].