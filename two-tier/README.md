# Basic Two-Tier Example

## Remote State

### Create a remote-state bucket

```sh
$ aws s3api create-bucket --bucket <bucket_name> \
--create-bucket-configuration LocationConstraint=ap-northeast-1
```

### Versioning

```sh
$ aws s3api put-bucket-versioning --bucket <bucket_name> \
--versioning-configuration Status=Enabled
```

### Encryption

```sh
$ aws s3api put-bucket-encryption --<bucket_name> \
--server-side-encryption-configuration '{
  "Rules": [    
    {     
      "ApplyServerSideEncryptionByDefault": {
        "SSEAlgorithm": "AES256"
      }
    }
  ]
}'
```

### Public acccess block

```sh
$ aws s3api put-public-access-block --bucket <bucket_name> \
--public-access-block-configuration '{
  "BlockPublicAcls": true,
  "IgnorePublicAcls": true, 
  "BlockPublicPolicy": true,
  "RestrictPublicBuckets": true
}'
```
