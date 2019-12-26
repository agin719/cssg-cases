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

uploadId = ''
eTag = ''

def putBucket():
    #.cssg-snippet-body-start:[put-bucket]
    response = client.create_bucket(
        Bucket='bucket-cssg-test-python-1253653367'
    )
    #.cssg-snippet-body-end

def deleteObject():
    #.cssg-snippet-body-start:[delete-object]
    response = client.delete_object(
        Bucket='bucket-cssg-test-python-1253653367',
        Key='object4python',
        VersionId='string',
    )
    assert response
    #.cssg-snippet-body-end

def deleteBucket():
    #.cssg-snippet-body-start:[delete-bucket]
    response = client.delete_bucket(
        Bucket='bucket-cssg-test-python-1253653367'
    )
    #.cssg-snippet-body-end

def putObject():
    #.cssg-snippet-body-start:[put-object]
    response = client.put_object(
        Bucket='bucket-cssg-test-python-1253653367',
        Body=b'bytes'|file,
        Key='object4python',
        EnableMD5=False
    )
    assert response
    #.cssg-snippet-body-end

def putObjectAcl():
    #.cssg-snippet-body-start:[put-object-acl]
    response = client.put_object_acl(
        Bucket='bucket-cssg-test-python-1253653367',
        Key='object4python',
        ACL='private'|'public-read',
        GrantFullControl='string',
        GrantRead='string',
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

def getObjectAcl():
    #.cssg-snippet-body-start:[get-object-acl]
    response = client.get_object_acl(
        Bucket='bucket-cssg-test-python-1253653367',
        Key='object4python'
    )
    assert response
    #.cssg-snippet-body-end

def headObject():
    #.cssg-snippet-body-start:[head-object]
    response = client.head_object(
        Bucket='bucket-cssg-test-python-1253653367',
        Key='object4python',
        VersionId='string',
        IfModifiedSince='Wed, 28 Oct 2014 20:30:00 GMT',
    )
    assert response
    #.cssg-snippet-body-end

def getObject():
    #.cssg-snippet-body-start:[get-object]
    response = client.get_object(
        Bucket='bucket-cssg-test-python-1253653367',
        Key='object4python',
        Range='string',
        IfMatch='"9a4802d5c99dafe1c04da0a8e7e166bf"',
        IfModifiedSince='Wed, 28 Oct 2014 20:30:00 GMT',
        IfNoneMatch='"9a4802d5c99dafe1c04da0a8e7e166bf"',
        IfUnmodifiedSince='Wed, 28 Oct 2014 20:30:00 GMT',
        ResponseCacheControl='string',
        ResponseContentDisposition='string',
        ResponseContentEncoding='string',
        ResponseContentLanguage='string',
        ResponseContentType='string',
        ResponseExpires='string',
        VersionId='string'
    )
    assert response
    #.cssg-snippet-body-end

def getPresignDownloadUrl():
    #.cssg-snippet-body-start:[get-presign-download-url]
    response = client.get_presigned_url(
        Method='GET',
        Bucket='bucket-cssg-test-python-1253653367',
        Key='object4python'
    )
    assert response
    #.cssg-snippet-body-end

def getPresignUploadUrl():
    #.cssg-snippet-body-start:[get-presign-upload-url]
    response = client.get_presigned_url(
        Method='PUT',
        Bucket='bucket-cssg-test-python-1253653367',
        Key='object4python'
    )
    assert response
    #.cssg-snippet-body-end

def deleteMultiObject():
    #.cssg-snippet-body-start:[delete-multi-object]
    response = client.delete_objects(
        Bucket='bucket-cssg-test-python-1253653367',
        Delete={
            'Object': [
                {
                    'Key': 'object4python1',
                    'VersionId': 'string'
                },
                {
                    'Key': 'object4python2',
                    'VersionId': 'string'
                },
            ],
            'Quiet': 'true'|'false'
        }
    )
    assert response
    #.cssg-snippet-body-end

def restoreObject():
    #.cssg-snippet-body-start:[restore-object]
    response = client.restore_object(
        Bucket='bucket-cssg-test-python-1253653367',
        Key='object4python',
        RestoreRequest={
            'Days': 100,
            'CASJobParameters': {
                'Tier': 'Expedited'|'Standard'|'Bulk'
            }
        }
    )
    #.cssg-snippet-body-end

def initMultiUpload():
    #.cssg-snippet-body-start:[init-multi-upload]
    response = client.create_multipart_upload(
        Bucket='bucket-cssg-test-python-1253653367',
        Key='multipart.txt',
        StorageClass='STANDARD'|'STANDARD_IA'|'ARCHIVE',
        Expires='string',
        CacheControl='string',
        ContentType='string',
        ContentDisposition='string',
        ContentEncoding='string',
        ContentLanguage='string',
        Metadata={
            'x-cos-meta-key1': 'value1',
            'x-cos-meta-key2': 'value2'
        },
        ACL='private'|'public-read',
        GrantFullControl='string',
        GrantRead='string'
    )
    # 获取UploadId供后续接口使用
    uploadid = response['UploadId']
    assert response
    #.cssg-snippet-body-end

def listMultiUpload():
    #.cssg-snippet-body-start:[list-multi-upload]
    response = client.list_multipart_uploads(
        Bucket='bucket-cssg-test-python-1253653367',
        Prefix='string',
        Delimiter='string',
        KeyMarker='string',
        UploadIdMarker='string',
        MaxUploads=100,
        EncodingType='url'
    )
    assert response
    #.cssg-snippet-body-end

def uploadPart():
    #.cssg-snippet-body-start:[upload-part]
    # 注意，上传分块的块数最多10000块
    response = client.upload_part(
        Bucket='bucket-cssg-test-python-1253653367',
        Key='object4python',
        Body=b'bytes'|file,
        PartNumber=1,
        UploadId='string',
        EnableMD5=False|True,
        ContentLength='123',
        ContentMD5='string'
    )
    assert response
    #.cssg-snippet-body-end

def listParts():
    #.cssg-snippet-body-start:[list-parts]
    response = client.list_parts(
        Bucket='bucket-cssg-test-python-1253653367',
        Key='object4python',
        UploadId=uploadid,
        MaxParts=1000,
        PartNumberMarker=100,
        EncodingType='url'
    )
    assert response
    #.cssg-snippet-body-end

def completeMultiUpload():
    #.cssg-snippet-body-start:[complete-multi-upload]
    response = client.complete_multipart_upload(
        Bucket='bucket-cssg-test-python-1253653367',
        Key='object4python',
        UploadId=uploadid,
        MultipartUpload={
            'Part': [
                {
                    'ETag': 'string',
                    'PartNumber': 1
                },
                {
                    'ETag': 'string',
                    'PartNumber': 2
                },
            ]
        },
    )
    assert response
    #.cssg-snippet-body-end

def abortMultiUpload():
    #.cssg-snippet-body-start:[abort-multi-upload]
    response = client.abort_multipart_upload(
        Bucket='bucket-cssg-test-python-1253653367',
        Key='object4python',
        UploadId=uploadid
    )
    assert response
    #.cssg-snippet-body-end

def transferUploadObject():
    #.cssg-snippet-body-start:[transfer-upload-object]
    response = client.upload_file(
        Bucket='bucket-cssg-test-python-1253653367',
        Key='object4python',
        LocalFilePath='local.txt',
        EnableMD5=False
    )
    assert response
    #.cssg-snippet-body-end

def copyObject():
    #.cssg-snippet-body-start:[copy-object]
    response = client.copy_object(
        Bucket='bucket-cssg-test-python-1253653367',
        Key='object4python',
        CopySource={
            'Bucket': 'bucket-cssg-source-1253653367', 
            'Key': 'sourceObject', 
            'Region': 'ap-guangzhou', #替换为源存储桶的 Region
            'VersionId': 'string'
        },
        CopyStatus='Copy'|'Replaced',
        ACL='private'|'public-read',
        GrantFullControl='string',
        GrantRead='string',
        StorageClass='STANDARD'|'STANDARD_IA',
        Expires='string',
        CacheControl='string',
        ContentType='string',
        ContentDisposition='string',
        ContentEncoding='string',
        ContentLanguage='string',
        Metadata={
            'x-cos-meta-key1': 'value1',
            'x-cos-meta-key2': 'value2'
        }
    )
    assert response
    #.cssg-snippet-body-end

def uploadPartCopy():
    #.cssg-snippet-body-start:[upload-part-copy]
    response = client.upload_part_copy(
        Bucket='bucket-cssg-test-python-1253653367',
        Key='object4python',
        PartNumber=100,
        UploadId='string',
        CopySource={
            'Bucket': 'bucket-cssg-source-1253653367', 
            'Key': 'sourceObject', 
            'Region': 'ap-guangzhou', #替换为源存储桶的 Region
            'VersionId': 'string'
        },
        CopySourceRange='string',
        CopySourceIfMatch='string',
        CopySourceIfModifiedSince='string',
        CopySourceIfNoneMatch='string',
        CopySourceIfUnmodifiedSince='string'
    )
    assert response
    #.cssg-snippet-body-end

def putObjectComp():
    #.cssg-snippet-body-start:[put-object-comp]
    response = client.put_object(
        Bucket='bucket-cssg-test-python-1253653367',
        Body=b'bytes'|file,
        Key='object4python',
        EnableMD5=False|True,
        ACL='private'|'public-read',  # 请慎用此参数,否则会达到1000条 ACL 上限
        GrantFullControl='string',
        GrantRead='string',
        StorageClass='STANDARD'|'STANDARD_IA'|'ARCHIVE',
        Expires='string',
        CacheControl='string',
        ContentType='string',
        ContentDisposition='string',
        ContentEncoding='string',
        ContentLanguage='string',
        ContentLength='123',
        ContentMD5='string',
        Metadata={
            'x-cos-meta-key1': 'value1',
            'x-cos-meta-key2': 'value2'
        }
    )
    assert response
    #.cssg-snippet-body-end

def putObjectCompComp():
    #.cssg-snippet-body-start:[put-object-comp-comp]
    #### 文件流简单上传（不支持超过5G的文件，推荐使用下方高级上传接口）
    # 强烈建议您以二进制模式(binary mode)打开文件,否则可能会导致错误
    with open('picture.jpg', 'rb') as fp:
        response = client.put_object(
            Bucket='bucket-cssg-test-python-1253653367',
            Body=fp,
            Key='picture.jpg',
            StorageClass='STANDARD',
            EnableMD5=False
        )
    print(response['ETag'])
    
    #### 字节流简单上传
    response = client.put_object(
        Bucket='bucket-cssg-test-python-1253653367',
        Body=b'bytes',
        Key='picture.jpg',
        EnableMD5=False
    )
    print(response['ETag'])
    
    
    #### chunk 简单上传
    import requests
    stream = requests.get('https://cloud.tencent.com/document/product/436/7778')
    
    # 网络流将以 Transfer-Encoding:chunked 的方式传输到 COS
    response = client.put_object(
        Bucket='bucket-cssg-test-python-1253653367',
        Body=stream,
        Key='picture.jpg'
    )
    print(response['ETag'])
    
    #### 高级上传接口（推荐）
    # 根据文件大小自动选择简单上传或分块上传，分块上传具备断点续传功能。
    response = client.upload_file(
        Bucket='bucket-cssg-test-python-1253653367',
        LocalFilePath='local.txt',
        Key='picture.jpg',
        PartSize=1,
        MAXThread=10,
        EnableMD5=False
    )
    print(response['ETag'])
    assert response
    #.cssg-snippet-body-end

def getObjectComp():
    #.cssg-snippet-body-start:[get-object-comp]
    ####  获取文件到本地
    response = client.get_object(
        Bucket='bucket-cssg-test-python-1253653367',
        Key='picture.jpg',
    )
    response['Body'].get_stream_to_file('output.txt')
    
    #### 获取文件流
    response = client.get_object(
        Bucket='bucket-cssg-test-python-1253653367',
        Key='picture.jpg',
    )
    fp = response['Body'].get_raw_stream()
    print(fp.read(2))
    
    #### 设置 Response HTTP 头部
    response = client.get_object(
        Bucket='bucket-cssg-test-python-1253653367',
        Key='picture.jpg',
        ResponseContentType='text/html; charset=utf-8'
    )
    print(response['Content-Type'])
    fp = response['Body'].get_raw_stream()
    print(fp.read(2))
    
    #### 指定下载范围
    response = client.get_object(
        Bucket='bucket-cssg-test-python-1253653367',
        Key='picture.jpg',
        Range='bytes=0-10'
    )
    fp = response['Body'].get_raw_stream()
    print(fp.read())
    assert response
    #.cssg-snippet-body-end

def deleteObjectComp():
    #.cssg-snippet-body-start:[delete-object-comp]
    # 删除object
    ## deleteObject
    response = client.delete_object(
        Bucket='bucket-cssg-test-python-1253653367',
        Key='object4python'
    )
    
    # 删除多个object
    ## deleteObjects
    response = client.delete_objects(
        Bucket='bucket-cssg-test-python-1253653367',
        Delete={
            'Object': [
                {
                    'Key': 'object4python1',
                },
                {
                    'Key': 'object4python2',
                },
            ],
            'Quiet': 'true'|'false'
        }
    )
    assert response
    #.cssg-snippet-body-end

def getPresignDownloadUrlAlias():
    #.cssg-snippet-body-start:[get-presign-download-url-alias]
    response = client.get_presigned_download_url(
        Bucket='bucket-cssg-test-python-1253653367',
        Key='object4python'
    )
    assert response
    #.cssg-snippet-body-end


def setUp():
    putBucket()

def tearDown():
    deleteObject()
    deleteBucket()

def testObjectMetadata():
    putObject()
    putObjectAcl()
    getObjectAcl()
    headObject()
    getObject()
    getPresignDownloadUrl()
    getPresignUploadUrl()
    deleteObject()
    deleteMultiObject()
    restoreObject()

def testObjectMultiUpload():
    initMultiUpload()
    listMultiUpload()
    uploadPart()
    listParts()
    completeMultiUpload()

def testObjectAbortMultiUpload():
    initMultiUpload()
    uploadPart()
    abortMultiUpload()

def testObjectTransfer():
    transferUploadObject()

def testObjectCopy():
    copyObject()
    initMultiUpload()
    uploadPartCopy()
    completeMultiUpload()

def testObjectComp():
    putObjectComp()
    putObjectCompComp()
    getObjectComp()
    deleteObjectComp()

def testPreisignUrl():
    getPresignDownloadUrlAlias()



if __name__ == "__main__":
    setUp()
    """
    testObjectMetadata()
    testObjectMultiUpload()
    testObjectAbortMultiUpload()
    testObjectTransfer()
    testObjectCopy()
    testObjectComp()
    testPreisignUrl()
    """
    tearDown()