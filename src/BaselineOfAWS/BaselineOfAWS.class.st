Class {
	#name : #BaselineOfAWS,
	#superclass : #BaselineOf,
	#category : #BaselineOfAWS
}

{ #category : #baselines }
BaselineOfAWS >> baseline: spec [

	<baseline>
	spec for: #common do: [
		
		spec baseline: 'JSON' with: [
			spec repository:
				'github://Evref-BL/Json-BackwardCompatibility:main/src' ].
		spec
			baseline: 'NeoJSON'
			with: [ spec repository: 'github://svenvc/NeoJSON/repository' ].

		spec baseline: 'XMLParser' with: [
			spec repository:
				'github://pharo-contributions/XML-XMLParser:master/src' ].

		spec for: #'pharo3.x' do: [
			spec package: 'Cryptography' with: [
				spec repository:
					'http://smalltalkhub.com/mc/Cryptography/Cryptography/main' ] ].
		spec
			package: 'AWS-Core';
			package: 'AWS-DynamoDB' with: [ spec requires: #( 'AWS-Core' ) ];
			package: 'AWS-Lambda' with: [ spec requires: #( 'AWS-Core' ) ];
			package: 'AWS-S3'
			with: [ spec requires: #( 'AWS-Core' 'XMLParser' ) ];
			package: 'AWS-ElasticTranscoder'
			with: [ spec requires: #( 'AWS-Core' ) ];
			package: 'AWS-STS' with: [ spec requires: #( 'AWS-Core' ) ];
			package: 'AWS-CloudFront' with: [ spec requires: #( 'AWS-Core' ) ];
			package: 'AWS-SNS'
			with: [ spec requires: #( 'AWS-Core' 'XMLParser' ) ] ].

	spec
		group: 'Tests' with: #( 'AWS-Core' );
		group: 'CI' with: #( 'Tests' )
]
