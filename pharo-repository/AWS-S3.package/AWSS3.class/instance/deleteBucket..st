public
deleteBucket: bucketNameString
	| request|
	request := self createRequest: '' url: '/' method: #DELETE  andBucketName: bucketNameString.
	^ self client request: request andOption: nil.
	