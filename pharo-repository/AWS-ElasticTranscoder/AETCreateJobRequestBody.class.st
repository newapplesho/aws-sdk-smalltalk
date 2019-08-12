Class {
	#name : #AETCreateJobRequestBody,
	#superclass : #JsonObject,
	#category : 'AWS-ElasticTranscoder-Model'
}

{ #category : #accessing }
AETCreateJobRequestBody >> input [
	^ self at:'Input'
]

{ #category : #accessing }
AETCreateJobRequestBody >> input: input [
	self at:'Input' put: input
]

{ #category : #accessing }
AETCreateJobRequestBody >> outputs [
	^ self at:'Outputs'
]

{ #category : #accessing }
AETCreateJobRequestBody >> outputs: outputs [
	self at:'Outputs' put: outputs
]

{ #category : #accessing }
AETCreateJobRequestBody >> pipelineId [
	^ self at:'pipelineId'
]

{ #category : #accessing }
AETCreateJobRequestBody >> pipelineId: pipelineId [
	self at:'PipelineId' put: pipelineId
]
