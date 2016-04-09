api-query
queryKeyConditionExpressionString: aString binding: aDictionary
	| query dynamoDbJson |
	query := DynamoDBQuery new.
	query setSelectAllAttributes.
	query keyConditionExpression:  aString.
	dynamoDbJson := self mapper convert: aDictionary.
	query expressionAttributeValues: dynamoDbJson.
	^ self query: query.
	