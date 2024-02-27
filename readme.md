# Assignment 1:
## 1.Create a terraform project that creates the following resources:
```
a. AWS Elas<Cache (Redis) cluster
b. AWS Lambda (Python)
c. 2 S3 Buckets (‘staging’, ‘prod’)
```
## 2. Each S3 bucket should contain a single ‘index.html’ file.
## 3. The lambda func<on should be triggered every 5 minutes and do the following:
```
a. Get last update <mestamps of both index.html in both s3 buckets.
b. If staging html file is more recent than prod - overwrite prod with content from
staging.
c. On each lambda invoke, it will write to Elas<Cache a key:value pair in the following format: {“<InvokeTimestamp>“:”<ProdUpdated>(bool)“}
```

OR

# Assignment 2:
## 1. Create a terraform project that creates the following resources:
```
a. AWS Elas<Cache (Redis) cluster
b. AWS Lambda (Python)
c. S3 Bucket
```
## 2. Lambda func<on should monitor the S3 bucket for files created
## 3. Once lambda triggered by new file wri\en or updated, it will write to Elas<Cache a
key:value pair in the following format: {“<FileName>“:”<Crea<onTimestamp>“}
