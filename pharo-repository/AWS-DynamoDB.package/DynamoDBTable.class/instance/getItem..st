api-getItem
getItem: aDynamoDBGetItem
	| jsonObject |
	jsonObject := self action: aDynamoDBGetItem.
	^ mapper loadFrom:  (jsonObject at:'Item') .