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
    public class ObjectACLSample {

      string uploadId;

      public void PutObject()
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
          string bucket = "bucket-cssg-test-1253653367"; //存储桶，格式：BucketName-APPID
          string key = "object4dotnet"; //对象在存储桶中的位置，即称对象键
          string srcPath = @"temp-source-file";//本地文件绝对路径
          File.WriteAllBytes(srcPath, new byte[1024]);
        
          PutObjectRequest request = new PutObjectRequest(bucket, key, srcPath);
          //设置签名有效时长
          request.SetSign(TimeUtils.GetCurrentTime(TimeUnit.SECONDS), 600);
          //设置进度回调
          request.SetCosProgressCallback(delegate (long completed, long total)
          {
            Console.WriteLine(String.Format("progress = {0:##.##}%", completed * 100.0 / total));
          });
          //执行请求
          PutObjectResult result = cosXml.PutObject(request);
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
      public void PutObjectAcl()
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
        
        //因为ACL+policy限制最多1000条，为避免acl达到上限，非必须情况不建议给对象单独设置ACL(对象默认继承bucket权限).
        try
        {
          string bucket = "bucket-cssg-test-1253653367"; //存储桶，格式：BucketName-APPID
          string key = "object4dotnet"; //对象在存储桶中的位置，即称对象键
          PutObjectACLRequest request = new PutObjectACLRequest(bucket, key);
          //设置签名有效时长
          request.SetSign(TimeUtils.GetCurrentTime(TimeUnit.SECONDS), 600);
          //设置私有读写权限 
          request.SetCosACL(CosACL.PRIVATE);
          //授予1131975903账号读权限 
          COSXML.Model.Tag.GrantAccount readAccount = new COSXML.Model.Tag.GrantAccount();
          readAccount.AddGrantAccount("1131975903", "1131975903");
          request.SetXCosGrantRead(readAccount);
          //执行请求
          PutObjectACLResult result = cosXml.PutObjectACL(request);
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
      public void GetObjectAcl()
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
          string bucket = "bucket-cssg-test-1253653367"; //存储桶，格式：BucketName-APPID
          string key = "object4dotnet"; //对象在存储桶中的位置，即称对象键
          GetObjectACLRequest request = new GetObjectACLRequest(bucket, key);
          //设置签名有效时长
          request.SetSign(TimeUtils.GetCurrentTime(TimeUnit.SECONDS), 600);
          //执行请求
          GetObjectACLResult result = cosXml.GetObjectACL(request);
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
        
      }

      [Test()]
      public void testObjectACL() {
        PutObject();
        PutObjectAcl();
        GetObjectAcl();
      }

      [TearDown()]
      public void teardown() {
        
      }
    }
}