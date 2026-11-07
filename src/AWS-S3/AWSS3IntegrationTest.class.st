"
I am a live integration test for the S3 facade. I send requests to a local
floci AWS emulator (https://floci.io, MIT-licensed, no auth token) instead of
real AWS.

I need floci listening on localhost:4566. Start it with `make floci-up` (see
docker-compose.yml). If floci is not running, my tests fail with connection
errors. In CI, the `integration` job starts floci and runs me; the `build` job
does not run me.

The SDK addresses buckets in virtual-hosted style, so my bucket requests go to
<bucket>.localhost. On macOS that name resolves to 127.0.0.1 (RFC 6761). Linux
does not resolve *.localhost, so the CI job adds the bucket host to /etc/hosts.

When run locally, my setUp picks a unique bucket name. My tearDown deletes the
bucket if a test left it behind. In CI, the S3_TEST_BUCKET environment
variable fixes the bucket name so that the /etc/hosts entry matches it.
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
	^ OSEnvironment current at: aKey ifAbsent: aBlock
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
	"CI sets S3_TEST_BUCKET to a fixed name because the CI job must add that
	 bucket host to /etc/hosts (Linux does not resolve *.localhost).
	 Without S3_TEST_BUCKET, this method generates a unique name."
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
