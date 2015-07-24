tests-private
testSaveExpectedwithJson

	| d  keyData result |
	
	d:= DynamoDBDummyModel1  new.
	d id: uuid.
	d saveExpectedwithJson: '{"id":{"Exists":"false"}}'.
	
	keyData := DynamoDBDummyModel1 new.
	keyData id: uuid.

	result := d getItem: keyData.
	
	self assert:(uuid = (result at:#id) ).
	
	d delete.
	