tests-private
testDelete
	| d  keyData result |
	
	d:= DynamoDBDummyModel1  new.
	d id: uuid.
	d save.
	
	keyData := DynamoDBDummyModel1 new.
	keyData id: uuid.

	result := d getItem: keyData.
	
	self assert:(uuid = (result at:#id) ).
	
	d delete.