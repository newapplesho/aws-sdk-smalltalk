private
loadItem: jsonObject
	|  dict |

	dict := Dictionary new.
	jsonObject keys do:[:k | | value |
		value := jsonObject at: k .
		self  loadType: value  key: k on: dict.].
	^ dict
	