<?php

use Qcloud\Cos\Client;
use Qcloud\Cos\Exception\ServiceResponseException;

class BucketTest extends \PHPUnit\Framework\TestCase
{
    private $cosClient;
    private $bucket;
    private $region;


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

    protected function getBucket() {
        //.cssg-snippet-body-start:[get-bucket]
        try {
            $bucket = "bucket-cssg-test-php-1253653367"; //存储桶名称 格式：BucketName-APPID
            $result = $cosClient->listObjects(array(
                'Bucket' => $bucket
            ));
            // 请求成功
            foreach ($result['Contents'] as $rt) {
                print_r($rt);
            }
        } catch (\Exception $e) {
            // 请求失败
            echo($e);
            $this->assertNull($e);
        }
        //.cssg-snippet-body-end
    }

    protected function getBucketRecursive() {
        //.cssg-snippet-body-start:[get-bucket-recursive]
        try {
            $bucket = "bucket-cssg-test-php-1253653367"; //存储桶名称 格式：BucketName-APPID
            $prefix = ''; //列出对象的前缀
            $marker = ''; //上次列出对象的断点
            while (true) {
                $result = $cosClient->listObjects(array(
                    'Bucket' => $bucket,
                    'Marker' => $marker,
                    'MaxKeys' => 1000 //设置单次查询打印的最大数量，最大为1000
                ));
                foreach ($result['Contents'] as $rt) {
                    // 打印key
                    echo($rt['Key'] . "\n");
                }
                $marker = $result['NextMarker']; //设置新的断点
                if (!$result['IsTruncated']) {
                    break; //判断是否已经查询完
                }
            }
        } catch (\Exception $e) {
            echo($e);
            $this->assertNull($e);
        }
        //.cssg-snippet-body-end
    }

    protected function listObjectVersioning() {
        //.cssg-snippet-body-start:[list-object-versioning]
        try {
            $result = $cosClient->listObjectVersions(array(
                'Bucket' => 'bucket-cssg-test-php-1253653367', //格式：BucketName-APPID
                'Delimiter' => '/',
                'EncodingType' => 'url',
                'KeyMarker' => 'string',
                'VersionIdMarker' => 'string',
                'Prefix' => 'doc',
                'MaxKeys' => 1000,
            )); 
            print_r($result);
        } catch (\Exception $e) {
            echo($e);
            $this->assertNull($e);
        }
        //.cssg-snippet-body-end
    }

    protected function headBucket() {
        //.cssg-snippet-body-start:[head-bucket]
        try {
            $result = $cosClient->headBucket(array(
                'Bucket' => 'bucket-cssg-test-php-1253653367' //格式：BucketName-APPID
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

    protected function putBucketAcl() {
        //.cssg-snippet-body-start:[put-bucket-acl]
        try {
            $result = $cosClient->putBucketAcl(array(
                'Bucket' => 'bucket-cssg-test-php-1253653367', //格式：BucketName-APPID
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

    protected function getBucketAcl() {
        //.cssg-snippet-body-start:[get-bucket-acl]
        try {
            $result = $cosClient->getBucketAcl(array(
                'Bucket' => 'bucket-cssg-test-php-1253653367' //格式：BucketName-APPID
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

    protected function putBucketCors() {
        //.cssg-snippet-body-start:[put-bucket-cors]
        try {
            $result = $cosClient->putBucketCors(array(
                'Bucket' => 'bucket-cssg-test-php-1253653367', //格式：BucketName-APPID
                'CORSRules' => array(
                    array(
                        'AllowedHeaders' => array('*',),
                        'AllowedMethods' => array('Put', ),
                        'AllowedOrigins' => array('*', ),
                        'ExposeHeaders' => array('*', ),
                        'MaxAgeSeconds' => 1,
                    ),  
                    // ... repeated
                )   
            )); 
            // 请求成功
            print_r($result);
        } catch (\Exception $e) {
            // 请求失败
            echo "$e\n";
            $this->assertNull($e);
        }
        //.cssg-snippet-body-end
    }

    protected function getBucketCors() {
        //.cssg-snippet-body-start:[get-bucket-cors]
        try {
            $result = $cosClient->getBucketCors(array(
                'Bucket' => 'bucket-cssg-test-php-1253653367' //格式：BucketName-APPID
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

    protected function deleteBucketCors() {
        //.cssg-snippet-body-start:[delete-bucket-cors]
        try {
            $result = $cosClient->deleteBucketCors(array(
                'Bucket' => 'bucket-cssg-test-php-1253653367' //格式：BucketName-APPID
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

    protected function putBucketLifecycle() {
        //.cssg-snippet-body-start:[put-bucket-lifecycle]
        try {
            $result = $cosClient->putBucketLifecycle(array(
                'Bucket' => 'bucket-cssg-test-php-1253653367', //格式：BucketName-APPID
                'Rules' => array(
                    array(
                        'Expiration' => array(
                            'Days' => integer,
                        ),  
                        'ID' => 'string',
                        'Filter' => array(
                            'Prefix' => 'string'
                        ),  
                        'Status' => 'string',
                        'Transitions' => array(
                            array(
                                'Days' => integer,
                                'StorageClass' => 'string'
                            ),  
                            // ... repeated
                        ),  
                    ),  
                    // ... repeated
                )
            ));  
            // 请求成功
            print_r($result);
        } catch (\Exception $e) {
            // 请求失败
            echo "$e\n";
            $this->assertNull($e);
        }
        //.cssg-snippet-body-end
    }

    protected function getBucketLifecycle() {
        //.cssg-snippet-body-start:[get-bucket-lifecycle]
        try {
            $result = $cosClient->getBucketLifecycle(array(
                'Bucket' => 'bucket-cssg-test-php-1253653367' //格式：BucketName-APPID
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

    protected function deleteBucketLifecycle() {
        //.cssg-snippet-body-start:[delete-bucket-lifecycle]
        try {
            $result = $cosClient->deleteBucketLifecycle(array(
                'Bucket' => 'bucket-cssg-test-php-1253653367' //格式：BucketName-APPID
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

    protected function putBucketVersioning() {
        //.cssg-snippet-body-start:[put-bucket-versioning]
        try {
            $result = $cosClient->putBucketVersioning(array(
                'Bucket' => 'bucket-cssg-test-php-125000000', //格式：BucketName-APPID
                'Status' => 'Enabled'
            )); 
            // 请求成功
            print_r($result);
        } catch (\Exception $e) {
            // 请求失败
            echo "$e\n";
            $this->assertNull($e);
        }
        //.cssg-snippet-body-end
    }

    protected function getBucketVersioning() {
        //.cssg-snippet-body-start:[get-bucket-versioning]
        try {
            $result = $cosClient->getBucketVersioning(array(
                'Bucket' => 'bucket-cssg-test-php-125000000', //格式：BucketName-APPID
            )); 
            // 请求成功
            print_r($result);
        } catch (\Exception $e) {
            // 请求失败
            echo "$e\n";
            $this->assertNull($e);
        }
        //.cssg-snippet-body-end
    }

    protected function putBucketReplication() {
        //.cssg-snippet-body-start:[put-bucket-replication]
        try {
            $result = $cosClient->putBucketReplication(array(
                'Bucket' => 'bucket-cssg-test-php-125000000', //格式：BucketName-APPID
                'Role' => 'qcs::cam::uin/1278687956:uin/1278687956',
                'Rules'=>array(
                    array(
                        'Status' => 'Enabled',
                        'ID' => 'string',
                        'Prefix' => 'string',
                        'Destination' => array(                    
                            'Bucket' => 'qcs::cos:ap-guangzhou::examplebucket2-125000000',
                            'StorageClass' => 'standard',                
                        ),  
                        // ...repeated            ),  
                ),      
            ))); 
            // 请求成功    print_r($result);
        } catch (\Exception $e) {    // 请求失败
            echo "$e\n";
            $this->assertNull($e);
        }
        //.cssg-snippet-body-end
    }

    protected function getBucketReplication() {
        //.cssg-snippet-body-start:[get-bucket-replication]
        try {
            $result = $cosClient->getBucketReplication(array(
                'Bucket' => 'bucket-cssg-test-php-125000000', //格式：BucketName-APPID
            )); 
            // 请求成功
            print_r($result);
        } catch (\Exception $e) {
            // 请求失败
            echo "$e\n";
            $this->assertNull($e);
        }
        //.cssg-snippet-body-end
    }

    protected function deleteBucketReplication() {
        //.cssg-snippet-body-start:[delete-bucket-replication]
        try {
            $result = $cosClient->deleteBucketReplication(array(
                'Bucket' => 'bucket-cssg-test-php-125000000', //格式：BucketName-APPID
            )); 
            // 请求成功
            print_r($result);
        } catch (\Exception $e) {
            // 请求失败
            echo "$e\n";
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
        $this->deleteBucket();
    }

    public function testBucketACL() {
        $this->getBucket();
        $this->getBucketRecursive();
        $this->listObjectVersioning();
        $this->headBucket();
        $this->putBucketAcl();
        $this->getBucketAcl();
    }

    public function testBucketCORS() {
        $this->putBucketCors();
        $this->getBucketCors();
        $this->deleteBucketCors();
    }

    public function testBucketLifecycle() {
        $this->putBucketLifecycle();
        $this->getBucketLifecycle();
        $this->deleteBucketLifecycle();
    }

    public function testBucketReplicationAndVersioning() {
        $this->putBucketVersioning();
        $this->getBucketVersioning();
        $this->putBucketReplication();
        $this->getBucketReplication();
        $this->deleteBucketReplication();
    }

}
?>