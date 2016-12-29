private
createCanonicalRequest: request andOption: aDictionary
	| cs queryDict queryString |
	"Task 1: Create a Canonical Request For Signature Version 4"
	"reference.
	http://docs.aws.amazon.com/general/latest/gr/sigv4-create-canonical-request.html"
	"Start with the HTTP request method (GET, PUT, POST, etc.), followed by a newline character."
	cs := request method , String lf.

	"Add the canonical URI parameter, followed by a newline character. The canonical URI is the URI-encoded version of the absolute path component of the URI—everything in the URI from the HTTP host to the question mark character (?) that begins the query string parameters (if any). Then add a newline character."
	cs := cs , request url pathPrintString , String lf.

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