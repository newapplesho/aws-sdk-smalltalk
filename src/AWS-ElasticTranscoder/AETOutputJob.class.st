Class {
	#name : #AETOutputJob,
	#superclass : #JsonObject,
	#category : #'AWS-ElasticTranscoder-Model'
}

{ #category : #accessing }
AETOutputJob >> key [
	^ self at:'Key'
]

{ #category : #accessing }
AETOutputJob >> key: key [
	self at:'Key' put: key
]

{ #category : #accessing }
AETOutputJob >> presetId [
	^ self at:'PresetId'
]

{ #category : #accessing }
AETOutputJob >> presetId: presetId [
	self at:'PresetId' put: presetId
]
