# -*- coding=utf-8
import os

#.cssg-snippet-body-start:[global-init]
# APPID 已在配置中移除,请在参数 Bucket 中带上 APPID。Bucket 由 BucketName-APPID 组成
# 1. 设置用户配置, 包括 secretId，secretKey 以及 Region
# -*- coding=utf-8
from qcloud_cos import CosConfig
from qcloud_cos import CosS3Client
import sys
import logging

logging.basicConfig(level=logging.INFO, stream=sys.stdout)

secret_id = os.environ['COS_KEY']      # 替换为用户的 secretId
secret_key = os.environ['COS_SECRET']      # 替换为用户的 secretKey
region = 'ap-beijing'     # 替换为用户的 Region
token = None                # 使用临时密钥需要传入 Token，默认为空，可不填
scheme = 'https'            # 指定使用 http/https 协议来访问 COS，默认为 https，可不填
config = CosConfig(Region=region, SecretId=secret_id, SecretKey=secret_key, Token=token, Scheme=scheme)
# 2. 获取客户端对象
client = CosS3Client(config)
# 参照下文的描述。或者参照 Demo 程序，详见 https://github.com/tencentyun/cos-python-sdk-v5/blob/master/qcloud_cos/demo.py
#.cssg-snippet-body-end


def putBucketComp():
    #.cssg-snippet-body-start:[put-bucket-comp]
    response = client.create_bucket(
        Bucket='bucket-cssg-test-python-1253653367',
        ACL='private'|'public-read'|'public-read-write',
        GrantFullControl='string',
        GrantRead='string',
        GrantWrite='string'    
    )
    #.cssg-snippet-body-end

def deleteBucket():
    #.cssg-snippet-body-start:[delete-bucket]
    response = client.delete_bucket(
        Bucket='bucket-cssg-test-python-1253653367'
    )
    #.cssg-snippet-body-end

def getBucket():
    #.cssg-snippet-body-start:[get-bucket]
    response = client.list_objects(
        Bucket='bucket-cssg-test-python-1253653367',
        Prefix='folder1'
    )
    assert response
    #.cssg-snippet-body-end

def getBucketRecursive():
    #.cssg-snippet-body-start:[get-bucket-recursive]
    marker = ""
    while True:
        response = client.list_objects(
            Bucket='bucket-cssg-test-python-1253653367',
            Prefix='folder1',
            Marker=marker
        )
        print(response['Contents'])
        if response['IsTruncated'] == 'false':
            break 
        marker = response['NextMarker']
    assert response
    #.cssg-snippet-body-end

def getBucketComp():
    #.cssg-snippet-body-start:[get-bucket-comp]
    response = client.list_objects(
        Bucket='bucket-cssg-test-python-1253653367',
        Prefix='string',
        Delimiter='/',
        Marker='string',
        MaxKeys=100,
        EncodingType='url'
    )
    assert response
    #.cssg-snippet-body-end

def listObjectVersioning():
    #.cssg-snippet-body-start:[list-object-versioning]
    response = client.list_objects_versions(
        Bucket='bucket-cssg-test-python-1253653367',
        Prefix='string'
    )
    assert response
    #.cssg-snippet-body-end

def listObjectVersioningComp():
    #.cssg-snippet-body-start:[list-object-versioning-comp]
    response = client.list_objects_versions(
        Bucket='bucket-cssg-test-python-1253653367',
        Prefix='string',
        Delimiter='/',
        KeyMarker='string',
        VersionIdMarker='string',
        MaxKeys=100,
        EncodingType='url'
    )
    assert response
    #.cssg-snippet-body-end

def headBucket():
    #.cssg-snippet-body-start:[head-bucket]
    response = client.head_bucket(
        Bucket='bucket-cssg-test-python-1253653367'
    )
    assert response
    #.cssg-snippet-body-end

def putBucketAcl():
    #.cssg-snippet-body-start:[put-bucket-acl]
    response = client.put_bucket_acl(
        Bucket='bucket-cssg-test-python-1253653367',
        ACL='private'|'public-read'|'public-read-write',
        GrantFullControl='string',
        GrantRead='string',
        GrantWrite='string',
        AccessControlPolicy={
            'AccessControlList': {
                'Grant': [
                    {
                        'Grantee': {
                            'DisplayName': 'string',
                            'Type': 'CanonicalUser'|'Group',
                            'ID': 'string',
                            'URI': 'string'
                        },
                        'Permission': 'FULL_CONTROL'|'WRITE'|'READ'
                    },
                ]
            },
            'Owner': {
                'DisplayName': 'string',
                'ID': 'string'
            }
        }
    )
    assert response
    #.cssg-snippet-body-end

def getBucketAcl():
    #.cssg-snippet-body-start:[get-bucket-acl]
    response = client.get_bucket_acl(
        Bucket='bucket-cssg-test-python-1253653367',
    )
    assert response
    #.cssg-snippet-body-end

def putBucketCors():
    #.cssg-snippet-body-start:[put-bucket-cors]
    response = client.put_bucket_cors(
        Bucket='bucket-cssg-test-python-1253653367',
        CORSConfiguration={
            'CORSRule': [
                {
                    'ID': 'string',
                    'MaxAgeSeconds': 100,
                    'AllowedOrigin': [
                        'string',
                    ],
                    'AllowedMethod': [
                        'string',
                    ],
                    'AllowedHeader': [
                        'string',
                    ],
                    'ExposeHeader': [
                        'string',
                    ]
                }
            ]
        },
    )
    assert response
    #.cssg-snippet-body-end

def getBucketCors():
    #.cssg-snippet-body-start:[get-bucket-cors]
    response = client.get_bucket_cors(
        Bucket='bucket-cssg-test-python-1253653367',
    )
    assert response
    #.cssg-snippet-body-end

def deleteBucketCors():
    #.cssg-snippet-body-start:[delete-bucket-cors]
    response = client.delete_bucket_cors(
        Bucket='bucket-cssg-test-python-1253653367',
    )
    assert response
    #.cssg-snippet-body-end

def putBucketLifecycle():
    #.cssg-snippet-body-start:[put-bucket-lifecycle]
    from qcloud_cos import get_date
    response = client.put_bucket_lifecycle(
        Bucket='bucket-cssg-test-python-1253653367',
        LifecycleConfiguration={
            'Rule': [
                {
                    'ID': 'string',
                    'Filter': {
                        'Prefix': 'string',
                        'Tag': [
                            {
                                'Key': 'string',
                                'Value': 'string'
                            }
                        ]
                    },
                    'Status': 'Enabled'|'Disabled',
                    'Expiration': {
                        'Days': 100,
                        'Date': get_date(2018, 4, 20)
                    },
                    'Transition': [
                        {
                            'Days': 100,
                            'Date': get_date(2018, 4, 20),
                            'StorageClass': 'Standard_IA'|'Archive'
                        },
                    ],
                    'NoncurrentVersionExpiration': {
                        'NoncurrentDays': 100
                    },
                    'NoncurrentVersionTransition': [
                        {
                            'NoncurrentDays': 100,
                            'StorageClass': 'Standard_IA'
                        },
                    ],
                    'AbortIncompleteMultipartUpload': {
                        'DaysAfterInitiation': 100
                    }
                }
            ]   
        }
    )
    assert response
    #.cssg-snippet-body-end

def getBucketLifecycle():
    #.cssg-snippet-body-start:[get-bucket-lifecycle]
    response = client.get_bucket_lifecycle(
        Bucket='bucket-cssg-test-python-1253653367',
    )
    assert response
    #.cssg-snippet-body-end

def deleteBucketLifecycle():
    #.cssg-snippet-body-start:[delete-bucket-lifecycle]
    response = client.delete_bucket_lifecycle(
        Bucket='bucket-cssg-test-python-1253653367',
    )
    assert response
    #.cssg-snippet-body-end

def putBucketVersioning():
    #.cssg-snippet-body-start:[put-bucket-versioning]
    response = client.put_bucket_versioning(
        Bucket='bucket-cssg-test-python-1253653367',
        Status='Enabled'
    )
    assert response
    #.cssg-snippet-body-end

def getBucketVersioning():
    #.cssg-snippet-body-start:[get-bucket-versioning]
    response = client.get_bucket_versioning(
        Bucket='bucket-cssg-test-python-1253653367',
    )
    assert response
    #.cssg-snippet-body-end

def putBucketReplication():
    #.cssg-snippet-body-start:[put-bucket-replication]
    response = client.put_bucket_replication(
        Bucket='bucket-cssg-test-python-1253653367',
        ReplicationConfiguration={
            'Role': 'qcs::cam::uin/1278687956:uin/1278687956',
            'Rule': [
                {
                    'ID': 'string',
                    'Status': 'Enabled'|'Disabled',
                    'Prefix': 'string',
                    'Destination': {
                        'Bucket': 'qcs::cos:ap-beijing::bucket-cssg-assist-1253653367',
                        'StorageClass': 'STANDARD'|'STANDARD_IA'
                    }
                },
                {
                    'ID': 'string',
                    'Status': 'Enabled'|'Disabled',
                    'Prefix': 'string',
                    'Destination': {
                        'Bucket': 'qcs::cos:ap-beijing::destinationbucket2-1253653367',
                        'StorageClass': 'STANDARD'|'STANDARD_IA'
                    }
                },
            ]   
        }
    )
    assert response
    #.cssg-snippet-body-end

def getBucketReplication():
    #.cssg-snippet-body-start:[get-bucket-replication]
    response = client.get_bucket_replication(
        Bucket='bucket-cssg-test-python-1253653367'
    )
    assert response
    #.cssg-snippet-body-end

def deleteBucketReplication():
    #.cssg-snippet-body-start:[delete-bucket-replication]
    response = client.delete_bucket_replication(
        Bucket='bucket-cssg-test-python-1253653367',
    )
    assert response
    #.cssg-snippet-body-end


def setUp():
    putBucketComp()

def tearDown():
    deleteBucket()

def testBucketACL():
    getBucket()
    getBucketRecursive()
    getBucketComp()
    listObjectVersioning()
    listObjectVersioningComp()
    headBucket()
    putBucketAcl()
    getBucketAcl()

def testBucketCORS():
    putBucketCors()
    getBucketCors()
    deleteBucketCors()

def testBucketLifecycle():
    putBucketLifecycle()
    getBucketLifecycle()
    deleteBucketLifecycle()

def testBucketReplicationAndVersioning():
    putBucketVersioning()
    getBucketVersioning()
    putBucketReplication()
    getBucketReplication()
    deleteBucketReplication()



if __name__ == "__main__":
    setUp()
    """
    testBucketACL()
    testBucketCORS()
    testBucketLifecycle()
    testBucketReplicationAndVersioning()
    """
    tearDown()