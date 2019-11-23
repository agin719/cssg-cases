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
    public class BucketCORSSample {

      string uploadId;

      public void PutBucketCors()
      {
        CosXmlConfig config = new CosXmlConfig.Builder()
          .SetConnectionTimeoutMs(60000)  //设置连接超时时间，单位毫秒 ，默认 45000ms
          .SetReadWriteTimeoutMs(40000)  //设置读写超时时间，单位毫秒 ，默认 45000ms
          .IsHttps(true)  //设置默认 https 请求
          .SetAppid("1253653367") //设置腾讯云账户的账户标识 APPID
          .SetRegion("ap-guangzhou") //设置一个默认的存储桶地域
          .Build();
        
        string secretId = Environment.GetEnvironmentVariable("COS_KEY");   //云 API 密钥 SecretId
        string secretKey = Environment.GetEnvironmentVariable("COS_SECRET"); //云 API 密钥 SecretKey
        long durationSecond = 600;          //每次请求签名有效时长,单位为 秒
        QCloudCredentialProvider qCloudCredentialProvider = new DefaultQCloudCredentialProvider(secretId, 
        secretKey, durationSecond);
        
        CosXml cosXml = new CosXmlServer(config, qCloudCredentialProvider);
        
        try
        {
          string bucket = "bucket-cssg-dotnet-temp-1253653367"; //格式：BucketName-APPID
          PutBucketCORSRequest request = new PutBucketCORSRequest(bucket);
          //设置签名有效时长
          request.SetSign(TimeUtils.GetCurrentTime(TimeUnit.SECONDS), 600);
          //设置跨域访问配置 CORS
          COSXML.Model.Tag.CORSConfiguration.CORSRule corsRule = new COSXML.Model.Tag.CORSConfiguration.CORSRule();
          corsRule.id = "corsconfigureId";
          corsRule.maxAgeSeconds = 6000;
          corsRule.allowedOrigin = "http://cloud.tencent.com";
        
          corsRule.allowedMethods = new List<string>();
          corsRule.allowedMethods.Add("PUT");
        
          corsRule.allowedHeaders = new List<string>();
          corsRule.allowedHeaders.Add("Host");
        
          corsRule.exposeHeaders = new List<string>();
          corsRule.exposeHeaders.Add("x-cos-meta-x1");
        
          request.SetCORSRule(corsRule);
        
          //执行请求
          PutBucketCORSResult result = cosXml.PutBucketCORS(request);
          //请求成功
          Console.WriteLine(result.GetResultInfo());
        }
        catch (COSXML.CosException.CosClientException clientEx)
        {
          //请求失败
          Console.WriteLine("CosClientException: " + clientEx);
          Assert.Null(clientEx);
        }
        catch (COSXML.CosException.CosServerException serverEx)
        {
          //请求失败
          Console.WriteLine("CosServerException: " + serverEx.GetInfo());
          Assert.Null(serverEx);
        }
        Thread.Sleep(500);
      }
      public void GetBucketCors()
      {
        CosXmlConfig config = new CosXmlConfig.Builder()
          .SetConnectionTimeoutMs(60000)  //设置连接超时时间，单位毫秒 ，默认 45000ms
          .SetReadWriteTimeoutMs(40000)  //设置读写超时时间，单位毫秒 ，默认 45000ms
          .IsHttps(true)  //设置默认 https 请求
          .SetAppid("1253653367") //设置腾讯云账户的账户标识 APPID
          .SetRegion("ap-guangzhou") //设置一个默认的存储桶地域
          .Build();
        
        string secretId = Environment.GetEnvironmentVariable("COS_KEY");   //云 API 密钥 SecretId
        string secretKey = Environment.GetEnvironmentVariable("COS_SECRET"); //云 API 密钥 SecretKey
        long durationSecond = 600;          //每次请求签名有效时长,单位为 秒
        QCloudCredentialProvider qCloudCredentialProvider = new DefaultQCloudCredentialProvider(secretId, 
        secretKey, durationSecond);
        
        CosXml cosXml = new CosXmlServer(config, qCloudCredentialProvider);
        
        try
        {
          string bucket = "bucket-cssg-dotnet-temp-1253653367"; //格式：BucketName-APPID
          GetBucketCORSRequest request = new GetBucketCORSRequest(bucket);
          //设置签名有效时长
          request.SetSign(TimeUtils.GetCurrentTime(TimeUnit.SECONDS), 600);
          //执行请求
          GetBucketCORSResult result = cosXml.GetBucketCORS(request);
          //请求成功
          Console.WriteLine(result.GetResultInfo());
        }
        catch (COSXML.CosException.CosClientException clientEx)
        {
          //请求失败
          Console.WriteLine("CosClientException: " + clientEx);
          Assert.Null(clientEx);
        }
        catch (COSXML.CosException.CosServerException serverEx)
        {
          //请求失败
          Console.WriteLine("CosServerException: " + serverEx.GetInfo());
          Assert.Null(serverEx);
        }
      }
      public void OptionObject()
      {
        CosXmlConfig config = new CosXmlConfig.Builder()
          .SetConnectionTimeoutMs(60000)  //设置连接超时时间，单位毫秒 ，默认 45000ms
          .SetReadWriteTimeoutMs(40000)  //设置读写超时时间，单位毫秒 ，默认 45000ms
          .IsHttps(true)  //设置默认 https 请求
          .SetAppid("1253653367") //设置腾讯云账户的账户标识 APPID
          .SetRegion("ap-guangzhou") //设置一个默认的存储桶地域
          .Build();
        
        string secretId = Environment.GetEnvironmentVariable("COS_KEY");   //云 API 密钥 SecretId
        string secretKey = Environment.GetEnvironmentVariable("COS_SECRET"); //云 API 密钥 SecretKey
        long durationSecond = 600;          //每次请求签名有效时长,单位为 秒
        QCloudCredentialProvider qCloudCredentialProvider = new DefaultQCloudCredentialProvider(secretId, 
        secretKey, durationSecond);
        
        CosXml cosXml = new CosXmlServer(config, qCloudCredentialProvider);
        
        try
        {
          string bucket = "bucket-cssg-dotnet-temp-1253653367"; //存储桶，格式：BucketName-APPID
          string key = "object4dotnet"; //对象在存储桶中的位置，即称对象键
          string origin = "http://cloud.tencent.com";
          string accessMthod = "PUT";
          OptionObjectRequest request = new OptionObjectRequest(bucket, key, origin, accessMthod);
          //设置签名有效时长
          request.SetSign(TimeUtils.GetCurrentTime(TimeUnit.SECONDS), 600);
          //执行请求
          OptionObjectResult result = cosXml.OptionObject(request);
          //请求成功
          Console.WriteLine(result.GetResultInfo());
        }
        catch (COSXML.CosException.CosClientException clientEx)
        {
          //请求失败
          Console.WriteLine("CosClientException: " + clientEx);
          Assert.Null(clientEx);
        }
        catch (COSXML.CosException.CosServerException serverEx)
        {
          //请求失败
          Console.WriteLine("CosServerException: " + serverEx.GetInfo());
          Assert.Null(serverEx);
        }
      }
      public void DeleteBucketCors()
      {
        CosXmlConfig config = new CosXmlConfig.Builder()
          .SetConnectionTimeoutMs(60000)  //设置连接超时时间，单位毫秒 ，默认 45000ms
          .SetReadWriteTimeoutMs(40000)  //设置读写超时时间，单位毫秒 ，默认 45000ms
          .IsHttps(true)  //设置默认 https 请求
          .SetAppid("1253653367") //设置腾讯云账户的账户标识 APPID
          .SetRegion("ap-guangzhou") //设置一个默认的存储桶地域
          .Build();
        
        string secretId = Environment.GetEnvironmentVariable("COS_KEY");   //云 API 密钥 SecretId
        string secretKey = Environment.GetEnvironmentVariable("COS_SECRET"); //云 API 密钥 SecretKey
        long durationSecond = 600;          //每次请求签名有效时长,单位为 秒
        QCloudCredentialProvider qCloudCredentialProvider = new DefaultQCloudCredentialProvider(secretId, 
        secretKey, durationSecond);
        
        CosXml cosXml = new CosXmlServer(config, qCloudCredentialProvider);
        
        try
        {
          string bucket = "bucket-cssg-dotnet-temp-1253653367"; //格式：BucketName-APPID
          DeleteBucketCORSRequest request = new DeleteBucketCORSRequest(bucket);
          //设置签名有效时长
          request.SetSign(TimeUtils.GetCurrentTime(TimeUnit.SECONDS), 600);
          //执行请求
          DeleteBucketCORSResult result = cosXml.DeleteBucketCORS(request);
          //请求成功
          Console.WriteLine(result.GetResultInfo());
        }
        catch (COSXML.CosException.CosClientException clientEx)
        {
          //请求失败
          Console.WriteLine("CosClientException: " + clientEx);
          Assert.Null(clientEx);
        }
        catch (COSXML.CosException.CosServerException serverEx)
        {
          //请求失败
          Console.WriteLine("CosServerException: " + serverEx.GetInfo());
          Assert.Null(serverEx);
        }
      }

      [SetUp()]
      public void setup() {
        CosXmlConfig config = new CosXmlConfig.Builder()
          .SetConnectionTimeoutMs(60000)  //设置连接超时时间，单位毫秒 ，默认 45000ms
          .SetReadWriteTimeoutMs(40000)  //设置读写超时时间，单位毫秒 ，默认 45000ms
          .IsHttps(true)  //设置默认 https 请求
          .SetAppid("1253653367") //设置腾讯云账户的账户标识 APPID
          .SetRegion("ap-guangzhou") //设置一个默认的存储桶地域
          .Build();
        
        string secretId = Environment.GetEnvironmentVariable("COS_KEY");   //云 API 密钥 SecretId
        string secretKey = Environment.GetEnvironmentVariable("COS_SECRET"); //云 API 密钥 SecretKey
        long durationSecond = 600;          //每次请求签名有效时长,单位为 秒
        QCloudCredentialProvider qCloudCredentialProvider = new DefaultQCloudCredentialProvider(secretId, 
        secretKey, durationSecond);
        
        CosXml cosXml = new CosXmlServer(config, qCloudCredentialProvider);
        
        try
        {
          string bucket = "bucket-cssg-dotnet-temp-1253653367"; //格式：BucketName-APPID
          PutBucketRequest request = new PutBucketRequest(bucket);
          //设置签名有效时长
          request.SetSign(TimeUtils.GetCurrentTime(TimeUnit.SECONDS), 600);
          //执行请求
          PutBucketResult result = cosXml.PutBucket(request);
          //请求成功
          Console.WriteLine(result.GetResultInfo());
        }
        catch (COSXML.CosException.CosClientException clientEx)
        {
          //请求失败
          Console.WriteLine("CosClientException: " + clientEx);
          Assert.Null(clientEx);
        }
        catch (COSXML.CosException.CosServerException serverEx)
        {
          //请求失败
          Console.WriteLine("CosServerException: " + serverEx.GetInfo());
          Assert.Null(serverEx);
        }
      }

      [Test()]
      public void testBucketCORS() {
        PutBucketCors();
        GetBucketCors();
        OptionObject();
        DeleteBucketCors();
      }

      [TearDown()]
      public void teardown() {
        CosXmlConfig config = new CosXmlConfig.Builder()
          .SetConnectionTimeoutMs(60000)  //设置连接超时时间，单位毫秒 ，默认 45000ms
          .SetReadWriteTimeoutMs(40000)  //设置读写超时时间，单位毫秒 ，默认 45000ms
          .IsHttps(true)  //设置默认 https 请求
          .SetAppid("1253653367") //设置腾讯云账户的账户标识 APPID
          .SetRegion("ap-guangzhou") //设置一个默认的存储桶地域
          .Build();
        
        string secretId = Environment.GetEnvironmentVariable("COS_KEY");   //云 API 密钥 SecretId
        string secretKey = Environment.GetEnvironmentVariable("COS_SECRET"); //云 API 密钥 SecretKey
        long durationSecond = 600;          //每次请求签名有效时长,单位为 秒
        QCloudCredentialProvider qCloudCredentialProvider = new DefaultQCloudCredentialProvider(secretId, 
        secretKey, durationSecond);
        
        CosXml cosXml = new CosXmlServer(config, qCloudCredentialProvider);
        
        try
        {
          string bucket = "bucket-cssg-dotnet-temp-1253653367"; //格式：BucketName-APPID
          DeleteBucketRequest request = new DeleteBucketRequest(bucket);
          //设置签名有效时长
          request.SetSign(TimeUtils.GetCurrentTime(TimeUnit.SECONDS), 600);
          //执行请求
          DeleteBucketResult result = cosXml.DeleteBucket(request);
          //请求成功
          Console.WriteLine(result.GetResultInfo());
        }
        catch (COSXML.CosException.CosClientException clientEx)
        {
          //请求失败
          Console.WriteLine("CosClientException: " + clientEx);
        }
        catch (COSXML.CosException.CosServerException serverEx)
        {
          //请求失败
          Console.WriteLine("CosServerException: " + serverEx.GetInfo());
        }
      }
    }
}