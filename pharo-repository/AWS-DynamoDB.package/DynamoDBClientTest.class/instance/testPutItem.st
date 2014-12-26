tests-private
testPutItem

	| dy  d |
	
	dy := DynamoDBClient new.

	d:= DModelTest1  new.
	d id: uuid.

	dy putItem: d .