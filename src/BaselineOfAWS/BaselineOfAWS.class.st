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
			with: [ spec repository: 'github://svenvc/NeoJSON:11e274dd96dc9636cab90929937b7cd09719de7c/repository' "master" ].

		spec baseline: 'XMLParser' with: [
			spec repository:
				'github://pharo-contributions/XML-XMLParser:26a888381174c154b02e908f27d9d5eead3d04ec/src' "master" ].

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
