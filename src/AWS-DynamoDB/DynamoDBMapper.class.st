Class {
	#name : #DynamoDBMapper,
	#superclass : #Object,
	#category : #'AWS-DynamoDB'
}

{ #category : #private }
DynamoDBMapper >> checkCollectionType: anObject [
	anObject isEmpty ifTrue:[ ^ 'SS' ].
	anObject first isNumber ifTrue:[ ^ 'NS' ].
	anObject first isString ifTrue:[ ^ 'SS' ].
	 ^ 'BS'.
]

{ #category : #private }
DynamoDBMapper >> checkType: anObject key: aSymbol on: jsonObject [
	anObject isNumber 
		ifTrue:[ ^ jsonObject at: aSymbol asString put: (JsonObject new at:'N' put: anObject asString; yourself)  ].
	anObject isString 
		ifTrue:[  ^ jsonObject at: aSymbol asString put: (JsonObject new at:'S' put: anObject convertUTF8; yourself)   ].
	anObject isCollection
		 ifTrue:[ 
			| result |
			result := self checkCollectionType: anObject.
			
			(result ='NS') ifTrue:[ 
				| c |
				c := anObject collect:[:v | v asString ].
				^ jsonObject at: aSymbol asString put: (JsonObject new  at:'NS' put: c; yourself)  ].
			
			(result ='SS') ifTrue:[ 
				| c |
				c := anObject collect:[:v | v convertUTF8 ].
				^ jsonObject at: aSymbol asString put: (JsonObject new at:'SS' put: c; yourself)  ].
			
			(result ='BS') ifTrue:[ 
				| c |
				c := anObject collect:[:v | v asString ].
				^ jsonObject at: aSymbol asString put: (JsonObject new at:'BS' put: c; yourself) . ].
		 ].
	^ jsonObject at: aSymbol asString put: (JsonObject new at:'B' put: anObject asString ; yourself) 
		
]

{ #category : #private }
DynamoDBMapper >> convert: aDictionary [
	| jsonObject |
	jsonObject := JsonObject new.
       aDictionary keysDo: [:k | 
		| value boolean |
		value := aDictionary at: k .
		boolean:= value isString 
			ifTrue:[ value isEmptyOrNil  ] 
			ifFalse:[ value isNil ].
		boolean ifFalse:[ self  checkType: value  key: k on: jsonObject.] ].
	^ jsonObject. 
]

{ #category : #private }
DynamoDBMapper >> loadFrom: jsonObject [
	|  dict |

	dict := Dictionary new.
	jsonObject keysDo:[:k | | value |
		value := jsonObject at: k .
		self  loadType: value  key: k on: dict.].
	^ dict
	
]

{ #category : #private }
DynamoDBMapper >> loadItemString: anObject [
	| jsonObject dict |
	jsonObject := Json readFrom: anObject readStream.

	dict := Dictionary new.
	jsonObject keysDo: [:k | | value |
		value := jsonObject at: k .
		self  loadType: value  key: k on: dict.].
	^ dict
	
]

{ #category : #private }
DynamoDBMapper >> loadType: anObject key: aSymbol on: aDictionaryObject [

	(anObject keys includes:'N') ifTrue:[ ^ aDictionaryObject at: aSymbol asSymbol put:  (anObject at:'N') asNumber ].
	
	(anObject keys includes:'S')  ifTrue:[  ^ aDictionaryObject at: aSymbol asSymbol put: (anObject at:'S') "utf8ToPharo" ].
	
	(#('NS' 'SS' 'BS') includesAll: anObject keys  )
		 ifTrue:[ 
			
			(anObject keys includes:'NS')   ifTrue:[ 
				| c |
				c := (anObject at:'NS')  collect:[:v | v asNumber ].
				^ aDictionaryObject at: aSymbol asSymbol put: c ].
			
			(anObject keys includes:'SS') ifTrue:[ 
				| c |
				c := (anObject at:'SS')  collect:[:v | v "utf8ToPharo" ].
				^ aDictionaryObject at: aSymbol asSymbol put:  c ].
			
			(anObject keys includes:'BS')  ifTrue:[ 
				| c |
				c := anObject collect:[:v | v asString ].
				^ aDictionaryObject at: aSymbol asSymbol put: c. ].
		 ].
	^ aDictionaryObject at: aSymbol asSymbol put: (anObject at:'B').
		
]
