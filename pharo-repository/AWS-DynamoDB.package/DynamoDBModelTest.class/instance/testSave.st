tests-private
testSave

	| d  keyData result |
	
	d:= DModelTest1  new.
	d id: uuid.
	d save.
	
	keyData := DModelTest1 new.
	keyData id: uuid.

	result := d getItem: keyData.
	
	self assert:(uuid = (result at:#id) ).
	
	d delete.
	
	