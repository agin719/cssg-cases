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

// cssg-snippet-lang: [dotnet]
namespace COSSample
{
  public class Assembly
  {

    CosXml cosXml = new CosXmlServer(null, null);

    // .cssg-body-start: [global-init-custom-credential-provider]
    //方式3: 自定义方式提供密钥， 继承 QCloudCredentialProvider 并重写 GetQCloudCredentials() 方法
    public class MyQCloudCredentialProvider : QCloudCredentialProvider
    {
      public override QCloudCredentials GetQCloudCredentials()
      {
        string secretId = "COS_SECRETID"; //密钥 SecretId
        string secretKey = "COS_SECRETKEY"; //密钥 SecretKey
        //密钥有效时间, 精确到秒，例如1546862502;1546863102
        string keyTime = "SECRET_STARTTIME;SECRET_ENDTIME"; 
        return new QCloudCredentials(secretId, secretKey, keyTime);
      }

      public override void Refresh()
      {
        //更新密钥信息，密钥过期会自动回调该方法
      }
    }
    // .cssg-body-end

    public void test40() {
      // .cssg-body-start: [global-header]
      CosXmlConfig config = new CosXmlConfig.Builder()
        .SetConnectionTimeoutMs(60000)  //设置连接超时时间，单位毫秒，默认45000ms
        .SetReadWriteTimeoutMs(40000)  //设置读写超时时间，单位毫秒，默认45000ms
        .IsHttps(true)  //设置默认 HTTPS 请求
        .SetAppid("{{{appId}}}") //设置腾讯云账户的账户标识 APPID
        .SetRegion("{{{region}}}") //设置一个默认的存储桶地域
        .Build();

      string secretId = ">>{{{secretId}}}<<";   //云 API 密钥 SecretId
      string secretKey = ">>{{{secretKey}}}<<"; //云 API 密钥 SecretKey
      long durationSecond = 600;          //每次请求签名有效时长，单位为秒
      QCloudCredentialProvider qCloudCredentialProvider = new DefaultQCloudCredentialProvider(secretId, 
        secretKey, durationSecond);

      CosXml cosXml = new CosXmlServer(config, qCloudCredentialProvider);
      // .cssg-body-end
    }

    public void test0()
    {
      // .cssg-body-start: [get-service]
      try
      {
        GetServiceRequest request = new GetServiceRequest();
        //设置签名有效时长
        request.SetSign(TimeUtils.GetCurrentTime(TimeUnit.SECONDS), 600);
        //执行请求
        GetServiceResult result = cosXml.GetService(request);
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
      // .cssg-body-end
    }
    public void test1()
    {
      // .cssg-body-start: [put-bucket]
      try
      {
        string bucket = "{{{tempBucket}}}"; //格式：BucketName-APPID
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
      // .cssg-body-end
    }
    public void test2()
    {
      // .cssg-body-start: [head-bucket]
      try
      {
        string bucket = "{{{tempBucket}}}"; //格式：BucketName-APPID
        HeadBucketRequest request = new HeadBucketRequest(bucket);
        //设置签名有效时长
        request.SetSign(TimeUtils.GetCurrentTime(TimeUnit.SECONDS), 600);
        //执行请求
        HeadBucketResult result = cosXml.HeadBucket(request);
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
      // .cssg-body-end
    }
    public void test3()
    {
      // .cssg-body-start: [delete-bucket]
      try
      {
        string bucket = "{{{tempBucket}}}"; //格式：BucketName-APPID
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
      // .cssg-body-end
    }
    public void test4()
    {
      // .cssg-body-start: [put-bucket-acl]
      try
      {
        string bucket = "{{{tempBucket}}}"; //格式：BucketName-APPID
        PutBucketACLRequest request = new PutBucketACLRequest(bucket);
        //设置签名有效时长
        request.SetSign(TimeUtils.GetCurrentTime(TimeUnit.SECONDS), 600);
        //设置私有读写权限
        request.SetCosACL(CosACL.PRIVATE);
        //授予1131975903账号读权限
        COSXML.Model.Tag.GrantAccount readAccount = new COSXML.Model.Tag.GrantAccount();
        readAccount.AddGrantAccount("1131975903", "1131975903");
        request.SetXCosGrantRead(readAccount);
        //执行请求
        PutBucketACLResult result = cosXml.PutBucketACL(request);
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
      // .cssg-body-end
    }
    public void test5()
    {
      // .cssg-body-start: [get-bucket-acl]
      try
      {
        string bucket = "{{{tempBucket}}}"; //格式：BucketName-APPID
        GetBucketACLRequest request = new GetBucketACLRequest(bucket);
        //设置签名有效时长
        request.SetSign(TimeUtils.GetCurrentTime(TimeUnit.SECONDS), 600);
        //执行请求
        GetBucketACLResult result = cosXml.GetBucketACL(request);
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
      // .cssg-body-end
    }
    public void test6()
    {
      // .cssg-body-start: [put-bucket-cors]
      try
      {
        string bucket = "{{{tempBucket}}}"; //格式：BucketName-APPID
        PutBucketCORSRequest request = new PutBucketCORSRequest(bucket);
        //设置签名有效时长
        request.SetSign(TimeUtils.GetCurrentTime(TimeUnit.SECONDS), 600);
        //设置跨域访问配置 CORS
        COSXML.Model.Tag.CORSConfiguration.CORSRule corsRule = 
          new COSXML.Model.Tag.CORSConfiguration.CORSRule();
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
      // .cssg-body-end
    }
    public void test7()
    {
      // .cssg-body-start: [get-bucket-cors]
      try
      {
        string bucket = "{{{tempBucket}}}"; //格式：BucketName-APPID
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
      }
      catch (COSXML.CosException.CosServerException serverEx)
      {
        //请求失败
        Console.WriteLine("CosServerException: " + serverEx.GetInfo());
      }
      // .cssg-body-end
    }
    public void test8()
    {
      // .cssg-body-start: [delete-bucket-cors]
      try
      {
        string bucket = "{{{tempBucket}}}"; //格式：BucketName-APPID
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
      // .cssg-body-end
    }
    public void test9()
    {
      // .cssg-body-start: [put-bucket-lifecycle]
      try
      {
        string bucket = "{{{tempBucket}}}"; //格式：BucketName-APPID
        PutBucketLifecycleRequest request = new PutBucketLifecycleRequest(bucket);
        //设置签名有效时长
        request.SetSign(TimeUtils.GetCurrentTime(TimeUnit.SECONDS), 600);
        //设置 lifecycle
        LifecycleConfiguration.Rule rule = new LifecycleConfiguration.Rule();
        rule.id = "lfiecycleConfigureId";
        rule.status = "Enabled"; //Enabled，Disabled

        rule.filter = new COSXML.Model.Tag.LifecycleConfiguration.Filter();
        rule.filter.prefix = "2/";

        //指定分片过期删除操作
        rule.abortIncompleteMultiUpload = new LifecycleConfiguration.AbortIncompleteMultiUpload();
        rule.abortIncompleteMultiUpload.daysAfterInitiation = 2;

        request.SetRule(rule);

        //执行请求
        PutBucketLifecycleResult result = cosXml.PutBucketLifecycle(request);
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
      // .cssg-body-end
    }
    public void test10()
    {
      // .cssg-body-start: [get-bucket-lifecycle]
      try
      {
        string bucket = "{{{tempBucket}}}"; //格式：BucketName-APPID
        GetBucketLifecycleRequest request = new GetBucketLifecycleRequest(bucket);
        //设置签名有效时长
        request.SetSign(TimeUtils.GetCurrentTime(TimeUnit.SECONDS), 600);
        //执行请求
        GetBucketLifecycleResult result = cosXml.GetBucketLifecycle(request);
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
      // .cssg-body-end
    }
    public void test11()
    {
      // .cssg-body-start: [delete-bucket-lifecycle]
      try
      {
        string bucket = "{{{tempBucket}}}"; //格式：BucketName-APPID
        DeleteBucketLifecycleRequest request = new DeleteBucketLifecycleRequest(bucket);
        //设置签名有效时长
        request.SetSign(TimeUtils.GetCurrentTime(TimeUnit.SECONDS), 600);
        //执行请求
        DeleteBucketLifecycleResult result = cosXml.DeleteBucketLifecycle(request);
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
      // .cssg-body-end
    }
    public void test12()
    {
      // .cssg-body-start: [put-bucket-versioning]
      string bucket = "{{{tempBucket}}}"; //格式：BucketName-APPID
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
      // .cssg-body-end
    }
    public void test13()
    {
      // .cssg-body-start: [get-bucket-versioning]
      string bucket = "{{{tempBucket}}}"; //格式：BucketName-APPID
      GetBucketVersioningRequest request = new GetBucketVersioningRequest(bucket);

      // 使用同步方法
      try
      {
        GetBucketVersioningResult result = cosXml.GetBucketVersioning(request);
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
      // .cssg-body-end
    }
    public void test14()
    {
      // .cssg-body-start: [put-bucket-replication]
      string bucket = "{{{tempBucket}}}"; //格式：BucketName-APPID
      string ownerUin = "{{uin}}"; //发起者身份标示: OwnerUin
      string subUin = "{{uin}}"; //发起者身份标示: SubUin
      PutBucketReplicationRequest request = new PutBucketReplicationRequest(bucket);
      //设置 replication
      PutBucketReplicationRequest.RuleStruct ruleStruct = 
        new PutBucketReplicationRequest.RuleStruct();
      ruleStruct.id = "replication_01"; //用来标注具体 Rule 的名称
      ruleStruct.isEnable = true; //标识 Rule 是否生效 :true, 生效； false, 不生效
      ruleStruct.appid = "{{appId}}"; //APPID
      ruleStruct.region = "{{replicationDestBucketRegion}}"; //目标存储桶地域信息
      ruleStruct.bucket = "{{{replicationDestBucket}}}"; //格式：BucketName-APPID
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
      // .cssg-body-end
    }
    public void test15()
    {
      // .cssg-body-start: [get-bucket-replication]
      string bucket = "{{{tempBucket}}}"; //格式：BucketName-APPID
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
      // .cssg-body-end
    }
    public void test16()
    {
      // .cssg-body-start: [delete-bucket-replication]
      string bucket = "{{{tempBucket}}}"; //格式：BucketName-APPID
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
      // .cssg-body-end
    }
    public void test17()
    {
      // .cssg-body-start: [get-bucket]
      try
      {
        string bucket = "{{{persistBucket}}}"; //格式：BucketName-APPID
        GetBucketRequest request = new GetBucketRequest(bucket);
        //设置签名有效时长
        request.SetSign(TimeUtils.GetCurrentTime(TimeUnit.SECONDS), 600);
        //获取 a/ 下的对象
        request.SetPrefix("a/");
        //执行请求
        GetBucketResult result = cosXml.GetBucket(request);
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
      // .cssg-body-end
    }
    public void test18()
    {
      // .cssg-body-start: [put-object]
      try
      {
        string bucket = "{{{persistBucket}}}"; //存储桶，格式：BucketName-APPID
        string key = "{{{object}}}"; //对象在存储桶中的位置，即称对象键
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
      // .cssg-body-end
    }
    public void test19()
    {
      // .cssg-body-start: [post-object]
      try
      {
        string bucket = "{{{persistBucket}}}"; //存储桶，格式：BucketName-APPID
        string key = "{{{object}}}"; //对象在存储桶中的位置，即称对象键
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
      // .cssg-body-end
    }
    public void test20()
    {
      // .cssg-body-start: [head-object]
      try
      {
        string bucket = "{{{persistBucket}}}"; //存储桶，格式：BucketName-APPID
        string key = "{{{object}}}"; //对象在存储桶中的位置，即称对象键
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
      // .cssg-body-end
    }
    public void test21()
    {
      // .cssg-body-start: [get-object]
      try
      {
        string bucket = "{{{persistBucket}}}"; //存储桶，格式：BucketName-APPID
        string key = "{{{object}}}"; //对象在存储桶中的位置，即称对象键
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
        string bucket = "{{{persistBucket}}}"; //存储桶，格式：BucketName-APPID
        string key = "{{{object}}}"; //对象在存储桶中的位置，即称对象键

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
      // .cssg-body-end
    }
    public void test22()
    {
      // .cssg-body-start: [copy-object]
      try
      {
        string sourceAppid = "{{appId}}"; //账号 appid
        string sourceBucket = "{{{copySourceBucket}}}"; //"源对象所在的存储桶
        string sourceRegion = "{{region}}"; //源对象的存储桶所在的地域
        string sourceKey = "{{copySourceObject}}"; //源对象键
        //构造源对象属性
        CopySourceStruct copySource = new CopySourceStruct(sourceAppid, sourceBucket, 
          sourceRegion, sourceKey);

        string bucket = "{{{persistBucket}}}"; //存储桶，格式：BucketName-APPID
        string key = "{{{object}}}"; //对象在存储桶中的位置，即称对象键
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
      // .cssg-body-end
    }
    public void test23()
    {
      // .cssg-body-start: [option-object]
      try
      {
        string bucket = "{{{tempBucket}}}"; //存储桶，格式：BucketName-APPID
        string key = "{{{object}}}"; //对象在存储桶中的位置，即称对象键
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
      }
      catch (COSXML.CosException.CosServerException serverEx)
      {
        //请求失败
        Console.WriteLine("CosServerException: " + serverEx.GetInfo());
      }
      // .cssg-body-end
    }
    public void test24()
    {
      // .cssg-body-start: [delete-object]
      try
      {
        string bucket = "{{{persistBucket}}}"; //存储桶，格式：BucketName-APPID
        string key = "{{{object}}}"; //对象在存储桶中的位置，即称对象键
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
      // .cssg-body-end
    }
    public void test25()
    {
      // .cssg-body-start: [delete-multi-object]
      try
      {
        string bucket = "{{{persistBucket}}}"; //存储桶，格式：BucketName-APPID
        DeleteMultiObjectRequest request = new DeleteMultiObjectRequest(bucket);
        //设置签名有效时长
        request.SetSign(TimeUtils.GetCurrentTime(TimeUnit.SECONDS), 600);
        //设置返回结果形式
        request.SetDeleteQuiet(false);
        //对象key
        string key = "{{{object}}}"; //对象在存储桶中的位置，即称对象键
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
      // .cssg-body-end
    }
    public void test26()
    {
      // .cssg-body-start: [list-multi-upload]
      try
      {
        string bucket = "{{{persistBucket}}}"; //格式：BucketName-APPID
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
      // .cssg-body-end
    }
    string uploadId;
    string etag;
    public void test27()
    {
      // .cssg-body-start: [init-multi-upload]
      try
      {
        string bucket = "{{{persistBucket}}}"; //存储桶，格式：BucketName-APPID
        string key = "{{{object}}}"; //对象在存储桶中的位置，即称对象键
        InitMultipartUploadRequest request = new InitMultipartUploadRequest(bucket, key);
        //设置签名有效时长
        request.SetSign(TimeUtils.GetCurrentTime(TimeUnit.SECONDS), 600);
        //执行请求
        InitMultipartUploadResult result = cosXml.InitMultipartUpload(request);
        //请求成功
        string uploadId = result.initMultipartUpload.uploadId; //用于后续分块上传的 uploadId
        this.uploadId = uploadId;
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
      // .cssg-body-end
    }
    public void test28()
    {
      // .cssg-body-start: [list-parts]
      try
      {
        string bucket = "{{{persistBucket}}}"; //存储桶，格式：BucketName-APPID
        string key = "{{{object}}}"; //对象在存储桶中的位置，即称对象键
        string uploadId = "{{{uploadId}}}"; //初始化分块上传返回的uploadId
        uploadId = this.uploadId;
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
      // .cssg-body-end
    }
    public void test29()
    {
      // .cssg-body-start: [upload-part]
      try
      {
        string bucket = "{{{persistBucket}}}"; //存储桶，格式：BucketName-APPID
        string key = "{{{object}}}"; //对象在存储桶中的位置，即称对象键
        string uploadId = "{{{uploadId}}}"; //初始化分块上传返回的uploadId
        int partNumber = 1; //分块编号，必须从1开始递增
        string srcPath = @"temp-source-file";//本地文件绝对路径
        uploadId = this.uploadId;
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
        this.etag = result.eTag;
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
      // .cssg-body-end
    }
    public void test30()
    {
      // .cssg-body-start: [upload-part-copy]
      try
      {
        string sourceAppid = "{{appId}}"; //账号 appid
        string sourceBucket = "{{{copySourceBucket}}}"; //"源对象所在的存储桶
        string sourceRegion = "{{region}}"; //源对象的存储桶所在的地域
        string sourceKey = "{{copySourceObject}}"; //源对象键
        //构造源对象属性
        COSXML.Model.Tag.CopySourceStruct copySource = new CopySourceStruct(sourceAppid, 
          sourceBucket, sourceRegion, sourceKey);

        string bucket = "{{{persistBucket}}}"; //存储桶，格式：BucketName-APPID
        string key = "{{{object}}}"; //对象在存储桶中的位置，即称对象键
        string uploadId = "{{{uploadId}}}"; //初始化分块上传返回的uploadId
        int partNumber = 1; //分块编号，必须从1开始递增
        uploadId = this.uploadId;
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
        this.etag = result.copyObject.eTag;
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
      // .cssg-body-end
    }
    public void test31()
    {
      // .cssg-body-start: [complete-multi-upload]
      try
      {
        string bucket = "{{{persistBucket}}}"; //存储桶，格式：BucketName-APPID
        string key = "{{{object}}}"; //对象在存储桶中的位置，即称对象键
        string uploadId = "{{{uploadId}}}"; //初始化分块上传返回的uploadId
        uploadId = this.uploadId;
        CompleteMultipartUploadRequest request = new CompleteMultipartUploadRequest(bucket, 
          key, uploadId);
        //设置签名有效时长
        request.SetSign(TimeUtils.GetCurrentTime(TimeUnit.SECONDS), 600);
        //设置已上传的parts,必须有序，按照partNumber递增
        // request.SetPartNumberAndETag(1, "Example Etag");
        string etag = "example etag";
        etag = this.etag;
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
      // .cssg-body-end
    }
    public void test32()
    {
      // .cssg-body-start: [abort-multi-upload]
      try
      {
        string bucket = "{{{persistBucket}}}"; //存储桶，格式：BucketName-APPID
        string key = "{{{object}}}"; //对象在存储桶中的位置，即称对象键
        string uploadId = "{{{uploadId}}}"; //初始化分块上传返回的uploadId
        uploadId = this.uploadId;
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
      // .cssg-body-end
    }
    public void test33()
    {
      // .cssg-body-start: [restore-object]
      try
      {
        string bucket = "{{{persistBucket}}}"; //存储桶，格式：BucketName-APPID
        string key = "{{{object}}}"; //对象在存储桶中的位置，即称对象键
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
      // .cssg-body-end
    }
    public void test34()
    {
      // .cssg-body-start: [put-object-acl]
      // 因为ACL+policy限制最多1000条，为避免acl达到上限，
      // 非必须情况不建议给对象单独设置ACL(对象默认继承bucket权限).
      try
      {
        string bucket = "{{{persistBucket}}}"; //存储桶，格式：BucketName-APPID
        string key = "{{{object}}}"; //对象在存储桶中的位置，即称对象键
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
      // .cssg-body-end
    }
    public void test35()
    {
      // .cssg-body-start: [get-object-acl]
      try
      {
        string bucket = "{{{persistBucket}}}"; //存储桶，格式：BucketName-APPID
        string key = "{{{object}}}"; //对象在存储桶中的位置，即称对象键
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
      // .cssg-body-end
    }
    public void test36()
    {
      // .cssg-body-start: [global-init]
      //初始化 CosXmlConfig 
      string appid = "{{appId}}";//设置腾讯云账户的账户标识 APPID
      string region = "{{region}}"; //设置一个默认的存储桶地域
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
      // .cssg-body-end
    }

    public void test44()
    {
      // .cssg-body-start: [get-presign-upload-url]
      try
      {
        PreSignatureStruct preSignatureStruct = new PreSignatureStruct();
        preSignatureStruct.appid = "{{appId}}";//腾讯云账号 APPID
        preSignatureStruct.region = "{{region}}"; //存储桶地域
        preSignatureStruct.bucket = "{{{persistBucket}}}"; //存储桶
        preSignatureStruct.key = "{{{object}}}"; //对象键
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
      // .cssg-body-end
    }
    public void test45()
    {
      // .cssg-body-start: [get-presign-download-url]
      try
      {
        PreSignatureStruct preSignatureStruct = new PreSignatureStruct();
        preSignatureStruct.appid = "{{appId}}";//腾讯云账号 APPID
        preSignatureStruct.region = "{{region}}"; //存储桶地域
        preSignatureStruct.bucket = "{{{persistBucket}}}"; //存储桶
        preSignatureStruct.key = "{{{object}}}"; //对象键
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
      // .cssg-body-end
    }
  }
}