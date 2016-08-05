private
readFromResponse: response

	^ (self defaultResponseClass on: response) value.