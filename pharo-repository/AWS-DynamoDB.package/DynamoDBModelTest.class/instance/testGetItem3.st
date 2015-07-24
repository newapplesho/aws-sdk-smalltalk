tests-private
testGetItem3

	| d  keyData result |
	
	d:= DynamoDBDummyModel1  new.
	d id: uuid.
	d data at:#jpString put: #('あ' 'い' 'x').
	d save.
	
	keyData := DynamoDBDummyModel1 new.
	keyData id: uuid.

	result := d getItem: keyData.
	
	self assert:((result at:#jpString) includes: 'あ'  ).
	
	self assert:( (result at:#jpString) includes: 'い' ).
	
	self assert:( (result at:#jpString) includes: 'x' ).