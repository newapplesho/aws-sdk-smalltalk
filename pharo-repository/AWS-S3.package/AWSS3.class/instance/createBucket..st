public
createBucket: bucketNameString
	| request  requestBody |
	
	requestBody := '<CreateBucketConfiguration xmlns="http://s3.amazonaws.com/doc/2006-03-01/"> 
  <LocationConstraint>', self awsConfig regionName ,'</LocationConstraint> 
</CreateBucketConfiguration >'.

	request := self createRequest: requestBody url: '/' method: #PUT andBucketName: bucketNameString.
	^ self client request: request andOption: nil.