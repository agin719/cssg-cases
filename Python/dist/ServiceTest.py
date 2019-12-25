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


def getService():
    #.cssg-snippet-body-start:[get-service]
    response = client.list_buckets(
    )
    assert response
    #.cssg-snippet-body-end

def getAuthorizationDownload():
    #.cssg-snippet-body-start:[get-authorization-download]
    response = client.get_auth(
        Method='GET',
        Bucket='bucket-cssg-test-python-1253653367',
        Key='object4python'
    )
    assert response
    #.cssg-snippet-body-end

def getAuthorizationUpload():
    #.cssg-snippet-body-start:[get-authorization-upload]
    response = client.get_auth(
        Method='PUT',
        Bucket='bucket-cssg-test-python-1253653367',
        Key='object4python'
    )
    assert response
    #.cssg-snippet-body-end


def setUp():
    pass

def tearDown():
    pass

def testGetService():
    getService()

def testGetAuthorization():
    getAuthorizationDownload()
    getAuthorizationUpload()



if __name__ == "__main__":
    setUp()
    """
    testGetService()
    testGetAuthorization()
    """
    tearDown()