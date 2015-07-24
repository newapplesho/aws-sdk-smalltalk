api-query
queryKeyConditionExpressionString: aString binding: aDictionary
	| query dynamoDBJson |
	query := DynamoDBQuery new.
	query setSelectAllAttributes.
	query keyConditionExpression:  aString.
	dynamoDBJson := mapper convertDynamoDBJson: aDictionary.
	query expressionAttributeValues: dynamoDBJson.
	^ self query: query.
	