"
I am a live integration test for the S3 facade, run against a local floci AWS
emulator (https://floci.io, MIT-licensed, no auth token) rather than real AWS.

I need floci listening on localhost:4566. Start it with `make floci-up` (see
docker-compose.yml). Like the DynamoDB integration tests, I am excluded from CI
and only run locally via `make test`; without floci running my tests fail with
connection errors.

I address S3 at localhost:4566. The SDK uses virtual-hosted-style addressing, so
bucket requests go to <bucket>.localhost, which resolves to 127.0.0.1 (RFC 6761)
— no magic DNS needed. Each test uses a unique bucket name and cleans it up in
tearDown.
"
Class {
	#name : #AWSS3IntegrationTest,
	#superclass : #TestCase,
	#instVars : [
		's3',
		'bucketName'
	],
	#category : #'AWS-S3-Tests'
}

{ #category : #running }
AWSS3IntegrationTest >> envAt: aKey ifAbsent: aBlock [
	^ Smalltalk os environment at: aKey ifAbsent: aBlock
]

{ #category : #running }
AWSS3IntegrationTest >> setUp [
	super setUp.
	s3 := AWSS3 new.
	s3 awsConfig: (AWSS3Config new
		accessKeyId: 'test';
		secretKey: 'test';
		endpoint: (self envAt: 'S3_TEST_ENDPOINT' ifAbsent: [ 'localhost:4566' ]);
		useSSL: false;
		yourself).
	"CI pins a fixed bucket so <bucket>.localhost can be added to /etc/hosts
	 (Linux runners do not resolve *.localhost); locally a unique name is used."
	bucketName := self envAt: 'S3_TEST_BUCKET' ifAbsent: [
		'aws-sdk-smalltalk-test-', UUID new asString ]
]

{ #category : #running }
AWSS3IntegrationTest >> tearDown [
	[ s3 deleteBucket: bucketName ] on: Error do: [ :e | ].
	super tearDown
]

{ #category : #'tests-buckets' }
AWSS3IntegrationTest >> bucketNames [
	^ s3 listBuckets collect: [ :each | each bucketName ]
]

{ #category : #'tests-buckets' }
AWSS3IntegrationTest >> testCreateBucketAppearsInListingThenDelete [
	self deny: (self bucketNames includes: bucketName).
	s3 createBucket: bucketName.
	self assert: (self bucketNames includes: bucketName).
	s3 deleteBucket: bucketName.
	self deny: (self bucketNames includes: bucketName)
]
