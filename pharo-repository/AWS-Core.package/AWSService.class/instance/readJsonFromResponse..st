private
readJsonFromResponse: response

	^ (self defaultResponseClass on: response) value.

	