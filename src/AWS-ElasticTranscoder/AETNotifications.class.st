Class {
	#name : #AETNotifications,
	#superclass : #JsonObject,
	#category : #'AWS-ElasticTranscoder-Model'
}

{ #category : #'instance creation' }
AETNotifications class >> default [
	| notifications |
	notifications := self new.
	notifications progressing:''.
	notifications completed:''.
	notifications warning:''.
	notifications error:''.
	^ notifications
]

{ #category : #accessing }
AETNotifications >> completed [
	^ self at: 'Completed' ifAbsent:[ '' ].
]

{ #category : #accessing }
AETNotifications >> completed: completed [
	^ self at: 'Completed' put: completed
]

{ #category : #accessing }
AETNotifications >> error [
	^ self at: 'Error' ifAbsent:[ '' ].
]

{ #category : #accessing }
AETNotifications >> error: error [
	^ self at: 'Error' put: error
]

{ #category : #accessing }
AETNotifications >> progressing [
	^ self at: 'Progressing' ifAbsent:[ '' ].
]

{ #category : #accessing }
AETNotifications >> progressing: progressing [
	^ self at: 'Progressing' put: progressing
]

{ #category : #accessing }
AETNotifications >> warning [
	^ self at: 'Warning' ifAbsent:[ '' ].
]

{ #category : #accessing }
AETNotifications >> warning: warning [
	^ self at: 'Warning' put: warning
]
