<?php

use Qcloud\Cos\Client;
use Qcloud\Cos\Exception\ServiceResponseException;

class InitTest extends \PHPUnit\Framework\TestCase
{
    private $cosClient;
    private $bucket;
    private $region;


    protected function globalInitSts() {
        //.cssg-snippet-body-start:[global-init-sts]
        $tmpSecretId = getenv('COS_KEY'); //"临时密钥 SecretId";
        $tmpSecretKey = getenv('COS_SECRET'); //"临时密钥 SecretKey";
        $tmpToken = "COS_TOKEN"; //"临时密钥 token";
        $region = "ap-beijing"; //设置一个默认的存储桶地域
        $cosClient = new Qcloud\Cos\Client(
            array(
                'region' => $region,
                'schema' => 'https', //协议头部，默认为http
                'credentials'=> array(
                    'secretId'  => $tmpSecretId,
                    'secretKey' => $tmpSecretKey,
                    'token' => $tmpToken)));
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
    }

    protected function tearDown(): void
    {
    }

    public function testGlobalInit() {
        $this->globalInitSts();
    }

}
?>