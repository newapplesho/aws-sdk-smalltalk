# Lambda

See [Usage](../usage.md) for credential options, session tokens, and error
handling.

```smalltalk
AWSLambdaConfig default
    accessKeyId: 'AWS_ACCESS_KEY_ID';
    secretKey: 'AWS_SECRET_ACCESS_KEY';
    regionName: 'ap-northeast-1'.

client := AWSLambda new.
client invokeLambda: 'LambdaName' withPayload: '["json payload"]'.
```
