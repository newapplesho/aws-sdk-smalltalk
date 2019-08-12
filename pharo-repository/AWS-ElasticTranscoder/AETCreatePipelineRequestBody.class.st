"
http://docs.aws.amazon.com/elastictranscoder/latest/developerguide/create-pipeline.html
"
Class {
	#name : #AETCreatePipelineRequestBody,
	#superclass : #JsonObject,
	#category : 'AWS-ElasticTranscoder-Model'
}

{ #category : #accessing }
AETCreatePipelineRequestBody >> awsKmsKeyArn: awsKmsKeyArn [
	self at: 'AwsKmsKeyArn' put: awsKmsKeyArn.
]

{ #category : #accessing }
AETCreatePipelineRequestBody >> contentConfig [
	^ self at: 'ContentConfig'.
]

{ #category : #accessing }
AETCreatePipelineRequestBody >> contentConfig: contentConfig [
	self at: 'ContentConfig' put: contentConfig.
]

{ #category : #accessing }
AETCreatePipelineRequestBody >> inputBucket [
	^ self at: 'InputBucket'.
]

{ #category : #accessing }
AETCreatePipelineRequestBody >> inputBucket: inputBucket [
	self at: 'InputBucket' put: inputBucket.
]

{ #category : #accessing }
AETCreatePipelineRequestBody >> notifications [
	^ self at: 'Notifications'.
]

{ #category : #accessing }
AETCreatePipelineRequestBody >> notifications: notifications [
	self at: 'Notifications' put: notifications.
]

{ #category : #accessing }
AETCreatePipelineRequestBody >> outputBucket [
	^ self at: 'OutputBucket'.
]

{ #category : #accessing }
AETCreatePipelineRequestBody >> outputBucket: outputBucket [
	self at: 'OutputBucket' put: outputBucket.
]

{ #category : #accessing }
AETCreatePipelineRequestBody >> pipelineName [
	^ self at: 'Name'
]

{ #category : #accessing }
AETCreatePipelineRequestBody >> pipelineName: pipeLineName [
	self at: 'Name' put: pipeLineName.
]

{ #category : #accessing }
AETCreatePipelineRequestBody >> role [
	^ self at: 'Role'
]

{ #category : #accessing }
AETCreatePipelineRequestBody >> role: role [
	self at: 'Role' put: role.
]

{ #category : #accessing }
AETCreatePipelineRequestBody >> thumbnailConfig [
	^ self at: 'ThumbnailConfig'
]

{ #category : #accessing }
AETCreatePipelineRequestBody >> thumbnailConfig: thumbnailConfig [
	self at: 'ThumbnailConfig' put: thumbnailConfig.
]
