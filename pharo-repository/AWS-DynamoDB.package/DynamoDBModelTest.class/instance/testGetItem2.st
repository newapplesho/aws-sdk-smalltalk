tests-private
testGetItem2

	| d  keyData result |
	
	d:= DModelTest1  new.
	d id: uuid.
	d data at:#jpString put:'あ'.
	d save.
	
	keyData := DModelTest1 new.
	keyData id: uuid.

	result := d getItem: keyData.
	
	self assert:('あ' = (result at:#jpString) ).
	
	self assert:('い' ~= (result at:#jpString) ).