Class {
	#name : #SignatureV4,
	#superclass : #Object,
	#category : 'AWS-Core'
}

{ #category : #creating }
SignatureV4 class >> creatAuthorization: request andConfig: awsConfig andDateTime: datetimeString [
	^ self creatAuthorization: request andConfig: awsConfig andDateTime: datetimeString andOption: nil
]

{ #category : #creating }
SignatureV4 class >> creatAuthorization: request andConfig: awsConfig andDateTime: datetimeString andOption: aDictionary [
	^ self new creatAuthorization: request andConfig: awsConfig andDateTime: datetimeString andOption: aDictionary
]

{ #category : #private }
SignatureV4 >> creatAuthorization: request andConfig: awsConfig andDateTime: datetimeString andOption: aDictionary [

	| sign credential |
	
	sign :=  self  createSign: request andConfig: awsConfig andDateTime: datetimeString andOption: nil.
	
	credential := awsConfig accessKeyId,'/', (self createCredentialScopeValue: awsConfig andDateTime: datetimeString).
	
	^ self  signatureAlgorithm, ' Credential=',credential,', SignedHeaders=', ( self createSignHeaders: request ),', Signature=',sign.
]

{ #category : #private }
SignatureV4 >> creatCanonicalHeaders: request [
	| headers canonicalHeadersString |
	headers := Dictionary new.

	request headers keysAndValuesDo: [ :k :v |
		(k ~= 'Accept') ifTrue:[
			headers at: k put: v.
		].
	  ].

	canonicalHeadersString :=  String streamContents:[:s|
		headers keysSortedSafely do:[:key | 
			s nextPutAll: key urlEncoded asLowercase .
			s nextPutAll: ':'.
			s nextPutAll: ( (headers at: key ) copyWithRegex: '\s+' matchesReplacedWith: ' ') trimBoth .
			s nextPutAll: String lf.
		].
	].

	^ canonicalHeadersString
]

{ #category : #private }
SignatureV4 >> creatPreSignedUrlToRequest: request config: awsConfig dateTime: datetimeString option: aDictionary [
	| sign credential url |
	credential := awsConfig accessKeyId , '/'
		, (self createCredentialScopeValue: awsConfig andDateTime: datetimeString).
	request uri queryAt: 'X-Amz-Algorithm' put: self signatureAlgorithm.
	request uri queryAt: 'X-Amz-Credential' put: credential.
	request uri queryAt: 'X-Amz-Date' put: datetimeString.
	request uri queryAt: 'X-Amz-SignedHeaders' put: (self createSignHeaders: request).
	(aDictionary at: #expire ifAbsent: [ nil ])
		ifNotNil: [ request uri queryAt: 'X-Amz-Expires' put: (aDictionary at: #expire) asString ].
	url := 'https://' , awsConfig hostUrl.
	
	sign := self
		createSign: request
		andConfig: awsConfig
		andDateTime: datetimeString
		andOption: nil.
	request uri query
		ifNil: [ url := url ]
		ifNotNil: [ url := url asString , '?' , (self getEncodedSortQueryString: request uri query) , '&' ].
	^ url , 'X-Amz-Signature=' , sign
]

{ #category : #private }
SignatureV4 >> createCanonicalRequest: request andOption: aDictionary [
	| cs queryDict queryString |
	"Task 1: Create a Canonical Request For Signature Version 4"
	"reference.
	http://docs.aws.amazon.com/general/latest/gr/sigv4-create-canonical-request.html"
	"Start with the HTTP request method (GET, PUT, POST, etc.), followed by a newline character."
	cs := request method , String lf.

	"Add the canonical URI parameter, followed by a newline character. The canonical URI is the URI-encoded version of the absolute path component of the URI—everything in the URI from the HTTP host to the question mark character (?) that begins the query string parameters (if any). Then add a newline character."
	cs := cs , request url awsEncodeCanonicalUri, String lf.

	"Add the canonical query string, followed by a newline character. If the request does not include a query string, set this value in the canonical query to an empty string (essentially, a blank line). The example query does not contain a query string."
	queryDict := request url query.
	queryString := self getEncodedSortQueryString: queryDict.
	cs := cs , queryString , String lf.

	"Add the canonical headers, followed by a newline character. The canonical headers consist of a list of all the HTTP headers that you are including that are part of the AWS request."
	cs := cs , (self creatCanonicalHeaders: request) , String lf.

	"Add the signed headers, following by a newline character. This value is a list of the names of the headers that you included in the canonical headers. By adding this list of headers, you tell AWS which headers in the request are part of the signing process."
	cs := cs , (self createSignHeaders: request) , String lf.

	"Using a hash (digest) function like SHA256, create a hashed value from the payload in the body of the HTTP or HTTPS request"
	request contents isEmptyOrNil
		ifTrue: [ cs := cs , (SHA256 new hashMessage: '') hex ]
		ifFalse: [ cs := cs , (SHA256 new hashMessage: request contents) hex ].
	^ cs
]

{ #category : #private }
SignatureV4 >> createCredentialScopeValue: awsConfig andDateTime: datetimeString [
	^ ( datetimeString first: 8 ),'/',awsConfig regionName,'/', awsConfig serviceName asLowercase, '/aws4_request'.
]

{ #category : #private }
SignatureV4 >> createDerivedSigningKey: awsConfig andDateTime: datetimeString [
	
	|    hmac kDate kRegion kService kSigning  |
	
	"Task 3: Calculate the AWS Signature Version 4"
	"reference.
	 http://docs.aws.amazon.com/general/latest/gr/sigv4-calculate-signature.html"
	
	"kDate"
	hmac := SHA256 new hmac.
	hmac key: ('AWS4', awsConfig secretKey) asByteArray.
	kDate := hmac digestMessage: ( datetimeString first: 8 ).
	
	"kRegion"
	hmac := SHA256 new hmac.
	hmac key: kDate.
	kRegion := hmac digestMessage: awsConfig regionName.

	"kService"
	hmac := SHA256 new hmac.
	hmac key: kRegion.
	kService := hmac digestMessage: awsConfig serviceName asLowercase.

	"kSigning"
	hmac := SHA256 new hmac.
	hmac key: kService.
	kSigning := hmac digestMessage: 'aws4_request'.
	
	^ kSigning.

]

{ #category : #private }
SignatureV4 >> createSign: request andConfig: awsConfig andDateTime: datetimeString andOption: aDictionary [
	| cs sts hmac kSigning sign |
	"Task 1: Create a Canonical Request For Signature Version 4"
	cs := self createCanonicalRequest: request andOption: nil.

	"Task 2: Create a String to Sign for Signature Version 4"
	sts := self
		createStringtoSign: awsConfig
		andDateTime: datetimeString
		andCanonicalRequest: cs.

	"Task 3: Calculate the AWS Signature Version 4"
	kSigning := self createDerivedSigningKey: awsConfig andDateTime: datetimeString.
	hmac := SHA256 new hmac.
	hmac key: kSigning.
	sign := hmac digestMessage: sts.
	^ sign hex
]

{ #category : #private }
SignatureV4 >> createSignHeaders: request [
	| headers signHeadersString |
	headers := Dictionary new.

	request headers keysAndValuesDo: [ :k :v |
		(k ~= 'Accept') ifTrue:[
			headers at: k put: v.
		].
	  ].

	signHeadersString :=  String streamContents:[:s|
		headers keysSortedSafely do:[:key | 
			s nextPutAll: key asLowercase .
		] separatedBy: [ s nextPutAll: ';' ]
	].

	^ signHeadersString
]

{ #category : #private }
SignatureV4 >> createStringtoSign: awsConfig andDateTime: datetimeString andCanonicalRequest: canonicalRequestString [
	| sts dateStamp |
	"Task 2: Create a String to Sign for Signature Version 4"
	"reference.
	 http://docs.aws.amazon.com/general/latest/gr/sigv4-create-string-to-sign.html"
	"datetimeString format 20110909T233600Z"
	"dateStamp format 20110909"
	dateStamp := datetimeString first: 8.
	sts := self signatureAlgorithm , String lf.
	sts := sts , datetimeString , String lf.
	sts := sts , (self createCredentialScopeValue: awsConfig andDateTime: datetimeString) , String lf.
	sts := sts , (SHA256 new hashMessage: canonicalRequestString) hex.
	^ sts
]

{ #category : #private }
SignatureV4 >> getEncodedSortQueryString: aDictionary [
	| queryString |

	aDictionary isEmptyOrNil ifTrue:[ ^ '' ].

	queryString := String streamContents:[:s|
		aDictionary keysSortedSafely do:[:key|
			(aDictionary at:key) isArray 
				ifTrue:[
					(aDictionary at:key) do: [ :each | 
						s nextPutAll: key urlEncoded.
						s nextPutAll: '='.
						s nextPutAll: each urlEncoded.
					] separatedBy:[s nextPutAll: '&'].
				]
				ifFalse:[
					s nextPutAll: key urlEncoded.
					s nextPutAll: '='.
					s nextPutAll: (aDictionary at:key) urlEncoded . ].
		] separatedBy:[s nextPutAll: '&'].
	].

	^ queryString
]

{ #category : #private }
SignatureV4 >> signatureAlgorithm [
	^ 'AWS4-HMAC-SHA256'.
]
