api-getItem
getItem: aDynamoDBGetItem
	| jsonObject |
	jsonObject := self action: aDynamoDBGetItem.
	jsonObject ifEmpty:[ ^ jsonObject ].
	^ mapper loadFrom: (jsonObject at:'Item') .