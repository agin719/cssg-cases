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
    public class BucketReplicationSample {

      string uploadId;

      public void PutBucketVersioning()
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
        
        string bucket = "bucket-cssg-dotnet-temp-1253653367"; //格式：BucketName-APPID
        PutBucketVersioningRequest request = new PutBucketVersioningRequest(bucket);
        //设置签名有效时长
        request.SetSign(TimeUtils.GetCurrentTime(TimeUnit.SECONDS), 600);
        request.IsEnableVersionConfig(true); //true: 开启版本控制; false:暂停版本控制
        
        // 使用同步方法
        try
        {
          PutBucketVersioningResult result = cosXml.PutBucketVersioning(request);
          Console.WriteLine(result.GetResultInfo());
        }
        catch (COSXML.CosException.CosClientException clientEx)
        {
          Console.WriteLine("CosClientException: " + clientEx);
          Assert.Null(clientEx);
        }
        catch (COSXML.CosException.CosServerException serverEx)
        {
          Console.WriteLine("CosServerException: " + serverEx.GetInfo());
          Assert.Null(serverEx);
        }
        Thread.Sleep(500);
      }
      public void PutBucketReplication()
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
        
        string bucket = "bucket-cssg-dotnet-temp-1253653367"; //格式：BucketName-APPID
        string ownerUin = "1278687956"; //发起者身份标示:OwnerUin 
        string subUin = "1278687956"; //发起者身份标示:SubUin 
        PutBucketReplicationRequest request = new PutBucketReplicationRequest(bucket);
        //设置 replication
        PutBucketReplicationRequest.RuleStruct ruleStruct = 
          new PutBucketReplicationRequest.RuleStruct();
        ruleStruct.id = "replication_01"; //用来标注具体 Rule 的名称
        ruleStruct.isEnable = true; //标识 Rule 是否生效 :true, 生效； false, 不生效
        ruleStruct.appid = "1253653367"; //appid
        ruleStruct.region = "ap-beijing"; //目标存储桶地域信息
        ruleStruct.bucket = "bucket-cssg-assist-1253653367"; //bucketName,不包含 '-appid' 
        ruleStruct.prefix = "34"; //前缀匹配策略
        List<PutBucketReplicationRequest.RuleStruct> ruleStructs = 
          new List<PutBucketReplicationRequest.RuleStruct>();
        ruleStructs.Add(ruleStruct);
        request.SetReplicationConfiguration(ownerUin, subUin, ruleStructs);
        
        // 使用同步方法
        try
        {
          PutBucketReplicationResult result = cosXml.PutBucketReplication(request);
          Console.WriteLine(result.GetResultInfo());
        }
        catch (COSXML.CosException.CosClientException clientEx)
        {
          Console.WriteLine("CosClientException: " + clientEx);
          Assert.Null(clientEx);
        }
        catch (COSXML.CosException.CosServerException serverEx)
        {
          Console.WriteLine("CosServerException: " + serverEx.GetInfo());
          Assert.Null(serverEx);
        }
        Thread.Sleep(500);
      }
      public void GetBucketReplication()
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
        
        string bucket = "bucket-cssg-dotnet-temp-1253653367"; //格式：BucketName-APPID
        GetBucketReplicationRequest request = new GetBucketReplicationRequest(bucket);
        
        //使用同步方法
        try
        {
          GetBucketReplicationResult result = cosXml.GetBucketReplication(request);
          Console.WriteLine(result.GetResultInfo());
        }
        catch (COSXML.CosException.CosClientException clientEx)
        {
          Console.WriteLine("CosClientException: " + clientEx);
          Assert.Null(clientEx);
        }
        catch (COSXML.CosException.CosServerException serverEx)
        {
          Console.WriteLine("CosServerException: " + serverEx.GetInfo());
          Assert.Null(serverEx);
        }
      }
      public void DeleteBucketReplication()
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
        
        string bucket = "bucket-cssg-dotnet-temp-1253653367"; //格式：BucketName-APPID
        DeleteBucketReplicationRequest request = new DeleteBucketReplicationRequest(bucket);
        
        //使用同步方法
        try
        {
          DeleteBucketReplicationResult result = cosXml.DeleteBucketReplication(request);
          Console.WriteLine(result.GetResultInfo());
        }
        catch (COSXML.CosException.CosClientException clientEx)
        {
          Console.WriteLine("CosClientException: " + clientEx);
          Assert.Null(clientEx);
        }
        catch (COSXML.CosException.CosServerException serverEx)
        {
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
      public void testBucketReplication() {
        PutBucketVersioning();
        PutBucketReplication();
        GetBucketReplication();
        DeleteBucketReplication();
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