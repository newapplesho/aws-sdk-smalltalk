# STS

See [Usage](../usage.md) for credential options and error handling.

```smalltalk
AWSSTSConfig default
    accessKeyId: 'AWS_ACCESS_KEY_ID';
    secretKey: 'AWS_SECRET_ACCESS_KEY'.

STS new
    assumeRoleRoleArn: 'arn:aws:iam::123456789012:role/demo'
    roleSessionName: 'Bob'.

STS new getSessionToken.
```

Both calls return the parsed XML response. Read the credentials out of it and
feed them to another service's config via `accessKeyId:`, `secretKey:` and
`sessionToken:`.
