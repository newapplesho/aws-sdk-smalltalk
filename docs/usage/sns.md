# SNS

See [Usage](../usage.md) for credential options, session tokens, and error
handling.

```smalltalk
AWSSNSConfig default
    accessKeyId: 'AWS_ACCESS_KEY_ID';
    secretKey: 'AWS_SECRET_ACCESS_KEY';
    regionName: 'eu-west-1'.

sns := AWSSNS new.

sns publishMessage: 'hello' arn: 'arn:aws:sns:eu-west-1:123456789012:my-topic'.
sns listPlatformApplications.
sns createPlatformEndpoint: 'device-token' inApplication: 'platform-application-arn'.
sns listEndpointsByPlatformApplication: 'platform-application-arn'.
```
