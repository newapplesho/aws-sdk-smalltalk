Class {
	#name : #AWSS3,
	#superclass : #AWSService,
	#category : 'AWS-S3'
}

{ #category : #public }
AWSS3 >> bucketNamed: bucketNameString [
	^ S3Bucket named: bucketNameString 
]

{ #category : #public }
AWSS3 >> createBucket: bucketNameString [
	| request  requestBody |
	
	requestBody := '<CreateBucketConfiguration xmlns="http://s3.amazonaws.com/doc/2006-03-01/"> 
  <LocationConstraint>', self awsConfig regionName ,'</LocationConstraint> 
</CreateBucketConfiguration >'.

	request := self createRequest: requestBody url: '/' method: #PUT andBucketName: bucketNameString.
	^ self client request: request andOption: nil.
]

{ #category : #private }
AWSS3 >> createRequest: aRequestBody url: url method: method andBucketName: bucketNameString [
		
	| datetimeString hostUrl request |
	datetimeString := DateAndTime amzDatePrintString.
	hostUrl := bucketNameString, '.', self awsConfig endpoint.
	
	request := ZnRequest empty.
	request method: method.
	request url: url.
	
	request entity:(ZnEntity readBinaryFrom: aRequestBody asByteArray readStream usingType: ZnMimeType textPlain andLength: aRequestBody byteSize). 
	request headers at:'host' put: hostUrl.
	self awsConfig sessionToken ifNotNil: [ request headers at:'X-Amz-Security-Token' put: self awsConfig sessionToken ].	
	request headers at:'x-amz-content-sha256' put: (SHA256 new hashMessage: aRequestBody) hex.
	request headers at:'x-amz-date' put: datetimeString.
	request setAuthorization: ( SignatureV4 creatAuthorization: request andConfig: self awsConfig andDateTime: datetimeString andOption: nil ) .
	^ request
]

{ #category : #defaults }
AWSS3 >> defaultClientClass [
	^ S3Client 
]

{ #category : #defaults }
AWSS3 >> defaultConfigClass [
	^ AWSS3Config
]

{ #category : #public }
AWSS3 >> deleteBucket: bucketNameString [
	| request|
	request := self createRequest: '' url: '/' method: #DELETE  andBucketName: bucketNameString.
	^ self client request: request andOption: nil.
	
]

{ #category : #public }
AWSS3 >> getBucket: bucketNameString [
	^ S3Bucket new bucketName: bucketNameString 
]
