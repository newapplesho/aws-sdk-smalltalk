tests-private
testCreateDerivedSigningKeyAndDateTime
	| awsConfig datetimeString result |
	awsConfig := AWSConfig new.
	awsConfig serviceName:'iam'.
	awsConfig regionName: 'us-east-1'.
	awsConfig secretKey: 'wJalrXUtnFEMI/K7MDENG+bPxRfiCYEXAMPLEKEY'.
	
	datetimeString := '20110909T233600Z'.
	
	result := SignersV4 new createDerivedSigningKey: awsConfig andDateTime: datetimeString.
	
	self assertCollection: result equals: #(152 241 216 137 254 196 244 66 26 220 82 43 171 12 225 248 46 105 41 194 98 237 21 229 169 76 144 239 209 227 176 231) asByteArray.