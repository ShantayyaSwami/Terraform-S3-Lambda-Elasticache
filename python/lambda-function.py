
import json
import redis
import sys
import os
import logging
import boto3


log = logging.getLogger()
log.setLevel(logging.DEBUG)


def lambda_handler(event, context):
    redis_conn = None
    redis_endpoint = None
    redis_port = None

     # Check if the event is triggered by an S3 event
    if 'Records' in event and len(event['Records']) > 0:
        s3_event = event['Records'][0]  # Get the S3 event details
        bucket_name = s3_event['s3']['bucket']['name']  # Get the bucket name
        object_key = s3_event['s3']['object']['key']  # Get the object key (file path)

        # Fetch the timestamp of the updated or newly created file
        s3 = boto3.client('s3')
        response = s3.head_object(Bucket=bucket_name, Key=object_key)
        last_modified = response['LastModified']
        
        # Print the timestamp in the logs
        print(f"File {object_key} in bucket {bucket_name} was updated or created at: {last_modified}")
        
        # You can further process the timestamp or perform other actions here if needed
    else:
        print("This Lambda function was not triggered by an S3 event.")

    if "REDIS_HOST" in os.environ  and "REDIS_PORT" in os.environ:
        redis_endpoint = os.environ["REDIS_HOST"]
        redis_port = os.environ["REDIS_PORT"]
        log.debug("redis: " + redis_endpoint)
    else:
        log.debug(" REDIS_HOST REDIS_PORT configuration not set !")
        return {
            'statusCode': 500
        }
        
    try:
        log.debug('#Starting redis connection')
        redis_conn = redis.StrictRedis(host=redis_endpoint, port=redis_port)
        log.debug('connected')
        redis_conn.set('{object_key}', '{last_modified}')
        log.debug(redis_conn.get('{object_key}'))
    except Exception as ex:
        log.debug(f"failed to connect to redis: {ex.__class__} occurred")
        return {
            'statusCode': 500
        }
    finally:
        del redis_conn
        
    return {
        'statusCode': 200
    }

