using COSXML.Common;
using COSXML.CosException;
using COSXML.Model;
using COSXML.Model.Object;
using COSXML.Model.Tag;
using COSXML.Model.Bucket;
using COSXML.Model.Service;
using COSXML.Utils;
using COSXML.Auth;
using COSXML.Transfer;
using NUnit.Framework;
using System;
using COSXML;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Reflection;
using System.Text;
using System.Threading;
using System.Threading.Tasks;

namespace COSSample
{
    public class GlobalInitSample {


      public void GlobalInit()
      {
        //初始化 CosXmlConfig 
        string appid = "1253653367";//设置腾讯云账户的账户标识 APPID
        string region = "ap-guangzhou"; //设置一个默认的存储桶地域
        CosXmlConfig config = new CosXmlConfig.Builder()
          .SetConnectionTimeoutMs(60000)  //设置连接超时时间，单位毫秒，默认45000ms
          .SetReadWriteTimeoutMs(40000)  //设置读写超时时间，单位毫秒，默认45000ms
          .IsHttps(true)  //设置默认 HTTPS 请求
          .SetAppid(appid)  //设置腾讯云账户的账户标识 APPID
          .SetRegion(region)  //设置一个默认的存储桶地域
          .SetDebugLog(true)  //显示日志
          .Build();  //创建 CosXmlConfig 对象
        
        //初始化 QCloudCredentialProvider，COS SDK 中提供了3种方式：永久密钥、临时密钥、自定义
        QCloudCredentialProvider cosCredentialProvider = null;
        
        //方式1， 永久密钥
        string secretId = "COS_SECRETID"; //"云 API 密钥 SecretId";
        string secretKey = "COS_SECRETKEY"; //"云 API 密钥 SecretKey";
        long durationSecond = 600;  //每次请求签名有效时长，单位为秒
        cosCredentialProvider = new DefaultQCloudCredentialProvider(secretId, secretKey, durationSecond);
        
        //方式2， 临时密钥
        string tmpSecretId = "COS_SECRETID"; //"临时密钥 SecretId";
        string tmpSecretKey = "COS_SECRETKEY"; //"临时密钥 SecretKey";
        string tmpToken = "COS_TOKEN"; //"临时密钥 token";
        long tmpExpireTime = 1546862502;//临时密钥有效截止时间
        cosCredentialProvider = new DefaultSessionQCloudCredentialProvider(tmpSecretId, tmpSecretKey, 
          tmpExpireTime, tmpToken);
        
        //初始化 CosXmlServer
        CosXmlServer cosXml = new CosXmlServer(config, cosCredentialProvider);
      }   

      [SetUp()]
      public void setup() {
      }

      [Test()]
      public void testGlobalInit() {
        GlobalInit();
      }

      [TearDown()]
      public void teardown() {
      }
    }
}