Class {
	#name : #BaselineOfAWS,
	#superclass : #BaselineOf,
	#category : #BaselineOfAWS
}

{ #category : #baselines }
BaselineOfAWS >> baseline: spec [

	<baseline>
	spec for: #common do: [
		
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
			package: 'AWS-Core' with: [ spec requires: #( 'NeoJSON' ) ];
			package: 'AWS-DynamoDB' with: [ spec requires: #( 'AWS-Core' 'NeoJSON' ) ];
			package: 'AWS-Lambda' with: [ spec requires: #( 'AWS-Core' ) ];
			package: 'AWS-S3'
			with: [ spec requires: #( 'AWS-Core' 'XMLParser' ) ];
			package: 'AWS-STS' with: [ spec requires: #( 'AWS-Core' ) ];
			package: 'AWS-CloudFront' with: [ spec requires: #( 'AWS-Core' ) ];
			package: 'AWS-SNS'
			with: [ spec requires: #( 'AWS-Core' 'XMLParser' ) ] ].

	spec
		group: 'Tests' with: #( 'AWS-Core' 'AWS-S3' 'AWS-Lambda' 'AWS-DynamoDB' );
		group: 'CI' with: #( 'Tests' )
]
