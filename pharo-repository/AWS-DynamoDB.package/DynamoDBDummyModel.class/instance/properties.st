private
properties
	| dict |
	dict := self otherProperties.
	self accessors do: [:key |
		dict at: key put: (self perform: key)	
	].
	^dict