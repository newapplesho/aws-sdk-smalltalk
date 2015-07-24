private
loadFrom: jsonObject
	|  dict |

	dict := Dictionary new.
	jsonObject keysDo:[:k | | value |
		value := jsonObject at: k .
		self  loadType: value  key: k on: dict.].
	^ dict
	