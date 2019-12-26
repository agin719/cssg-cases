<?php

use Qcloud\Cos\Client;
use Qcloud\Cos\Exception\ServiceResponseException;

class ObjectTest extends \PHPUnit\Framework\TestCase
{
    private $cosClient;
    private $bucket;
    private $region;

    private $uploadId;
    private $eTag;

    protected function putBucket() {
        //.cssg-snippet-body-start:[put-bucket]
        try {
            $bucket = "bucket-cssg-test-php-1253653367"; //存储桶名称 格式：BucketName-APPID
            $result = $cosClient->createBucket(array('Bucket' => $bucket));
            //请求成功
            print_r($result);
        } catch (\Exception $e) {
            //请求失败
            echo($e);
        }
        //.cssg-snippet-body-end
    }

    protected function deleteObject() {
        //.cssg-snippet-body-start:[delete-object]
        try {
            $result = $cosClient->deleteObject(array(
                'Bucket' => 'bucket-cssg-test-php-1253653367', //格式：BucketName-APPID
                'Key' => 'object4php',
                'VersionId' => 'string'
            )); 
            // 请求成功
            print_r($result);
        } catch (\Exception $e) {
            // 请求失败
            echo($e);
            $this->assertNull($e);
        }
        //.cssg-snippet-body-end
    }

    protected function deleteBucket() {
        //.cssg-snippet-body-start:[delete-bucket]
        try {
            $result = $cosClient->deleteBucket(array(
                'Bucket' => 'bucket-cssg-test-php-1253653367' //格式：BucketName-APPID
            )); 
            // 请求成功
            print_r($result);
        } catch (\Exception $e) {
            // 请求失败
            echo($e);
        }
        //.cssg-snippet-body-end
    }

    protected function putObject() {
        //.cssg-snippet-body-start:[put-object]
        try { 
            $result = $cosClient->putObject(array( 
                'Bucket' => 'bucket-cssg-test-php-1253653367', //格式：BucketName-APPID 
                'Key' => 'object4php', 
                'Body' => fopen('/data/object4php', 'rb'), 
                /*
                'ACL' => 'string',
                'CacheControl' => 'string',
                'ContentDisposition' => 'string',
                'ContentEncoding' => 'string',
                'ContentLanguage' => 'string',
                'ContentLength' => integer,
                'ContentType' => 'string',
                'Expires' => 'string',
                'GrantFullControl' => 'string',
                'GrantRead' => 'string',
                'GrantWrite' => 'string',
                'Metadata' => array(
                'string' => 'string',
                ),
                'ContentMD5' => 'string',
                'ServerSideEncryption' => 'string',
                'StorageClass' => 'string'
                */
            )); 
            // 请求成功 
            print_r($result); 
        } catch (\Exception $e) { 
            // 请求失败 
            echo($e); 
            $this->assertNull($e);
        }
        //.cssg-snippet-body-end
    }

    protected function putObjectAcl() {
        //.cssg-snippet-body-start:[put-object-acl]
        try {
            $result = $cosClient->putObjectAcl(array(
                'Bucket' => 'bucket-cssg-test-php-1253653367', //格式：BucketName-APPID
                'Key' => 'object4php',
                'ACL' => 'private',
                'Grants' => array(
                    array(
                        'Grantee' => array(
                            'DisplayName' => 'qcs::cam::uin/1278687956:uin/1278687956',
                            'ID' => 'qcs::cam::uin/1278687956:uin/1278687956',
                            'Type' => 'CanonicalUser',
                        ),  
                        'Permission' => 'FULL_CONTROL',
                    ),  
                    // ... repeated
                ),  
                'Owner' => array(
                    'DisplayName' => 'qcs::cam::uin/1278687956:uin/1278687956',
                    'ID' => 'qcs::cam::uin/1278687956:uin/1278687956',
                )));
            // 请求成功
            print_r($result);
        } catch (\Exception $e) {
            // 请求失败
            echo "$e\n";
            $this->assertNull($e);
        }
        //.cssg-snippet-body-end
    }

    protected function getObjectAcl() {
        //.cssg-snippet-body-start:[get-object-acl]
        try {
            $result = $cosClient->getObjectAcl(array(
                'Bucket' => 'bucket-cssg-test-php-1253653367', //格式：BucketName-APPID
                'Key' => 'object4php',
            )); 
            // 请求成功
            print_r($result);
        } catch (\Exception $e) {
            // 请求失败
            echo($e);
            $this->assertNull($e);
        }
        //.cssg-snippet-body-end
    }

    protected function headObject() {
        //.cssg-snippet-body-start:[head-object]
        $cosClient = new Qcloud\Cos\Client(
            array(
                'region' => $region,
                'schema' => 'https', //协议头部，默认为 http
                'credentials'=> array(
                    'secretId'  => $secretId ,
                    'secretKey' => $secretKey)));
        try {
            $result = $cosClient->headObject(array(
                'Bucket' => 'bucket-cssg-test-php-1253653367', //格式：BucketName-APPID
                'Key' => 'object4php',
            )); 
            // 请求成功
            print_r($result);
        } catch (\Exception $e) {
            // 请求失败
            echo($e);
            $this->assertNull($e);
        }
        //.cssg-snippet-body-end
    }

    protected function getObject() {
        //.cssg-snippet-body-start:[get-object]
        try {
            $result = $cosClient->getObject(array(
                'Bucket' => 'bucket-cssg-test-php-1253653367', //格式：BucketName-APPID
                'Key' => 'object4php',
                'SaveAs' => '/data/object4php',
                /*
                'Range' => 'bytes=0-10',
                'VersionId' => 'string',
                'ResponseCacheControl' => 'string',
                'ResponseContentDisposition' => 'string',
                'ResponseContentEncoding' => 'string',
                'ResponseContentLanguage' => 'string',
                'ResponseContentType' => 'string',
                'ResponseExpires' => 'string',
                */
            )); 
            // 请求成功
            print_r($result);
        } catch (\Exception $e) {
            // 请求失败
            echo($e);
            $this->assertNull($e);
        }
        //.cssg-snippet-body-end
    }

    protected function getPresignDownloadUrl() {
        //.cssg-snippet-body-start:[get-presign-download-url]
        $secretId = getenv('COS_KEY'); //替换为您的永久密钥 SecretId
        $secretKey = getenv('COS_SECRET'); //替换为您的永久密钥 SecretKey
        $region = "ap-beijing"; //设置一个默认的存储桶地域
        $cosClient = new Qcloud\Cos\Client(
            array(
                'region' => $region,
                'schema' => 'https', //协议头部，默认为 http
                'credentials'=> array(
                    'secretId'  => $secretId,
                    'secretKey' => $secretKey)));
        ### 简单下载预签名
        try {
            $signedUrl = $cosClient->getPresignetUrl('getObject', array(
                'Bucket' => "bucket-cssg-test-php-1253653367", //存储桶，格式：BucketName-APPID
                'Key' => "object4php", //对象在存储桶中的位置，即对象键
                ), '+10 minutes'); //签名的有效时间
            // 请求成功
            echo ($signedUrl);
        } catch (\Exception $e) {
            // 请求失败
            echo($e);
            $this->assertNull($e);
        }
        
        ### 使用封装的 getObjectUrl 获取下载签名
        try {    
            $bucket = "bucket-cssg-test-php-1253653367"; //存储桶，格式：BucketName-APPID
            $key = "object4php"; //对象在存储桶中的位置，即对象键
            $signedUrl = $cosClient->getObjectUrl($bucket, $key, '+10 minutes'); //签名的有效时间
            // 请求成功
            echo $signedUrl;
        } catch (\Exception $e) {
            // 请求失败
            print_r($e);
        }
        //.cssg-snippet-body-end
    }

    protected function getPresignUploadUrl() {
        //.cssg-snippet-body-start:[get-presign-upload-url]
        $secretId = getenv('COS_KEY'); //替换为您的永久密钥 SecretId
        $secretKey = getenv('COS_SECRET'); //替换为您的永久密钥 SecretKey
        $region = "ap-beijing"; //设置一个默认的存储桶地域
        $cosClient = new Qcloud\Cos\Client(
            array(
                'region' => $region,
                'schema' => 'https', //协议头部，默认为 http
                'credentials'=> array(
                    'secretId'  => $secretId ,
                    'secretKey' => $secretKey)));
        ### 简单上传预签名
        try {
            $signedUrl = $cosClient->getPresignetUrl('putObject', array(
                'Bucket' => "bucket-cssg-test-php-1253653367", //存储桶，格式：BucketName-APPID
                'Key' => "object4php", //对象在存储桶中的位置，即对象键
                'Body' => 'string' //可为空或任意字符串
            ), '+10 minutes'); //签名的有效时间
            // 请求成功
            echo ($signedUrl);
        } catch (\Exception $e) {
            // 请求失败
            echo($e);
            $this->assertNull($e);
        }
        
        ### 分块上传预签名
        try {
            $signedUrl = $cosClient->getPresignetUrl('uploadPart', array(
                    'Bucket' => "bucket-cssg-test-php-1253653367", //存储桶，格式：BucketName-APPID
                    'Key' => "object4php", //对象在存储桶中的位置，即对象键
                    'UploadId' => 'string',
                    'PartNumber' => '1',
                    'Body' => 'string'), '+10 minutes'); //签名的有效时间
            // 请求成功
            echo ($signedUrl);
        } catch (\Exception $e) {
            // 请求失败
            echo($e);
            $this->assertNull($e);
        }
        //.cssg-snippet-body-end
    }

    protected function deleteMultiObject() {
        //.cssg-snippet-body-start:[delete-multi-object]
        try {
            $result = $cosClient->deleteObjects(array(
                'Bucket' => 'bucket-cssg-test-php-1253653367', //格式：BucketName-APPID
                'Objects' => array(
                    array(
                        'Key' => 'object4php',
                        'VersionId' => 'string'
                    ),  
                    // ... repeated
                ),  
            )); 
            // 请求成功
            print_r($result);
        } catch (\Exception $e) {
            // 请求失败
            echo($e);
            $this->assertNull($e);
        }
        //.cssg-snippet-body-end
    }

    protected function restoreObject() {
        //.cssg-snippet-body-start:[restore-object]
        try {
            $result = $cosClient->restoreObject(array(
                'Bucket' => 'bucket-cssg-test-php-1253653367', //格式：BucketName-APPID
                'Key' => 'object4php',
                'Days' => integer,
                'CASJobParameters' => array(
                    'Tier' =>'string'
                )    
            )); 
            // 请求成功
            print_r($result);
        } catch (\Exception $e) {
            // 请求失败
            echo($e);
        }
        //.cssg-snippet-body-end
    }

    protected function initMultiUpload() {
        //.cssg-snippet-body-start:[init-multi-upload]
        try {
            $result = $cosClient->createMultipartUpload(array(
                'Bucket' => 'bucket-cssg-test-php-1253653367', //格式：BucketName-APPID
                'Key' => 'object4php',
                /*  
                'CacheControl' => 'string',
                'ContentDisposition' => 'string',
                'ContentEncoding' => 'string',
                'ContentLanguage' => 'string',
                'ContentLength' => integer,
                'ContentType' => 'string',
                'Expires' => 'string',
                'Metadata' => array(
                    'string' => 'string',
                ),
                'StorageClass' => 'string'
                */
            )); 
            // 请求成功
            print_r($result);
        } catch (\Exception $e) {
            // 请求失败
            echo($e);
            $this->assertNull($e);
        }
        //.cssg-snippet-body-end
    }

    protected function listMultiUpload() {
        //.cssg-snippet-body-start:[list-multi-upload]
        try {
            $result = $cosClient->listMultipartUploads(array(
                'Bucket' => 'bucket-cssg-test-php-1253653367', //格式：BucketName-APPID
                'Delimiter' => '/',
                'EncodingType' => 'url',
                'KeyMarker' => 'string',
                'UploadIdMarker' => 'string',
                'Prefix' => 'prfix',
                'MaxUploads' => 1000,
            )); 
            // 请求成功
            print_r($result);
        } catch (\Exception $e) {
            // 请求失败
            echo($e);
            $this->assertNull($e);
        }
        //.cssg-snippet-body-end
    }

    protected function uploadPart() {
        //.cssg-snippet-body-start:[upload-part]
        try {
            $result = $cosClient->uploadPart(array(
                'Bucket' => 'bucket-cssg-test-php-1253653367', //格式：BucketName-APPID
                'Key' => 'object4php', 
                'Body' => 'string',
                'UploadId' => 'NWNhNDY0YzFfMmZiNTM1MGFfNTM2YV8xYjliMTg', //UploadId 为对象分块上传的 ID，在分块上传初始化的返回参数里获得 
                'PartNumber' => integer, //PartNumber 为分块的序列号，COS 会根据携带序列号合并分块
                /*
                'ContentMD5' => 'string',
                'ContentLength' => integer,
                */
            )); 
            // 请求成功
            print_r($result);
        } catch (\Exception $e) {
            // 请求失败
            echo($e);
            $this->assertNull($e);
        }
        //.cssg-snippet-body-end
    }

    protected function listParts() {
        //.cssg-snippet-body-start:[list-parts]
        try {
            $result = $cosClient->listParts(array(
                'Bucket' => 'bucket-cssg-test-php-1253653367', //格式：BucketName-APPID
                'Key' => 'object4php',
                'UploadId' => 'NWNhNDY0YzFfMmZiNTM1MGFfNTM2YV8xYjliMTg',
                'PartNumberMarker' => 1,
                'MaxParts' => 1000,
            )); 
            // 请求成功
            print_r($result);
        } catch (\Exception $e) {
            // 请求失败
            echo($e);
            $this->assertNull($e);
        }
        //.cssg-snippet-body-end
    }

    protected function completeMultiUpload() {
        //.cssg-snippet-body-start:[complete-multi-upload]
        try {
            $result = $cosClient->completeMultipartUpload(array(
                'Bucket' => 'bucket-cssg-test-php-1253653367', //格式：BucketName-APPID
                'Key' => 'object4php', 
                'UploadId' => 'string',
                'Parts' => array(
                    array(
                        'ETag' => 'string',
                        'PartNumber' => integer,
                    ),  
                    array(
                        'ETag' => 'string',
                        'PartNumber' => integer,
                    )), 
                    // ... repeated
            )); 
            // 请求成功
            print_r($result);
        } catch (\Exception $e) {
            // 请求失败
            echo($e);
            $this->assertNull($e);
        }
        //.cssg-snippet-body-end
    }

    protected function abortMultiUpload() {
        //.cssg-snippet-body-start:[abort-multi-upload]
        try {
            $result = $cosClient->abortMultipartUpload(array(
                'Bucket' => 'bucket-cssg-test-php-1253653367', //格式：BucketName-APPID
                'Key' => 'object4php', 
                'UploadId' => 'string',
            )); 
            // 请求成功
            print_r($result);
        } catch (\Exception $e) {
            // 请求失败
            echo($e);
            $this->assertNull($e);
        }
        //.cssg-snippet-body-end
    }

    protected function transferUploadObject() {
        //.cssg-snippet-body-start:[transfer-upload-object]
        try {
            $result = $cosClient->Upload(
                $bucket = 'bucket-cssg-test-php-1253653367', //格式：BucketName-APPID
                $key = 'object4php',
                $body = fopen('/data/object4php', 'rb')
                /*
                $options = array(
                    'ACL' => 'string',
                    'CacheControl' => 'string',
                    'ContentDisposition' => 'string',
                    'ContentEncoding' => 'string',
                    'ContentLanguage' => 'string',
                    'ContentLength' => integer,
                    'ContentType' => 'string',
                    'Expires' => 'string',
                    'GrantFullControl' => 'string',
                    'GrantRead' => 'string',
                    'GrantWrite' => 'string',
                    'Metadata' => array(
                        'string' => 'string',
                    ),
                    'ContentMD5' => 'string',
                    'ServerSideEncryption' => 'string',
                    'StorageClass' => 'string'
                )
                */
            );
            // 请求成功
            print_r($result);
        } catch (\Exception $e) {
            // 请求失败
            echo($e);
            $this->assertNull($e);
        }
        //.cssg-snippet-body-end
    }

    protected function transferCopyObject() {
        //.cssg-snippet-body-start:[transfer-copy-object]
        try {
            $result = $cosClient->Copy(
                $bucket = 'bucket-cssg-test-php-1253653367', //格式：BucketName-APPID
                $key = 'object4php',
                $copySorce = array(
                    'Region' => 'ap-guangzhou', 
                    'Bucket' => 'examplebucket2-1253653367', 
                    'Key' => 'object4php', 
                ),
                /*
                $options = array(
                    'ACL' => 'string',
                    'MetadataDirective' => 'string',
                    'CacheControl' => 'string',
                    'ContentDisposition' => 'string',
                    'ContentEncoding' => 'string',
                    'ContentLanguage' => 'string',
                    'ContentLength' => integer,
                    'ContentType' => 'string',
                    'Expires' => 'string',
                    'GrantFullControl' => 'string',
                    'GrantRead' => 'string',
                    'GrantWrite' => 'string',
                    'Metadata' => array(
                        'string' => 'string',
                    ),
                    'ContentMD5' => 'string',
                    'ServerSideEncryption' => 'string',
                    'StorageClass' => 'string'
                )
                */
            );
            // 请求成功
            print_r($result);
        } catch (\Exception $e) {
            // 请求失败
            echo($e);
            $this->assertNull($e);
        }
        //.cssg-snippet-body-end
    }

    protected function copyObject() {
        //.cssg-snippet-body-start:[copy-object]
        try {
            $result = $cosClient->copyObject(array(
                'Bucket' => 'bucket-cssg-test-php-1253653367', //格式：BucketName-APPID
                'Key' => 'object4php',
                'CopySource' => 'bucket-cssg-source-1253653367.cos.ap-guangzhou.myqcloud.com/object4php',
                /*
                'MetadataDirective' => 'string',
                'ACL' => 'string',
                'CacheControl' => 'string',
                'ContentDisposition' => 'string',
                'ContentEncoding' => 'string',
                'ContentLanguage' => 'string',
                'ContentLength' => integer,
                'ContentType' => 'string',
                'Expires' => 'string',
                'GrantFullControl' => 'string',
                'GrantRead' => 'string',
                'GrantWrite' => 'string',
                'Metadata' => array(
                'string' => 'string',
                ),
                'ContentMD5' => 'string',
                'ServerSideEncryption' => 'string',
                'StorageClass' => 'string'
                */
            )); 
            // 请求成功
            print_r($result);
        } catch (\Exception $e) {
            // 请求失败
            echo($e);
            $this->assertNull($e);
        }
        //.cssg-snippet-body-end
    }

    protected function putObjectComp() {
        //.cssg-snippet-body-start:[put-object-comp]
        # 上传文件
        ## putObject(上传接口，最大支持上传5G文件)
        ### 上传内存中的字符串
        try {
            $bucket = "bucket-cssg-test-php-1253653367"; //存储桶名称 格式：BucketName-APPID
            $key = "object4php";
            $result = $cosClient->putObject(array(
                'Bucket' => $bucket,
                'Key' => $key,
                'Body' => 'Hello World!'));
            print_r($result);
        } catch (\Exception $e) {
            echo "$e\n";
            $this->assertNull($e);
        }
        
        ### 上传文件流
        try {
            $bucket = "bucket-cssg-test-php-1253653367"; //存储桶名称 格式：BucketName-APPID
            $key = "object4php";
            $srcPath = "F:/object4php";//本地文件绝对路径
            $file = fopen($srcPath, "rb");
            if ($file) {
                $result = $cosClient->putObject(array(
                    'Bucket' => $bucket,
                    'Key' => $key,
                    'Body' => $file));
                print_r($result);
            }
        } catch (\Exception $e) {
            echo "$e\n";
            $this->assertNull($e);
        }
        
        ### 设置 header 和 meta
        try {
            $bucket = "bucket-cssg-test-php-1253653367"; //存储桶名称 格式：BucketName-APPID
            $key = "object4php";
            $result = $cosClient->putObject(array(
                'Bucket' => $bucket,
                'Key' => $key,
                'Body' => 'string | stream',
                'ACL' => 'string',
                'CacheControl' => 'string',
                'ContentDisposition' => 'string',
                'ContentEncoding' => 'string',
                'ContentLanguage' => 'string',
                'ContentLength' => 'int',
                'ContentType' => 'string',
                'Expires' => 'string',
                'GrantFullControl' => 'string',
                'GrantRead' => 'string',
                'GrantWrite' => 'string',
                'Metadata' => array(
                    'string' => 'string',
                ),
                'StorageClass' => 'string'));
            print_r($result);
        } catch (\Exception $e) {
            echo "$e\n";
            $this->assertNull($e);
        }
        
        ## Upload(高级上传接口，默认使用分块上传最大支持50T)
        ### 上传内存中的字符串
        try {    
            $bucket = "bucket-cssg-test-php-1253653367"; //存储桶名称 格式：BucketName-APPID
            $key = "object4php";
            $result = $cosClient->Upload(
                $bucket = $bucket,
                $key = $key,
                $body = 'Hello World!');
            print_r($result);
        } catch (\Exception $e) {
            echo "$e\n";
            $this->assertNull($e);
        }
        
        ### 上传文件流
        try {    
            $bucket = "bucket-cssg-test-php-1253653367"; //存储桶名称 格式：BucketName-APPID
            $key = "object4php";
            $srcPath = "F:/object4php";//本地文件绝对路径
            $file = fopen($srcPath, 'rb');
            if ($file) {
                $result = $cosClient->Upload(
                    $bucket = $bucket,
                    $key = $key,
                    $body = $file);
            }
            print_r($result);
        } catch (\Exception $e) {
            echo "$e\n";
            $this->assertNull($e);
        }
        
        ### 设置header和meta
        try {
            $bucket = "bucket-cssg-test-php-1253653367"; //存储桶名称 格式：BucketName-APPID
            $key = "object4php";
            $result = $cosClient->Upload(
                $bucket= $bucket,
                $key = $key,
                $body = 'string | stream',
                $options = array(
                    'ACL' => 'string',
                    'CacheControl' => 'string',
                    'ContentDisposition' => 'string',
                    'ContentEncoding' => 'string',
                    'ContentLanguage' => 'string',
                    'ContentLength' => 'int',
                    'ContentType' => 'string',
                    'Expires' => 'string',
                    'GrantFullControl' => 'string',
                    'GrantRead' => 'string',
                    'GrantWrite' => 'string',
                    'Metadata' => array(
                        'string' => 'string',
                    ),
                    'StorageClass' => 'string'));
            print_r($result);
        } catch (\Exception $e) {
            echo "$e\n";
            $this->assertNull($e);
        }
        //.cssg-snippet-body-end
    }

    protected function getObjectComp() {
        //.cssg-snippet-body-start:[get-object-comp]
        # 下载文件
        ## getObject(下载文件)
        ### 下载到内存
        try {
            $bucket = "bucket-cssg-test-php-1253653367"; //存储桶，格式：BucketName-APPID
            $key = "object4php"; //对象在存储桶中的位置，即称对象键
            $result = $cosClient->getObject(array(
                'Bucket' => $bucket,
                'Key' => $key));
            // 请求成功
            echo($result['Body']);
        } catch (\Exception $e) {
            // 请求失败
            echo "$e\n";
            $this->assertNull($e);
        }
        
        ### 下载到本地
        try {
            $bucket = "bucket-cssg-test-php-1253653367"; //存储桶，格式：BucketName-APPID
            $key = "object4php"; //对象在存储桶中的位置，即称对象键
            $localPath = @"F:/object4php";//下载到本地指定路径
            $result = $cosClient->getObject(array(
                'Bucket' => $bucket,
                'Key' => $key,
                'SaveAs' => $localPath));
        } catch (\Exception $e) {
            // 请求失败
            echo "$e\n";
            $this->assertNull($e);
        }
        
        ### 指定下载范围
        /*
         * Range 字段格式为 'bytes=a-b'
         */
        try {
            $bucket = "bucket-cssg-test-php-1253653367"; //存储桶，格式：BucketName-APPID
            $key = "object4php"; //对象在存储桶中的位置，即称对象键
            $localPath = @"F:/object4php";//下载到本地指定路径
            $result = $cosClient->getObject(array(
                'Bucket' => $bucket,
                'Key' => $key,
                'Range' => 'bytes=0-10',
                'SaveAs' => $localPath));
        } catch (\Exception $e) {
            // 请求失败
            echo "$e\n";
            $this->assertNull($e);
        }
        
        ### 设置返回 header
        try {
            $bucket = "bucket-cssg-test-php-1253653367"; //存储桶，格式：BucketName-APPID
            $key = "object4php"; //对象在存储桶中的位置，即称对象键
            $localPath = @"F:/object4php";//下载到本地指定路径
            $result = $cosClient->getObject(array(
                'Bucket' => $bucket,
                'Key' => $key,
                'ResponseCacheControl' => 'string',
                'ResponseContentDisposition' => 'string',
                'ResponseContentEncoding' => 'string',
                'ResponseContentLanguage' => 'string',
                'ResponseContentType' => 'string',
                'ResponseExpires' => 'mixed type: string (date format)|int (unix timestamp)|\DateTime',
                'SaveAs' => $localPath));
        } catch (\Exception $e) {
            // 请求失败
            echo "$e\n";
            $this->assertNull($e);
        }
        
        ## getObjectUrl(获取文件 UrL)
        try {    
            $bucket = "bucket-cssg-test-php-1253653367"; //存储桶，格式：BucketName-APPID
            $key = "object4php"; //对象在存储桶中的位置，即称对象键
            $signedUrl = $cosClient->getObjectUrl($bucket, $key, '+10 minutes');
            // 请求成功
            echo $signedUrl;
        } catch (\Exception $e) {
            // 请求失败
            print_r($e);
        }
        //.cssg-snippet-body-end
    }

    protected function deleteObjectComp() {
        //.cssg-snippet-body-start:[delete-object-comp]
        # 删除 object
        ## deleteObject
        try {
            $bucket = "bucket-cssg-test-php-1253653367"; //存储桶，格式：BucketName-APPID
            $key = "object4php"; //对象在存储桶中的位置，即称对象键
            $result = $cosClient->deleteObject(array(
                'Bucket' => $bucket,
                'Key' => $key,
                'VersionId' => 'string'
            ));
            // 请求成功
            print_r($result);
        } catch (\Exception $e) {
            // 请求失败
            echo($e);
            $this->assertNull($e);
        }
        # 删除多个 object
        ## deleteObjects
        try {
            $bucket = "bucket-cssg-test-php-1253653367"; //存储桶，格式：BucketName-APPID
            $key1 = "object4php1"; //对象在存储桶中的位置，即称对象键
            $key2 = "object4php2"; //对象在存储桶中的位置，即称对象键
            $result = $cosClient->deleteObjects(array(
                'Bucket' => $bucket,
                'Objects' => array(
                    array(
                        'Key' => $key1,
                    ),
                    array(
                        'Key' => $key2,
                    ),
                    //...
                ),
            ));
            // 请求成功
            print_r($result);
        } catch (\Exception $e) {
            // 请求失败
            echo($e);
            $this->assertNull($e);
        }
        //.cssg-snippet-body-end
    }

    protected function getPresignStsDownloadUrl() {
        //.cssg-snippet-body-start:[get-presign-sts-download-url]
        $tmpSecretId = getenv('COS_KEY'); //替换为您的临时密钥 SecretId
        $tmpSecretKey = getenv('COS_SECRET'); //替换为您的临时密钥 SecretKey
        $tmpToken = "COS_TOKEN"; //替换为您的临时密钥 token
        $region = "ap-beijing"; //设置一个默认的存储桶地域
        $cosClient = new Qcloud\Cos\Client(
            array(
                'region' => $region,
                'schema' => 'https', //协议头部，默认为 http
                'credentials'=> array(
                    'secretId'  => $tmpSecretId,
                    'secretKey' => $tmpSecretKey,
                    'token' => $tmpToken)));
        ### 简单下载预签名
        try {
            $signedUrl = $cosClient->getPresignetUrl('getObject', array(
                'Bucket' => "bucket-cssg-test-php-1253653367", //存储桶，格式：BucketName-APPID
                'Key' => "object4php" //对象在存储桶中的位置，即对象键
            ), '+10 minutes'); //签名的有效时间
            // 请求成功
            echo ($signedUrl);
        } catch (\Exception $e) {
            // 请求失败
            echo($e);
            $this->assertNull($e);
        }
        
        ### 使用封装的 getObjectUrl 获取下载签名
        try {    
            $bucket = "bucket-cssg-test-php-1253653367"; //存储桶，格式：BucketName-APPID
            $key = "object4php"; //对象在存储桶中的位置，即对象键
            $signedUrl = $cosClient->getObjectUrl($bucket, $key, '+10 minutes'); //签名的有效时间
            // 请求成功
            echo $signedUrl;
        } catch (\Exception $e) {
            // 请求失败
            print_r($e);
        }
        //.cssg-snippet-body-end
    }

    protected function getPresignStsUploadUrl() {
        //.cssg-snippet-body-start:[get-presign-sts-upload-url]
        $tmpSecretId = getenv('COS_KEY'); //替换为您的临时密钥 SecretId
        $tmpSecretKey = getenv('COS_SECRET'); //替换为您的临时密钥 SecretKey
        $tmpToken = "COS_TOKEN"; //替换为您的临时密钥 token
        $region = "ap-beijing"; //设置一个默认的存储桶地域
        $cosClient = new Qcloud\Cos\Client(
            array(
                'region' => $region,
                'schema' => 'https', //协议头部，默认为 http
                'credentials'=> array(
                    'secretId'  => $tmpSecretId,
                    'secretKey' => $tmpSecretKey,
                    'token' => $tmpToken)));
        ### 简单上传预签名
        try {
            $signedUrl = $cosClient->getPresignetUrl('putObject', array(
                'Bucket' => "bucket-cssg-test-php-1253653367", //存储桶，格式：BucketName-APPID
                'Key' => "object4php", //对象在存储桶中的位置，即对象键
                'Body' => 'string'), '+10 minutes'); //签名的有效时间
            // 请求成功
            echo ($signedUrl);
        } catch (\Exception $e) {
            // 请求失败
            echo($e);
            $this->assertNull($e);
        }
        
        ### 分块上传预签名
        try {
            $signedUrl = $cosClient->getPresignetUrl('uploadPart', array(
                'Bucket' => "bucket-cssg-test-php-1253653367", //存储桶，格式：BucketName-APPID
                'Key' => "object4php", //对象在存储桶中的位置，即对象键
                'UploadId' => '',
                'PartNumber' => '1',
                'Body' => ''), '+10 minutes'); //签名的有效时间
            // 请求成功
            echo ($signedUrl);
        } catch (\Exception $e) {
            // 请求失败
            echo($e);
            $this->assertNull($e);
        }
        //.cssg-snippet-body-end
    }


    protected function setUp(): void
    {
        //.cssg-snippet-body-start:[global-init]
        $secretId = getenv('COS_KEY'); //"云 API 密钥 SecretId";
        $secretKey = getenv('COS_SECRET'); //"云 API 密钥 SecretKey";
        $region = "ap-beijing"; //设置一个默认的存储桶地域
        $cosClient = new Qcloud\Cos\Client(
            array(
                'region' => $region,
                'schema' => 'https', //协议头部，默认为http
                'credentials'=> array(
                    'secretId'  => $secretId ,
                    'secretKey' => $secretKey)));
        //.cssg-snippet-body-end
        $this->putBucket();
    }

    protected function tearDown(): void
    {
        $this->deleteObject();
        $this->deleteBucket();
    }

    public function testObjectMetadata() {
        $this->putObject();
        $this->putObjectAcl();
        $this->getObjectAcl();
        $this->headObject();
        $this->getObject();
        $this->getPresignDownloadUrl();
        $this->getPresignUploadUrl();
        $this->deleteObject();
        $this->deleteMultiObject();
        $this->restoreObject();
    }

    public function testObjectMultiUpload() {
        $this->initMultiUpload();
        $this->listMultiUpload();
        $this->uploadPart();
        $this->listParts();
        $this->completeMultiUpload();
    }

    public function testObjectAbortMultiUpload() {
        $this->initMultiUpload();
        $this->uploadPart();
        $this->abortMultiUpload();
    }

    public function testObjectTransfer() {
        $this->transferUploadObject();
        $this->transferCopyObject();
    }

    public function testObjectCopy() {
        $this->copyObject();
        $this->initMultiUpload();
        $this->completeMultiUpload();
    }

    public function testObjectComp() {
        $this->putObjectComp();
        $this->getObjectComp();
        $this->deleteObjectComp();
    }

    public function testPreisignUrl() {
        $this->getPresignStsDownloadUrl();
        $this->getPresignStsUploadUrl();
    }

}
?>