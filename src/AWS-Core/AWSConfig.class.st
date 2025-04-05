"
I represent a set of credentials for AWS.

AWS allows credentials to be stored in the .aws directory in the home directory and aggregated under a grouped profile name.

The key 3 items required to configure a profile are accessKey, accessSecret, and region identifier.
These items are stored in 2 files named config and credentials.  The format of credentials is:

[profileName]
aws_access_key_id = ABCDEFGHIJKLMNOP
aws_secret_access_key = aoisobiaIBk892lkwi+sd/qRm
[default]
aws_access_key_id = ZyXWVUTSRQPONML
aws_secret_access_key = sjioASa/sfijsaajlkwi+bR2My
...

The format of config is: 

[profile1 profile2 profilen]
region = us-east-1
[default]
region = us-west-2

Where you can have multiple profile names within a set of []'s.  (It makes no sense to support multiple profile names for the access keys so one key per set of []'s)
"
Class {
	#name : #AWSConfig,
	#superclass : #Object,
	#instVars : [
		'settingsDict'
	],
	#category : #'AWS-Core'
}

{ #category : #'instance creation' }
AWSConfig class >> default [
	self subclassResponsibility
]

{ #category : #'instance creation' }
AWSConfig class >> profile: aProfile [
	| awsdir config credentials regionName secretKey secretUUID me |
	awsdir := FileLocator home / '.aws'.
	config := awsdir / 'config'.
	credentials := awsdir / 'credentials'.
	credentials readStreamDo: [ :s || line pair |
		[(s match: aProfile) and: [ s nextLine trimmed endsWith: ']' ]] 
			whileFalse: [ ].
				line := s nextLine.
				pair := line splitOn: '='.
				(pair first trimmed = 'aws_access_key_id') ifTrue: [ secretUUID := pair second trimmed ].
				(pair first trimmed = 'aws_secret_access_key') ifTrue: [secretKey := pair second trimmed].
				line := s nextLine.
				pair := line splitOn: '='.
				(pair first trimmed = 'aws_access_key_id') ifTrue: [ secretUUID := pair second trimmed ].
				(pair first trimmed = 'aws_secret_access_key') ifTrue: [secretKey := pair second trimmed]. 
			secretKey ifNil: [ ^aProfile = 'default' 
				ifFalse: [self profile: 'default'] 
				ifTrue: [self default]].
		 ].
	config readStreamDo: [ :s |
		(s match: (aProfile))
			ifTrue: [ 
				s nextLine. "blank"
				regionName := (s nextLine splitOn: '=') second trimmed ]
			ifFalse: [regionName := nil]].
	me := self new 
		accessKeyId: secretUUID;
		secretKey: secretKey;
		yourself.
	regionName ifNotNil: [ me regionName: regionName ].
	^me
		
]

{ #category : #accessing }
AWSConfig >> accessKeyId [
	^self  at: #accessKeyId ifAbsent: []
]

{ #category : #accessing }
AWSConfig >> accessKeyId: anObject [
	^self  at: #accessKeyId put: anObject
]

{ #category : #accessing }
AWSConfig >> apiVersion [
	^self  at: #apiVersion ifAbsent: []
]

{ #category : #accessing }
AWSConfig >> apiVersion: anObject [
	^self at: #apiVersion put: anObject
]

{ #category : #accessing }
AWSConfig >> at: key [
	^self settingsDict at: key
]

{ #category : #accessing }
AWSConfig >> at: key ifAbsent: aBlock [
	^self settingsDict at: key ifAbsent: aBlock
]

{ #category : #accessing }
AWSConfig >> at: key ifAbsentPut: aBlock [
	^self settingsDict at: key ifAbsentPut: aBlock
]

{ #category : #accessing }
AWSConfig >> at: key put: value [
	^self settingsDict at: key put: value
]

{ #category : #defaults }
AWSConfig >> defaultRegionName [
	"AWS Regions Asia Pacific (Tokyo)"
	^ 'ap-northeast-1'.
]

{ #category : #defaults }
AWSConfig >> defaultServiceName [
	^ ''
]

{ #category : #accessing }
AWSConfig >> endpoint [
	^self  at: #endpoint ifAbsent: [ self endpoint: self hostUrl ]
]

{ #category : #accessing }
AWSConfig >> endpoint: anObject [
	^self  at: #endpoint put: anObject
]

{ #category : #accessing }
AWSConfig >> hostUrl [
	^self at: #hostUrl ifAbsent: [ self hostUrl: self serviceName asLowercase,'.', self regionName, '.amazonaws.com'. ]
]

{ #category : #accessing }
AWSConfig >> hostUrl: anObject [
	self settingsDict removeKey: #endpoint ifAbsent: [  ].
	^ self at: #hostUrl put: anObject
]

{ #category : #accessing }
AWSConfig >> regionName [
	^ self at: #regionName ifAbsentPut: [ self defaultRegionName ]
]

{ #category : #accessing }
AWSConfig >> regionName: anObject [
	self settingsDict removeKey: #hostUrl ifAbsent: [  ].
	self settingsDict removeKey: #endpoint ifAbsent: [  ].
	^ self at: #regionName put: anObject
]

{ #category : #accessing }
AWSConfig >> secretKey [
	^self  at: #secretKey ifAbsent: []
]

{ #category : #accessing }
AWSConfig >> secretKey: anObject [
	^self  at: #secretKey put: anObject
]

{ #category : #accessing }
AWSConfig >> serviceName [
	^self  at: #serviceName ifAbsent: [ self defaultServiceName ]
]

{ #category : #accessing }
AWSConfig >> serviceName: anObject [
	^self  at: #serviceName put: anObject
]

{ #category : #accessing }
AWSConfig >> sessionToken [
	^self  at: #sessionToken ifAbsent: []
]

{ #category : #accessing }
AWSConfig >> sessionToken: anObject [
	^self  at: #sessionToken put: anObject
]

{ #category : #accessing }
AWSConfig >> settingsDict [
	^ settingsDict ifNil: [settingsDict := IdentityDictionary new]
]

{ #category : #accessing }
AWSConfig >> useSSL [

	^self at: #useSSL ifAbsent: [ self useSSL: true ]
]

{ #category : #accessing }
AWSConfig >> useSSL: anObject [

	^self  at: #useSSL put: anObject
]
