<?php

use Qcloud\Cos\Client;
use Qcloud\Cos\Exception\ServiceResponseException;

class ServiceTest extends \PHPUnit\Framework\TestCase
{
    private $cosClient;
    private $bucket;
    private $region;


    protected function getService() {
        //.cssg-snippet-body-start:[get-service]
        try {
            //请求成功
            $result = $cosClient->listBuckets();
            print_r($result);
        } catch (\Exception $e) {
            //请求失败
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
    }

    protected function tearDown(): void
    {
    }

    public function testGetService() {
        $this->getService();
    }

}
?>