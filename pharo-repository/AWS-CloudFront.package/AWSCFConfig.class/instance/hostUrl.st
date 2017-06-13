accessing
hostUrl
	"Amazon CloudFront distributions have a single endpoint: cloudfront.amazonaws.com and only supports HTTPS requests. http://docs.aws.amazon.com/general/latest/gr/rande.html#cf_region"
	^self at: #hostUrl ifAbsent: [ self hostUrl: self serviceName asLowercase, '.amazonaws.com'. ]