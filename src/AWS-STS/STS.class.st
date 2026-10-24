Class {
	#name : #STS,
	#superclass : #AWSService,
	#category : #'AWS-STS'
}

{ #category : #public }
STS >> assumeRoleRoleArn: aRoleArnString roleSessionName: roleSessionName [
	| urlFormat url request |
	urlFormat := '/?Action=AssumeRole&Version={Version}&RoleArn={RoleArn}&RoleSessionName={RoleSessionName}'.
	url := urlFormat format: (Dictionary with: 'Version'-> self awsConfig apiVersion with: 'RoleArn'-> aRoleArnString with:  'RoleSessionName'-> roleSessionName).

	request := ZnRequest empty.
	request method: #POST.
	request url: url.
	request entity: (ZnEntity text: '').
	request headers at: 'host' put: self awsConfig endpoint.
	^ self client request: (self signRequest: request) andOption: nil
]

{ #category : #defaults }
STS >> defaultClient [
	^ STSClient awsConfig: self awsConfig
]

{ #category : #defaults }
STS >> defaultConfigClass [
	^ AWSSTSConfig
]

{ #category : #public }
STS >> getSessionToken [
	| request |
	request := ZnRequest empty.
	request method: #POST.
	request url: '/?Action=GetSessionToken&Version=', self awsConfig apiVersion.
	request entity: (ZnEntity text: '').
	request headers at: 'host' put: self awsConfig endpoint.
	^ self client request: (self signRequest: request) andOption: nil
]
