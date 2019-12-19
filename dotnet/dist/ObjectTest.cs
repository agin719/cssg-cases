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

namespace COSTest
{
    public class ObjectTest {

      string uploadId;
      string eTag;
      public void putBucket()
      {
        //.cssg-snippet-body-start:[put-bucket]
        CosXmlConfig config = new CosXmlConfig.Builder()
          .SetConnectionTimeoutMs(60000)  //设置连接超时时间，单位毫秒，默认45000ms
          .SetReadWriteTimeoutMs(40000)  //设置读写超时时间，单位毫秒，默认45000ms
          .IsHttps(true)  //设置默认 HTTPS 请求
          .SetAppid("1253653367") //设置腾讯云账户的账户标识 APPID
          .SetRegion("ap-guangzhou") //设置一个默认的存储桶地域
          .Build();
        
        string secretId = Environment.GetEnvironmentVariable("COS_KEY");   //云 API 密钥 SecretId
        string secretKey = Environment.GetEnvironmentVariable("COS_SECRET"); //云 API 密钥 SecretKey
        long durationSecond = 600;          //每次请求签名有效时长，单位为秒
        QCloudCredentialProvider qCloudCredentialProvider = new DefaultQCloudCredentialProvider(secretId, 
          secretKey, durationSecond);
        
        CosXml cosXml = new CosXmlServer(config, qCloudCredentialProvider);
        
        try
        {
          string bucket = "bucket-cssg-test-dotnet-1253653367"; //格式：BucketName-APPID
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
        }
        catch (COSXML.CosException.CosServerException serverEx)
        {
          //请求失败
          Console.WriteLine("CosServerException: " + serverEx.GetInfo());
        }
        //.cssg-snippet-body-end
      }   
      public void deleteObject()
      {
        //.cssg-snippet-body-start:[delete-object]
        CosXmlConfig config = new CosXmlConfig.Builder()
          .SetConnectionTimeoutMs(60000)  //设置连接超时时间，单位毫秒，默认45000ms
          .SetReadWriteTimeoutMs(40000)  //设置读写超时时间，单位毫秒，默认45000ms
          .IsHttps(true)  //设置默认 HTTPS 请求
          .SetAppid("1253653367") //设置腾讯云账户的账户标识 APPID
          .SetRegion("ap-guangzhou") //设置一个默认的存储桶地域
          .Build();
        
        string secretId = Environment.GetEnvironmentVariable("COS_KEY");   //云 API 密钥 SecretId
        string secretKey = Environment.GetEnvironmentVariable("COS_SECRET"); //云 API 密钥 SecretKey
        long durationSecond = 600;          //每次请求签名有效时长，单位为秒
        QCloudCredentialProvider qCloudCredentialProvider = new DefaultQCloudCredentialProvider(secretId, 
          secretKey, durationSecond);
        
        CosXml cosXml = new CosXmlServer(config, qCloudCredentialProvider);
        
        try
        {
          string bucket = "bucket-cssg-test-dotnet-1253653367"; //存储桶，格式：BucketName-APPID
          string key = "object4dotnet"; //对象在存储桶中的位置，即称对象键
          DeleteObjectRequest request = new DeleteObjectRequest(bucket, key);
          //设置签名有效时长
          request.SetSign(TimeUtils.GetCurrentTime(TimeUnit.SECONDS), 600);
          //执行请求
          DeleteObjectResult result = cosXml.DeleteObject(request);
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
        //.cssg-snippet-body-end
      }   
      public void deleteBucket()
      {
        //.cssg-snippet-body-start:[delete-bucket]
        CosXmlConfig config = new CosXmlConfig.Builder()
          .SetConnectionTimeoutMs(60000)  //设置连接超时时间，单位毫秒，默认45000ms
          .SetReadWriteTimeoutMs(40000)  //设置读写超时时间，单位毫秒，默认45000ms
          .IsHttps(true)  //设置默认 HTTPS 请求
          .SetAppid("1253653367") //设置腾讯云账户的账户标识 APPID
          .SetRegion("ap-guangzhou") //设置一个默认的存储桶地域
          .Build();
        
        string secretId = Environment.GetEnvironmentVariable("COS_KEY");   //云 API 密钥 SecretId
        string secretKey = Environment.GetEnvironmentVariable("COS_SECRET"); //云 API 密钥 SecretKey
        long durationSecond = 600;          //每次请求签名有效时长，单位为秒
        QCloudCredentialProvider qCloudCredentialProvider = new DefaultQCloudCredentialProvider(secretId, 
          secretKey, durationSecond);
        
        CosXml cosXml = new CosXmlServer(config, qCloudCredentialProvider);
        
        try
        {
          string bucket = "bucket-cssg-test-dotnet-1253653367"; //格式：BucketName-APPID
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
        //.cssg-snippet-body-end
      }   
      public void putObject()
      {
        //.cssg-snippet-body-start:[put-object]
        CosXmlConfig config = new CosXmlConfig.Builder()
          .SetConnectionTimeoutMs(60000)  //设置连接超时时间，单位毫秒，默认45000ms
          .SetReadWriteTimeoutMs(40000)  //设置读写超时时间，单位毫秒，默认45000ms
          .IsHttps(true)  //设置默认 HTTPS 请求
          .SetAppid("1253653367") //设置腾讯云账户的账户标识 APPID
          .SetRegion("ap-guangzhou") //设置一个默认的存储桶地域
          .Build();
        
        string secretId = Environment.GetEnvironmentVariable("COS_KEY");   //云 API 密钥 SecretId
        string secretKey = Environment.GetEnvironmentVariable("COS_SECRET"); //云 API 密钥 SecretKey
        long durationSecond = 600;          //每次请求签名有效时长，单位为秒
        QCloudCredentialProvider qCloudCredentialProvider = new DefaultQCloudCredentialProvider(secretId, 
          secretKey, durationSecond);
        
        CosXml cosXml = new CosXmlServer(config, qCloudCredentialProvider);
        
        try
        {
          string bucket = "bucket-cssg-test-dotnet-1253653367"; //存储桶，格式：BucketName-APPID
          string key = "object4dotnet"; //对象在存储桶中的位置，即称对象键
          string srcPath = @"temp-source-file";//本地文件绝对路径
          if (!File.Exists(srcPath)) {
            // 如果不存在目标文件，创建一个临时的测试文件
            File.WriteAllBytes(srcPath, new byte[1024]);
          }
        
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
        //.cssg-snippet-body-end
      }   
      public void putObjectAcl()
      {
        //.cssg-snippet-body-start:[put-object-acl]
        CosXmlConfig config = new CosXmlConfig.Builder()
          .SetConnectionTimeoutMs(60000)  //设置连接超时时间，单位毫秒，默认45000ms
          .SetReadWriteTimeoutMs(40000)  //设置读写超时时间，单位毫秒，默认45000ms
          .IsHttps(true)  //设置默认 HTTPS 请求
          .SetAppid("1253653367") //设置腾讯云账户的账户标识 APPID
          .SetRegion("ap-guangzhou") //设置一个默认的存储桶地域
          .Build();
        
        string secretId = Environment.GetEnvironmentVariable("COS_KEY");   //云 API 密钥 SecretId
        string secretKey = Environment.GetEnvironmentVariable("COS_SECRET"); //云 API 密钥 SecretKey
        long durationSecond = 600;          //每次请求签名有效时长，单位为秒
        QCloudCredentialProvider qCloudCredentialProvider = new DefaultQCloudCredentialProvider(secretId, 
          secretKey, durationSecond);
        
        CosXml cosXml = new CosXmlServer(config, qCloudCredentialProvider);
        
        // 因为ACL+policy限制最多1000条，为避免acl达到上限，
        // 非必须情况不建议给对象单独设置ACL(对象默认继承bucket权限).
        try
        {
          string bucket = "bucket-cssg-test-dotnet-1253653367"; //存储桶，格式：BucketName-APPID
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
        //.cssg-snippet-body-end
      }   
      public void getObjectAcl()
      {
        //.cssg-snippet-body-start:[get-object-acl]
        CosXmlConfig config = new CosXmlConfig.Builder()
          .SetConnectionTimeoutMs(60000)  //设置连接超时时间，单位毫秒，默认45000ms
          .SetReadWriteTimeoutMs(40000)  //设置读写超时时间，单位毫秒，默认45000ms
          .IsHttps(true)  //设置默认 HTTPS 请求
          .SetAppid("1253653367") //设置腾讯云账户的账户标识 APPID
          .SetRegion("ap-guangzhou") //设置一个默认的存储桶地域
          .Build();
        
        string secretId = Environment.GetEnvironmentVariable("COS_KEY");   //云 API 密钥 SecretId
        string secretKey = Environment.GetEnvironmentVariable("COS_SECRET"); //云 API 密钥 SecretKey
        long durationSecond = 600;          //每次请求签名有效时长，单位为秒
        QCloudCredentialProvider qCloudCredentialProvider = new DefaultQCloudCredentialProvider(secretId, 
          secretKey, durationSecond);
        
        CosXml cosXml = new CosXmlServer(config, qCloudCredentialProvider);
        
        try
        {
          string bucket = "bucket-cssg-test-dotnet-1253653367"; //存储桶，格式：BucketName-APPID
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
        //.cssg-snippet-body-end
      }   
      public void getPresignDownloadUrl()
      {
        //.cssg-snippet-body-start:[get-presign-download-url]
        CosXmlConfig config = new CosXmlConfig.Builder()
          .SetConnectionTimeoutMs(60000)  //设置连接超时时间，单位毫秒，默认45000ms
          .SetReadWriteTimeoutMs(40000)  //设置读写超时时间，单位毫秒，默认45000ms
          .IsHttps(true)  //设置默认 HTTPS 请求
          .SetAppid("1253653367") //设置腾讯云账户的账户标识 APPID
          .SetRegion("ap-guangzhou") //设置一个默认的存储桶地域
          .Build();
        
        string secretId = Environment.GetEnvironmentVariable("COS_KEY");   //云 API 密钥 SecretId
        string secretKey = Environment.GetEnvironmentVariable("COS_SECRET"); //云 API 密钥 SecretKey
        long durationSecond = 600;          //每次请求签名有效时长，单位为秒
        QCloudCredentialProvider qCloudCredentialProvider = new DefaultQCloudCredentialProvider(secretId, 
          secretKey, durationSecond);
        
        CosXml cosXml = new CosXmlServer(config, qCloudCredentialProvider);
        
        try
        {
          PreSignatureStruct preSignatureStruct = new PreSignatureStruct();
          preSignatureStruct.appid = "1253653367";//腾讯云账号 APPID
          preSignatureStruct.region = "ap-guangzhou"; //存储桶地域
          preSignatureStruct.bucket = "bucket-cssg-test-dotnet-1253653367"; //存储桶
          preSignatureStruct.key = "object4dotnet"; //对象键
          preSignatureStruct.httpMethod = "GET"; //HTTP 请求方法
          preSignatureStruct.isHttps = true; //生成 HTTPS 请求 URL
          preSignatureStruct.signDurationSecond = 600; //请求签名时间为600s
          preSignatureStruct.headers = null;//签名中需要校验的 header
          preSignatureStruct.queryParameters = null; //签名中需要校验的 URL 中请求参数
        
          string requestSignURL = cosXml.GenerateSignURL(preSignatureStruct); 
        
          //下载请求预签名 URL (使用永久密钥方式计算的签名 URL)
          string localDir = System.IO.Path.GetTempPath();//本地文件夹
          string localFileName = "my-local-temp-file"; //指定本地保存的文件名
          GetObjectRequest request = new GetObjectRequest(null, null, localDir, localFileName);
          //设置下载请求预签名 URL
          request.RequestURLWithSign = requestSignURL;
          //设置进度回调
          request.SetCosProgressCallback(delegate (long completed, long total)
          {
            Console.WriteLine(String.Format("progress = {0:##.##}%", completed * 100.0 / total));
          });
          //执行请求
          GetObjectResult result = cosXml.GetObject(request);
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
        //.cssg-snippet-body-end
      }   
      public void getPresignUploadUrl()
      {
        //.cssg-snippet-body-start:[get-presign-upload-url]
        CosXmlConfig config = new CosXmlConfig.Builder()
          .SetConnectionTimeoutMs(60000)  //设置连接超时时间，单位毫秒，默认45000ms
          .SetReadWriteTimeoutMs(40000)  //设置读写超时时间，单位毫秒，默认45000ms
          .IsHttps(true)  //设置默认 HTTPS 请求
          .SetAppid("1253653367") //设置腾讯云账户的账户标识 APPID
          .SetRegion("ap-guangzhou") //设置一个默认的存储桶地域
          .Build();
        
        string secretId = Environment.GetEnvironmentVariable("COS_KEY");   //云 API 密钥 SecretId
        string secretKey = Environment.GetEnvironmentVariable("COS_SECRET"); //云 API 密钥 SecretKey
        long durationSecond = 600;          //每次请求签名有效时长，单位为秒
        QCloudCredentialProvider qCloudCredentialProvider = new DefaultQCloudCredentialProvider(secretId, 
          secretKey, durationSecond);
        
        CosXml cosXml = new CosXmlServer(config, qCloudCredentialProvider);
        
        try
        {
          PreSignatureStruct preSignatureStruct = new PreSignatureStruct();
          preSignatureStruct.appid = "1253653367";//腾讯云账号 APPID
          preSignatureStruct.region = "ap-guangzhou"; //存储桶地域
          preSignatureStruct.bucket = "bucket-cssg-test-dotnet-1253653367"; //存储桶
          preSignatureStruct.key = "object4dotnet"; //对象键
          preSignatureStruct.httpMethod = "PUT"; //HTTP 请求方法
          preSignatureStruct.isHttps = true; //生成 HTTPS 请求 URL
          preSignatureStruct.signDurationSecond = 600; //请求签名时间为 600s
          preSignatureStruct.headers = null;//签名中需要校验的 header
          preSignatureStruct.queryParameters = null; //签名中需要校验的 URL 中请求参数
        
          //上传预签名 URL (使用永久密钥方式计算的签名 URL)
          string requestSignURL = cosXml.GenerateSignURL(preSignatureStruct);
        
          string srcPath = @"temp-source-file";//本地文件绝地路径
          PutObjectRequest request = new PutObjectRequest(null, null, srcPath);
          //设置上传请求预签名 URL
          request.RequestURLWithSign = requestSignURL;
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
        //.cssg-snippet-body-end
      }   
      public void deleteMultiObject()
      {
        //.cssg-snippet-body-start:[delete-multi-object]
        CosXmlConfig config = new CosXmlConfig.Builder()
          .SetConnectionTimeoutMs(60000)  //设置连接超时时间，单位毫秒，默认45000ms
          .SetReadWriteTimeoutMs(40000)  //设置读写超时时间，单位毫秒，默认45000ms
          .IsHttps(true)  //设置默认 HTTPS 请求
          .SetAppid("1253653367") //设置腾讯云账户的账户标识 APPID
          .SetRegion("ap-guangzhou") //设置一个默认的存储桶地域
          .Build();
        
        string secretId = Environment.GetEnvironmentVariable("COS_KEY");   //云 API 密钥 SecretId
        string secretKey = Environment.GetEnvironmentVariable("COS_SECRET"); //云 API 密钥 SecretKey
        long durationSecond = 600;          //每次请求签名有效时长，单位为秒
        QCloudCredentialProvider qCloudCredentialProvider = new DefaultQCloudCredentialProvider(secretId, 
          secretKey, durationSecond);
        
        CosXml cosXml = new CosXmlServer(config, qCloudCredentialProvider);
        
        try
        {
          string bucket = "bucket-cssg-test-dotnet-1253653367"; //存储桶，格式：BucketName-APPID
          DeleteMultiObjectRequest request = new DeleteMultiObjectRequest(bucket);
          //设置签名有效时长
          request.SetSign(TimeUtils.GetCurrentTime(TimeUnit.SECONDS), 600);
          //设置返回结果形式
          request.SetDeleteQuiet(false);
          //对象key
          string key = "object4dotnet"; //对象在存储桶中的位置，即称对象键
          List<string> objects = new List<string>();
          objects.Add(key);
          request.SetObjectKeys(objects);
          //执行请求
          DeleteMultiObjectResult result = cosXml.DeleteMultiObjects(request);
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
        //.cssg-snippet-body-end
      }   
      public void postObject()
      {
        //.cssg-snippet-body-start:[post-object]
        CosXmlConfig config = new CosXmlConfig.Builder()
          .SetConnectionTimeoutMs(60000)  //设置连接超时时间，单位毫秒，默认45000ms
          .SetReadWriteTimeoutMs(40000)  //设置读写超时时间，单位毫秒，默认45000ms
          .IsHttps(true)  //设置默认 HTTPS 请求
          .SetAppid("1253653367") //设置腾讯云账户的账户标识 APPID
          .SetRegion("ap-guangzhou") //设置一个默认的存储桶地域
          .Build();
        
        string secretId = Environment.GetEnvironmentVariable("COS_KEY");   //云 API 密钥 SecretId
        string secretKey = Environment.GetEnvironmentVariable("COS_SECRET"); //云 API 密钥 SecretKey
        long durationSecond = 600;          //每次请求签名有效时长，单位为秒
        QCloudCredentialProvider qCloudCredentialProvider = new DefaultQCloudCredentialProvider(secretId, 
          secretKey, durationSecond);
        
        CosXml cosXml = new CosXmlServer(config, qCloudCredentialProvider);
        
        try
        {
          string bucket = "bucket-cssg-test-dotnet-1253653367"; //存储桶，格式：BucketName-APPID
          string key = "object4dotnet"; //对象在存储桶中的位置，即称对象键
          string srcPath = @"temp-source-file";//本地文件绝对路径
          if (!File.Exists(srcPath)) {
            // 如果不存在目标文件，创建一个临时的测试文件
            File.WriteAllBytes(srcPath, new byte[1024]);
          }
          PostObjectRequest request = new PostObjectRequest(bucket, key, srcPath);
          //设置签名有效时长
          request.SetSign(TimeUtils.GetCurrentTime(TimeUnit.SECONDS), 600);
          //设置进度回调
          request.SetCosProgressCallback(delegate (long completed, long total)
          {
            Console.WriteLine(String.Format("progress = {0:##.##}%", completed * 100.0 / total));
          });
          //执行请求
          PostObjectResult result = cosXml.PostObject(request);
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
        //.cssg-snippet-body-end
      }   
      public void restoreObject()
      {
        //.cssg-snippet-body-start:[restore-object]
        CosXmlConfig config = new CosXmlConfig.Builder()
          .SetConnectionTimeoutMs(60000)  //设置连接超时时间，单位毫秒，默认45000ms
          .SetReadWriteTimeoutMs(40000)  //设置读写超时时间，单位毫秒，默认45000ms
          .IsHttps(true)  //设置默认 HTTPS 请求
          .SetAppid("1253653367") //设置腾讯云账户的账户标识 APPID
          .SetRegion("ap-guangzhou") //设置一个默认的存储桶地域
          .Build();
        
        string secretId = Environment.GetEnvironmentVariable("COS_KEY");   //云 API 密钥 SecretId
        string secretKey = Environment.GetEnvironmentVariable("COS_SECRET"); //云 API 密钥 SecretKey
        long durationSecond = 600;          //每次请求签名有效时长，单位为秒
        QCloudCredentialProvider qCloudCredentialProvider = new DefaultQCloudCredentialProvider(secretId, 
          secretKey, durationSecond);
        
        CosXml cosXml = new CosXmlServer(config, qCloudCredentialProvider);
        
        try
        {
          string bucket = "bucket-cssg-test-dotnet-1253653367"; //存储桶，格式：BucketName-APPID
          string key = "object4dotnet"; //对象在存储桶中的位置，即称对象键
          RestoreObjectRequest request = new RestoreObjectRequest(bucket, key);
          //设置签名有效时长
          request.SetSign(TimeUtils.GetCurrentTime(TimeUnit.SECONDS), 600);
          //恢复时间
          request.SetExpireDays(3);
          request.SetTier(COSXML.Model.Tag.RestoreConfigure.Tier.Bulk);
        
          //执行请求
          RestoreObjectResult result = cosXml.RestoreObject(request);
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
        //.cssg-snippet-body-end
      }   
      public void initMultiUpload()
      {
        //.cssg-snippet-body-start:[init-multi-upload]
        CosXmlConfig config = new CosXmlConfig.Builder()
          .SetConnectionTimeoutMs(60000)  //设置连接超时时间，单位毫秒，默认45000ms
          .SetReadWriteTimeoutMs(40000)  //设置读写超时时间，单位毫秒，默认45000ms
          .IsHttps(true)  //设置默认 HTTPS 请求
          .SetAppid("1253653367") //设置腾讯云账户的账户标识 APPID
          .SetRegion("ap-guangzhou") //设置一个默认的存储桶地域
          .Build();
        
        string secretId = Environment.GetEnvironmentVariable("COS_KEY");   //云 API 密钥 SecretId
        string secretKey = Environment.GetEnvironmentVariable("COS_SECRET"); //云 API 密钥 SecretKey
        long durationSecond = 600;          //每次请求签名有效时长，单位为秒
        QCloudCredentialProvider qCloudCredentialProvider = new DefaultQCloudCredentialProvider(secretId, 
          secretKey, durationSecond);
        
        CosXml cosXml = new CosXmlServer(config, qCloudCredentialProvider);
        
        try
        {
          string bucket = "bucket-cssg-test-dotnet-1253653367"; //存储桶，格式：BucketName-APPID
          string key = "object4dotnet"; //对象在存储桶中的位置，即称对象键
          InitMultipartUploadRequest request = new InitMultipartUploadRequest(bucket, key);
          //设置签名有效时长
          request.SetSign(TimeUtils.GetCurrentTime(TimeUnit.SECONDS), 600);
          //执行请求
          InitMultipartUploadResult result = cosXml.InitMultipartUpload(request);
          //请求成功
          this.uploadId = result.initMultipartUpload.uploadId; //用于后续分块上传的 uploadId
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
        //.cssg-snippet-body-end
      }   
      public void listMultiUpload()
      {
        //.cssg-snippet-body-start:[list-multi-upload]
        CosXmlConfig config = new CosXmlConfig.Builder()
          .SetConnectionTimeoutMs(60000)  //设置连接超时时间，单位毫秒，默认45000ms
          .SetReadWriteTimeoutMs(40000)  //设置读写超时时间，单位毫秒，默认45000ms
          .IsHttps(true)  //设置默认 HTTPS 请求
          .SetAppid("1253653367") //设置腾讯云账户的账户标识 APPID
          .SetRegion("ap-guangzhou") //设置一个默认的存储桶地域
          .Build();
        
        string secretId = Environment.GetEnvironmentVariable("COS_KEY");   //云 API 密钥 SecretId
        string secretKey = Environment.GetEnvironmentVariable("COS_SECRET"); //云 API 密钥 SecretKey
        long durationSecond = 600;          //每次请求签名有效时长，单位为秒
        QCloudCredentialProvider qCloudCredentialProvider = new DefaultQCloudCredentialProvider(secretId, 
          secretKey, durationSecond);
        
        CosXml cosXml = new CosXmlServer(config, qCloudCredentialProvider);
        
        try
        {
          string bucket = "bucket-cssg-test-dotnet-1253653367"; //格式：BucketName-APPID
          ListMultiUploadsRequest request = new ListMultiUploadsRequest(bucket);
          //设置签名有效时长
          request.SetSign(TimeUtils.GetCurrentTime(TimeUnit.SECONDS), 600);
          //执行请求
          ListMultiUploadsResult result = cosXml.ListMultiUploads(request);
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
        //.cssg-snippet-body-end
      }   
      public void uploadPart()
      {
        //.cssg-snippet-body-start:[upload-part]
        CosXmlConfig config = new CosXmlConfig.Builder()
          .SetConnectionTimeoutMs(60000)  //设置连接超时时间，单位毫秒，默认45000ms
          .SetReadWriteTimeoutMs(40000)  //设置读写超时时间，单位毫秒，默认45000ms
          .IsHttps(true)  //设置默认 HTTPS 请求
          .SetAppid("1253653367") //设置腾讯云账户的账户标识 APPID
          .SetRegion("ap-guangzhou") //设置一个默认的存储桶地域
          .Build();
        
        string secretId = Environment.GetEnvironmentVariable("COS_KEY");   //云 API 密钥 SecretId
        string secretKey = Environment.GetEnvironmentVariable("COS_SECRET"); //云 API 密钥 SecretKey
        long durationSecond = 600;          //每次请求签名有效时长，单位为秒
        QCloudCredentialProvider qCloudCredentialProvider = new DefaultQCloudCredentialProvider(secretId, 
          secretKey, durationSecond);
        
        CosXml cosXml = new CosXmlServer(config, qCloudCredentialProvider);
        
        try
        {
          string bucket = "bucket-cssg-test-dotnet-1253653367"; //存储桶，格式：BucketName-APPID
          string key = "object4dotnet"; //对象在存储桶中的位置，即称对象键
          string uploadId = this.uploadId; //初始化分块上传返回的uploadId
          int partNumber = 1; //分块编号，必须从1开始递增
          string srcPath = @"temp-source-file";//本地文件绝对路径
          if (!File.Exists(srcPath)) {
            // 如果不存在目标文件，创建一个临时的测试文件
            File.WriteAllBytes(srcPath, new byte[1024]);
          }
          UploadPartRequest request = new UploadPartRequest(bucket, key, partNumber, 
            uploadId, srcPath);
          //设置签名有效时长
          request.SetSign(TimeUtils.GetCurrentTime(TimeUnit.SECONDS), 600);
          //设置进度回调
          request.SetCosProgressCallback(delegate (long completed, long total)
          {
            Console.WriteLine(String.Format("progress = {0:##.##}%", completed * 100.0 / total));
          });
          //执行请求
          UploadPartResult result = cosXml.UploadPart(request);
          //请求成功
          //获取返回分块的eTag,用于后续CompleteMultiUploads
          this.eTag = result.eTag;
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
        //.cssg-snippet-body-end
      }   
      public void listParts()
      {
        //.cssg-snippet-body-start:[list-parts]
        CosXmlConfig config = new CosXmlConfig.Builder()
          .SetConnectionTimeoutMs(60000)  //设置连接超时时间，单位毫秒，默认45000ms
          .SetReadWriteTimeoutMs(40000)  //设置读写超时时间，单位毫秒，默认45000ms
          .IsHttps(true)  //设置默认 HTTPS 请求
          .SetAppid("1253653367") //设置腾讯云账户的账户标识 APPID
          .SetRegion("ap-guangzhou") //设置一个默认的存储桶地域
          .Build();
        
        string secretId = Environment.GetEnvironmentVariable("COS_KEY");   //云 API 密钥 SecretId
        string secretKey = Environment.GetEnvironmentVariable("COS_SECRET"); //云 API 密钥 SecretKey
        long durationSecond = 600;          //每次请求签名有效时长，单位为秒
        QCloudCredentialProvider qCloudCredentialProvider = new DefaultQCloudCredentialProvider(secretId, 
          secretKey, durationSecond);
        
        CosXml cosXml = new CosXmlServer(config, qCloudCredentialProvider);
        
        try
        {
          string bucket = "bucket-cssg-test-dotnet-1253653367"; //存储桶，格式：BucketName-APPID
          string key = "object4dotnet"; //对象在存储桶中的位置，即称对象键
          string uploadId = this.uploadId; //初始化分块上传返回的uploadId
          ListPartsRequest request = new ListPartsRequest(bucket, key, uploadId);
          //设置签名有效时长
          request.SetSign(TimeUtils.GetCurrentTime(TimeUnit.SECONDS), 600);
          //执行请求
          ListPartsResult result = cosXml.ListParts(request);
          //请求成功
          //列举已上传的分块
          List<COSXML.Model.Tag.ListParts.Part> alreadyUploadParts = result.listParts.parts;
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
        //.cssg-snippet-body-end
      }   
      public void completeMultiUpload()
      {
        //.cssg-snippet-body-start:[complete-multi-upload]
        CosXmlConfig config = new CosXmlConfig.Builder()
          .SetConnectionTimeoutMs(60000)  //设置连接超时时间，单位毫秒，默认45000ms
          .SetReadWriteTimeoutMs(40000)  //设置读写超时时间，单位毫秒，默认45000ms
          .IsHttps(true)  //设置默认 HTTPS 请求
          .SetAppid("1253653367") //设置腾讯云账户的账户标识 APPID
          .SetRegion("ap-guangzhou") //设置一个默认的存储桶地域
          .Build();
        
        string secretId = Environment.GetEnvironmentVariable("COS_KEY");   //云 API 密钥 SecretId
        string secretKey = Environment.GetEnvironmentVariable("COS_SECRET"); //云 API 密钥 SecretKey
        long durationSecond = 600;          //每次请求签名有效时长，单位为秒
        QCloudCredentialProvider qCloudCredentialProvider = new DefaultQCloudCredentialProvider(secretId, 
          secretKey, durationSecond);
        
        CosXml cosXml = new CosXmlServer(config, qCloudCredentialProvider);
        
        try
        {
          string bucket = "bucket-cssg-test-dotnet-1253653367"; //存储桶，格式：BucketName-APPID
          string key = "object4dotnet"; //对象在存储桶中的位置，即称对象键
          string uploadId = this.uploadId; //初始化分块上传返回的uploadId
          CompleteMultipartUploadRequest request = new CompleteMultipartUploadRequest(bucket, 
            key, uploadId);
          //设置签名有效时长
          request.SetSign(TimeUtils.GetCurrentTime(TimeUnit.SECONDS), 600);
          //设置已上传的parts,必须有序，按照partNumber递增
          // request.SetPartNumberAndETag(1, "Example Etag");
          string etag = this.eTag;
          request.SetPartNumberAndETag(1, etag);
          //执行请求
          CompleteMultipartUploadResult result = cosXml.CompleteMultiUpload(request);
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
        //.cssg-snippet-body-end
      }   
      public void abortMultiUpload()
      {
        //.cssg-snippet-body-start:[abort-multi-upload]
        CosXmlConfig config = new CosXmlConfig.Builder()
          .SetConnectionTimeoutMs(60000)  //设置连接超时时间，单位毫秒，默认45000ms
          .SetReadWriteTimeoutMs(40000)  //设置读写超时时间，单位毫秒，默认45000ms
          .IsHttps(true)  //设置默认 HTTPS 请求
          .SetAppid("1253653367") //设置腾讯云账户的账户标识 APPID
          .SetRegion("ap-guangzhou") //设置一个默认的存储桶地域
          .Build();
        
        string secretId = Environment.GetEnvironmentVariable("COS_KEY");   //云 API 密钥 SecretId
        string secretKey = Environment.GetEnvironmentVariable("COS_SECRET"); //云 API 密钥 SecretKey
        long durationSecond = 600;          //每次请求签名有效时长，单位为秒
        QCloudCredentialProvider qCloudCredentialProvider = new DefaultQCloudCredentialProvider(secretId, 
          secretKey, durationSecond);
        
        CosXml cosXml = new CosXmlServer(config, qCloudCredentialProvider);
        
        try
        {
          string bucket = "bucket-cssg-test-dotnet-1253653367"; //存储桶，格式：BucketName-APPID
          string key = "object4dotnet"; //对象在存储桶中的位置，即称对象键
          string uploadId = this.uploadId; //初始化分块上传返回的uploadId
          AbortMultipartUploadRequest request = new AbortMultipartUploadRequest(bucket, key, uploadId);
          //设置签名有效时长
          request.SetSign(TimeUtils.GetCurrentTime(TimeUnit.SECONDS), 600);
          //执行请求
          AbortMultipartUploadResult result = cosXml.AbortMultiUpload(request);
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
        //.cssg-snippet-body-end
      }   
      public void transferUploadObject()
      {
        //.cssg-snippet-body-start:[transfer-upload-object]
        CosXmlConfig config = new CosXmlConfig.Builder()
          .SetConnectionTimeoutMs(60000)  //设置连接超时时间，单位毫秒，默认45000ms
          .SetReadWriteTimeoutMs(40000)  //设置读写超时时间，单位毫秒，默认45000ms
          .IsHttps(true)  //设置默认 HTTPS 请求
          .SetAppid("1253653367") //设置腾讯云账户的账户标识 APPID
          .SetRegion("ap-guangzhou") //设置一个默认的存储桶地域
          .Build();
        
        string secretId = Environment.GetEnvironmentVariable("COS_KEY");   //云 API 密钥 SecretId
        string secretKey = Environment.GetEnvironmentVariable("COS_SECRET"); //云 API 密钥 SecretKey
        long durationSecond = 600;          //每次请求签名有效时长，单位为秒
        QCloudCredentialProvider qCloudCredentialProvider = new DefaultQCloudCredentialProvider(secretId, 
          secretKey, durationSecond);
        
        CosXml cosXml = new CosXmlServer(config, qCloudCredentialProvider);
        
        // 初始化 TransferConfig
        TransferConfig transferConfig = new TransferConfig();
        
        // 初始化 TransferManager
        TransferManager transferManager = new TransferManager(cosXml, transferConfig);
        
        String bucket = "bucket-cssg-test-dotnet-1253653367"; //存储桶，格式：BucketName-APPID
        String cosPath = "object4dotnet"; //对象在存储桶中的位置标识符，即称对象键
        string srcPath = @"temp-source-file";//本地文件绝对路径
        if (!File.Exists(srcPath)) {
          // 如果不存在目标文件，创建一个临时的测试文件
          File.WriteAllBytes(srcPath, new byte[1024]);
        }
        
        // 上传对象
        COSXMLUploadTask uploadTask = new COSXMLUploadTask(bucket, "ap-guangzhou", cosPath); // ap-guangzhou 为存储桶所在地域
        uploadTask.SetSrcPath(srcPath);
        
        // 同步调用
        var autoEvent = new AutoResetEvent(false);
        
        uploadTask.progressCallback = delegate (long completed, long total)
        {
            Console.WriteLine(String.Format("progress = {0:##.##}%", completed * 100.0 / total));
        };
        uploadTask.successCallback = delegate (CosResult cosResult) 
        {
            COSXML.Transfer.COSXMLUploadTask.UploadTaskResult result = cosResult as COSXML.Transfer.COSXMLUploadTask.UploadTaskResult;
            Console.WriteLine(result.GetResultInfo());
            string eTag = result.eTag;
            autoEvent.Set();
        };
        uploadTask.failCallback = delegate (CosClientException clientEx, CosServerException serverEx) 
        {
            if (clientEx != null)
            {
                Console.WriteLine("CosClientException: " + clientEx);
                Assert.Null(clientEx);
            }
            if (serverEx != null)
            {
                Console.WriteLine("CosServerException: " + serverEx.GetInfo());
                Assert.Null(serverEx);
            }
            autoEvent.Set();
        };
        transferManager.Upload(uploadTask);
        // 等待任务结束
        autoEvent.WaitOne();
        
        //取消上传
        // cosxmlUploadTask.cancel();
        
        
        //暂停上传
        // cosxmlUploadTask.pause();
        
        //恢复上传
        // cosxmlUploadTask.resume();
        //.cssg-snippet-body-end
      }   
      public void copyObject()
      {
        //.cssg-snippet-body-start:[copy-object]
        CosXmlConfig config = new CosXmlConfig.Builder()
          .SetConnectionTimeoutMs(60000)  //设置连接超时时间，单位毫秒，默认45000ms
          .SetReadWriteTimeoutMs(40000)  //设置读写超时时间，单位毫秒，默认45000ms
          .IsHttps(true)  //设置默认 HTTPS 请求
          .SetAppid("1253653367") //设置腾讯云账户的账户标识 APPID
          .SetRegion("ap-guangzhou") //设置一个默认的存储桶地域
          .Build();
        
        string secretId = Environment.GetEnvironmentVariable("COS_KEY");   //云 API 密钥 SecretId
        string secretKey = Environment.GetEnvironmentVariable("COS_SECRET"); //云 API 密钥 SecretKey
        long durationSecond = 600;          //每次请求签名有效时长，单位为秒
        QCloudCredentialProvider qCloudCredentialProvider = new DefaultQCloudCredentialProvider(secretId, 
          secretKey, durationSecond);
        
        CosXml cosXml = new CosXmlServer(config, qCloudCredentialProvider);
        
        try
        {
          string sourceAppid = "1253653367"; //账号 appid
          string sourceBucket = "bucket-cssg-source-1253653367"; //"源对象所在的存储桶
          string sourceRegion = "ap-guangzhou"; //源对象的存储桶所在的地域
          string sourceKey = "sourceObject"; //源对象键
          //构造源对象属性
          CopySourceStruct copySource = new CopySourceStruct(sourceAppid, sourceBucket, 
            sourceRegion, sourceKey);
        
          string bucket = "bucket-cssg-test-dotnet-1253653367"; //存储桶，格式：BucketName-APPID
          string key = "object4dotnet"; //对象在存储桶中的位置，即称对象键
          CopyObjectRequest request = new CopyObjectRequest(bucket, key);
          //设置签名有效时长
          request.SetSign(TimeUtils.GetCurrentTime(TimeUnit.SECONDS), 600);
          //设置拷贝源
          request.SetCopySource(copySource);
          //设置是否拷贝还是更新,此处是拷贝
          request.SetCopyMetaDataDirective(COSXML.Common.CosMetaDataDirective.COPY);
          //执行请求
          CopyObjectResult result = cosXml.CopyObject(request);
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
        //.cssg-snippet-body-end
      }   
      public void uploadPartCopy()
      {
        //.cssg-snippet-body-start:[upload-part-copy]
        CosXmlConfig config = new CosXmlConfig.Builder()
          .SetConnectionTimeoutMs(60000)  //设置连接超时时间，单位毫秒，默认45000ms
          .SetReadWriteTimeoutMs(40000)  //设置读写超时时间，单位毫秒，默认45000ms
          .IsHttps(true)  //设置默认 HTTPS 请求
          .SetAppid("1253653367") //设置腾讯云账户的账户标识 APPID
          .SetRegion("ap-guangzhou") //设置一个默认的存储桶地域
          .Build();
        
        string secretId = Environment.GetEnvironmentVariable("COS_KEY");   //云 API 密钥 SecretId
        string secretKey = Environment.GetEnvironmentVariable("COS_SECRET"); //云 API 密钥 SecretKey
        long durationSecond = 600;          //每次请求签名有效时长，单位为秒
        QCloudCredentialProvider qCloudCredentialProvider = new DefaultQCloudCredentialProvider(secretId, 
          secretKey, durationSecond);
        
        CosXml cosXml = new CosXmlServer(config, qCloudCredentialProvider);
        
        try
        {
          string sourceAppid = "1253653367"; //账号 appid
          string sourceBucket = "bucket-cssg-source-1253653367"; //"源对象所在的存储桶
          string sourceRegion = "ap-guangzhou"; //源对象的存储桶所在的地域
          string sourceKey = "sourceObject"; //源对象键
          //构造源对象属性
          COSXML.Model.Tag.CopySourceStruct copySource = new CopySourceStruct(sourceAppid, 
            sourceBucket, sourceRegion, sourceKey);
        
          string bucket = "bucket-cssg-test-dotnet-1253653367"; //存储桶，格式：BucketName-APPID
          string key = "object4dotnet"; //对象在存储桶中的位置，即称对象键
          string uploadId = this.uploadId; //初始化分块上传返回的uploadId
          int partNumber = 1; //分块编号，必须从1开始递增
          UploadPartCopyRequest request = new UploadPartCopyRequest(bucket, key, 
            partNumber, uploadId);
          //设置签名有效时长
          request.SetSign(TimeUtils.GetCurrentTime(TimeUnit.SECONDS), 600);
          //设置拷贝源
          request.SetCopySource(copySource);
          //设置复制分块（指定块的范围，如 0 ~ 1M）
          request.SetCopyRange(0, 1024 * 1024);
          //执行请求
          UploadPartCopyResult result = cosXml.PartCopy(request);
          //请求成功
          //获取返回分块的eTag,用于后续CompleteMultiUploads
          this.eTag = result.copyObject.eTag;
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
        //.cssg-snippet-body-end
      }   
      public void headObject()
      {
        //.cssg-snippet-body-start:[head-object]
        CosXmlConfig config = new CosXmlConfig.Builder()
          .SetConnectionTimeoutMs(60000)  //设置连接超时时间，单位毫秒，默认45000ms
          .SetReadWriteTimeoutMs(40000)  //设置读写超时时间，单位毫秒，默认45000ms
          .IsHttps(true)  //设置默认 HTTPS 请求
          .SetAppid("1253653367") //设置腾讯云账户的账户标识 APPID
          .SetRegion("ap-guangzhou") //设置一个默认的存储桶地域
          .Build();
        
        string secretId = Environment.GetEnvironmentVariable("COS_KEY");   //云 API 密钥 SecretId
        string secretKey = Environment.GetEnvironmentVariable("COS_SECRET"); //云 API 密钥 SecretKey
        long durationSecond = 600;          //每次请求签名有效时长，单位为秒
        QCloudCredentialProvider qCloudCredentialProvider = new DefaultQCloudCredentialProvider(secretId, 
          secretKey, durationSecond);
        
        CosXml cosXml = new CosXmlServer(config, qCloudCredentialProvider);
        
        try
        {
          string bucket = "bucket-cssg-test-dotnet-1253653367"; //存储桶，格式：BucketName-APPID
          string key = "object4dotnet"; //对象在存储桶中的位置，即称对象键
          HeadObjectRequest request = new HeadObjectRequest(bucket, key);
          //设置签名有效时长
          request.SetSign(TimeUtils.GetCurrentTime(TimeUnit.SECONDS), 600);
          //执行请求
          HeadObjectResult result = cosXml.HeadObject(request);
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
        //.cssg-snippet-body-end
      }   
      public void getObject()
      {
        //.cssg-snippet-body-start:[get-object]
        CosXmlConfig config = new CosXmlConfig.Builder()
          .SetConnectionTimeoutMs(60000)  //设置连接超时时间，单位毫秒，默认45000ms
          .SetReadWriteTimeoutMs(40000)  //设置读写超时时间，单位毫秒，默认45000ms
          .IsHttps(true)  //设置默认 HTTPS 请求
          .SetAppid("1253653367") //设置腾讯云账户的账户标识 APPID
          .SetRegion("ap-guangzhou") //设置一个默认的存储桶地域
          .Build();
        
        string secretId = Environment.GetEnvironmentVariable("COS_KEY");   //云 API 密钥 SecretId
        string secretKey = Environment.GetEnvironmentVariable("COS_SECRET"); //云 API 密钥 SecretKey
        long durationSecond = 600;          //每次请求签名有效时长，单位为秒
        QCloudCredentialProvider qCloudCredentialProvider = new DefaultQCloudCredentialProvider(secretId, 
          secretKey, durationSecond);
        
        CosXml cosXml = new CosXmlServer(config, qCloudCredentialProvider);
        
        try
        {
          string bucket = "bucket-cssg-test-dotnet-1253653367"; //存储桶，格式：BucketName-APPID
          string key = "object4dotnet"; //对象在存储桶中的位置，即称对象键
          string localDir = System.IO.Path.GetTempPath();//本地文件夹
          string localFileName = "my-local-temp-file"; //指定本地保存的文件名
          GetObjectRequest request = new GetObjectRequest(bucket, key, localDir, localFileName);
          //设置签名有效时长
          request.SetSign(TimeUtils.GetCurrentTime(TimeUnit.SECONDS), 600);
          //设置进度回调
          request.SetCosProgressCallback(delegate (long completed, long total)
          {
            Console.WriteLine(String.Format("progress = {0:##.##}%", completed * 100.0 / total));
          });
          //执行请求
          GetObjectResult result = cosXml.GetObject(request);
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
        
        //下载返回 bytes 数据
        try
        {
          string bucket = "bucket-cssg-test-dotnet-1253653367"; //存储桶，格式：BucketName-APPID
          string key = "object4dotnet"; //对象在存储桶中的位置，即称对象键
        
          GetObjectBytesRequest request = new GetObjectBytesRequest(bucket, key);
          //设置签名有效时长
          request.SetSign(TimeUtils.GetCurrentTime(TimeUnit.SECONDS), 600);
          //设置进度回调
          request.SetCosProgressCallback(delegate (long completed, long total)
          {
            Console.WriteLine(String.Format("progress = {0:##.##}%", completed * 100.0 / total));
          });
          //执行请求
          GetObjectBytesResult result = cosXml.GetObject(request);
          //获取内容
          byte[] content = result.content;
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
        //.cssg-snippet-body-end
      }   


      [SetUp()]
      public void setup() {
        putBucket();
      }

      [TearDown()]
      public void teardown() {
        deleteObject();
        deleteBucket();
      }

      [Test()]
      public void testObjectMetadata() {
        putObject();
        putObjectAcl();
        getObjectAcl();
        getPresignDownloadUrl();
        getPresignUploadUrl();
        deleteMultiObject();
        postObject();
        restoreObject();
      }

      [Test()]
      public void testObjectMultiUpload() {
        initMultiUpload();
        listMultiUpload();
        uploadPart();
        listParts();
        completeMultiUpload();
      }

      [Test()]
      public void testObjectAbortMultiUpload() {
        initMultiUpload();
        uploadPart();
        abortMultiUpload();
      }

      [Test()]
      public void testObjectTransfer() {
        transferUploadObject();
      }

      [Test()]
      public void testObjectCopy() {
        copyObject();
        initMultiUpload();
        uploadPartCopy();
        completeMultiUpload();
      }

      [Test()]
      public void testObjectPutget() {
        putObject();
        headObject();
        getObject();
        deleteObject();
      }

    }
}