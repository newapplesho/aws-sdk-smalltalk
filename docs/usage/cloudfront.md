# CloudFront

See [Usage](../usage.md) for credential options and error handling.

```smalltalk
AWSCFConfig initialize.
AWSCFConfig default
    accessKeyId: 'AWS_ACCESS_KEY_ID';
    secretKey: 'AWS_SECRET_ACCESS_KEY'.

cf := CloudFront new distributionId: 'distribution_ID'.

batch := CFInvalidationBatch new.
batch addPath: '/test1.jpg'.
batch addPath: '/test2.jpg'.
cf postInvalidation: batch.

cf getInvalidationList.
cf getInvalidation: 'invalidation_ID'.
```
