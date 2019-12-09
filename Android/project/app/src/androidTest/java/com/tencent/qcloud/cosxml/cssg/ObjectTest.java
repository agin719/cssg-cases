package com.tencent.qcloud.cosxml.cssg;

import android.support.test.runner.AndroidJUnit4;
import android.support.test.InstrumentationRegistry;

import com.tencent.cos.xml.*;
import com.tencent.cos.xml.common.*;
import com.tencent.cos.xml.exception.*;
import com.tencent.cos.xml.listener.*;
import com.tencent.cos.xml.model.*;
import com.tencent.cos.xml.model.object.*;
import com.tencent.cos.xml.model.bucket.*;
import com.tencent.cos.xml.model.tag.*;
import com.tencent.cos.xml.transfer.*;
import com.tencent.qcloud.core.auth.*;
import com.tencent.qcloud.core.common.*;
import com.tencent.qcloud.core.http.*;
import com.tencent.cos.xml.model.service.*;
import com.tencent.qcloud.cosxml.cssg.GlobalInitCustomProviderTest.MyCredentialProvider;

import org.junit.Assert;
import org.junit.Test;
import org.junit.After;
import org.junit.Before;
import org.junit.runner.RunWith;

import android.content.Context;
import android.util.Log;

import java.net.*;
import java.util.*;
import java.nio.charset.Charset;
import java.io.*;

@RunWith(AndroidJUnit4.class)
public class ObjectTest {

    private Context context;
    private CosXmlService cosXmlService;

    private static void assertError(Exception e, boolean isMatch) {
        if (!isMatch) {
            throw new RuntimeException(e.getMessage());
        }
    }

    private static void assertError(Exception e) {
        assertError(e, false);
    }

    public ObjectTest() {
        super();
        context = InstrumentationRegistry.getInstrumentation().getTargetContext();
    }


    private void PutBucket()
    {
        String bucket = "bucket-cssg-test-android-1253653367";
        PutBucketRequest putBucketRequest = new PutBucketRequest(bucket);
        
        // 定义存储桶的 ACL 属性。有效值：private，public-read-write，public-read；默认值：private
        putBucketRequest.setXCOSACL("private");
        
        // 赋予被授权者读的权限
        ACLAccount readACLS = new ACLAccount();
        readACLS.addAccount("1278687956", "1278687956");
        putBucketRequest.setXCOSGrantRead(readACLS);
        
        // 赋予被授权者写的权限
        ACLAccount writeACLS = new ACLAccount();
        writeACLS.addAccount("1278687956", "1278687956");
        putBucketRequest.setXCOSGrantRead(writeACLS);
        
        // 赋予被授权者读写的权限
        ACLAccount writeandReadACLS = new ACLAccount();
        writeandReadACLS.addAccount("1278687956", "1278687956");
        putBucketRequest.setXCOSGrantRead(writeandReadACLS);
        // 设置签名校验 Host，默认校验所有 Header
        Set<String> headerKeys = new HashSet<>();
        headerKeys.add("Host");
        putBucketRequest.setSignParamsAndHeaders(null, headerKeys);
        // 使用同步方法
        try {
            PutBucketResult putBucketResult = cosXmlService.putBucket(putBucketRequest);
        } catch (CosXmlClientException e) {
            e.printStackTrace();
        } catch (CosXmlServiceException e) {
            e.printStackTrace();
        }
        
        if (true) {return;}
        // 使用异步回调请求
        cosXmlService.putBucketAsync(putBucketRequest, new CosXmlResultListener() {
            @Override
            public void onSuccess(CosXmlRequest request, CosXmlResult result) {
                // todo Put Bucket success
                PutBucketResult putBucketResult = (PutBucketResult)result;
            }
        
            @Override
            public void onFail(CosXmlRequest cosXmlRequest, CosXmlClientException clientException, CosXmlServiceException serviceException)  {
                // todo Put Bucket failed because of CosXmlClientException or CosXmlServiceException...
            }
        });
        
    }
    private void PutObject()
    {
        String bucket = "bucket-cssg-test-android-1253653367"; //存储桶，格式：BucketName-APPID
        String cosPath = "object4android"; //对象位于存储桶中的位置标识符，即对象键。例如 cosPath = "text.txt";
        String srcPath = new File(context.getExternalCacheDir(), "object4android").toString();//"本地文件的绝对路径";
        PutObjectRequest putObjectRequest = new PutObjectRequest(bucket, cosPath, srcPath);
        
        putObjectRequest.setProgressListener(new CosXmlProgressListener() {
            @Override
            public void onProgress(long progress, long max) {
                // todo Do something to update progress...
            }
        });
        // 设置签名校验 Host，默认校验所有 Header
        Set<String> headerKeys = new HashSet<>();
        headerKeys.add("Host");
        putObjectRequest.setSignParamsAndHeaders(null, headerKeys);
        // 使用同步方法上传
        try {
            PutObjectResult putObjectResult = cosXmlService.putObject(putObjectRequest);
        } catch (CosXmlClientException e) {
            e.printStackTrace();
            assertError(e);
        } catch (CosXmlServiceException e) {
            e.printStackTrace();
            assertError(e);
        }
        
        // 使用异步回调上传
        cosXmlService.putObjectAsync(putObjectRequest, new CosXmlResultListener() {
            @Override
            public void onSuccess(CosXmlRequest cosXmlRequest, CosXmlResult result) {
                // todo Put object success...
          PutObjectResult putObjectResult = (PutObjectResult)result;
            }
        
            @Override
            public void onFail(CosXmlRequest cosXmlRequest, CosXmlClientException clientException, CosXmlServiceException serviceException)  {
                // todo Put object failed because of CosXmlClientException or CosXmlServiceException...
            }
        });
        
        
        // 上传字节数组
        byte[] data = "this is a test".getBytes(Charset.forName("UTF-8"));
        putObjectRequest = new PutObjectRequest(bucket, cosPath, data);
        putObjectRequest.setProgressListener(new CosXmlProgressListener() {
            @Override
            public void onProgress(long progress, long max) {
                // todo Do something to update progress...
            }
        });
        try {
            PutObjectResult putObjectResult = cosXmlService.putObject(putObjectRequest);
        } catch (CosXmlClientException e) {
            e.printStackTrace();
            assertError(e);
        } catch (CosXmlServiceException e) {
            e.printStackTrace();
            assertError(e);
        }
        
        
        // 上传字节流
        InputStream inputStream = new ByteArrayInputStream("this is a test".getBytes(Charset.forName("UTF-8")));
        putObjectRequest = new PutObjectRequest(bucket, cosPath, inputStream);
        putObjectRequest.setProgressListener(new CosXmlProgressListener() {
            @Override
            public void onProgress(long progress, long max) {
                // todo Do something to update progress...
            }
        });
        try {
            PutObjectResult putObjectResult = cosXmlService.putObject(putObjectRequest);
        } catch (CosXmlClientException e) {
            e.printStackTrace();
            assertError(e);
        } catch (CosXmlServiceException e) {
            e.printStackTrace();
            assertError(e);
        }
        
        
    }
    private void PutObjectAcl()
    {
        String bucket = "bucket-cssg-test-android-1253653367"; //格式：BucketName-APPID
        String cosPath = "object4android"; //对象在存储桶中的位置标识符，即对象键。 例如 cosPath = "text.txt";
        PutObjectACLRequest putObjectACLRequest = new PutObjectACLRequest(bucket, cosPath);
        
        // 设置 bucket 访问权限
        putObjectACLRequest.setXCOSACL("public-read");
        
        // 赋予被授权者读的权限
        ACLAccount readACLS = new ACLAccount();
        readACLS.addAccount("1278687956", "1278687956");
        putObjectACLRequest.setXCOSGrantRead(readACLS);
        
        // 赋予被授权者读写的权限
        ACLAccount writeandReadACLS = new ACLAccount();
        writeandReadACLS.addAccount("1278687956", "1278687956");
        putObjectACLRequest.setXCOSGrantRead(writeandReadACLS);
        // 设置签名校验 Host，默认校验所有 Header
        Set<String> headerKeys = new HashSet<>();
        headerKeys.add("Host");
        putObjectACLRequest.setSignParamsAndHeaders(null, headerKeys);
        // 使用同步方法
        try {
            PutObjectACLResult putObjectACLResult = cosXmlService.putObjectACL(putObjectACLRequest);
        } catch (CosXmlClientException e) {
            e.printStackTrace();
            assertError(e);
        } catch (CosXmlServiceException e) {
            e.printStackTrace();
            assertError(e);
        }
        
        if (true) {return;}
        // 使用异步回调请求
        cosXmlService.putObjectACLAsync(putObjectACLRequest, new CosXmlResultListener() {
            @Override
            public void onSuccess(CosXmlRequest request, CosXmlResult result) {
                // todo Put Bucket ACL success
          PutObjectACLResult putObjectACLResult = (PutObjectACLResult)result;
            }
        
            @Override
            public void onFail(CosXmlRequest cosXmlRequest, CosXmlClientException clientException, CosXmlServiceException serviceException)  {
                // todo Put Bucket ACL failed because of CosXmlClientException or CosXmlServiceException...
            }
        });
        
        
    }
    private void GetObjectAcl()
    {
        String bucket = "bucket-cssg-test-android-1253653367"; //格式：BucketName-APPID
        String cosPath = "object4android"; //对象在存储桶中的位置标识符，即对象键。 例如 cosPath = "text.txt";
        GetObjectACLRequest getBucketACLRequest = new GetObjectACLRequest(bucket, cosPath);
        // 设置签名校验 Host，默认校验所有 Header
        Set<String> headerKeys = new HashSet<>();
        headerKeys.add("Host");
        getBucketACLRequest.setSignParamsAndHeaders(null, headerKeys);
        // 使用同步方法
        try {
            GetObjectACLResult getObjectACLResult = cosXmlService.getObjectACL(getBucketACLRequest);
        } catch (CosXmlClientException e) {
            e.printStackTrace();
            assertError(e);
        } catch (CosXmlServiceException e) {
            e.printStackTrace();
            assertError(e);
        }
        
        if (true) {return;}
        // 使用异步回调请求
        cosXmlService.getObjectACLAsync(getBucketACLRequest, new CosXmlResultListener() {
            @Override
            public void onSuccess(CosXmlRequest request, CosXmlResult result) {
                // todo Get Bucket ACL success
          GetObjectACLResult getObjectACLResult = (GetObjectACLResult)result;
            }
        
            @Override
            public void onFail(CosXmlRequest cosXmlRequest, CosXmlClientException clientException, CosXmlServiceException serviceException)  {
                // todo Get Bucket ACL failed because of CosXmlClientException or CosXmlServiceException...
            }
        });
        
        
    }
    private void HeadObject()
    {
        String bucket = bucket = "bucket-cssg-test-android-1253653367"; //存储桶名称，格式：BucketName-APPID
        String cosPath = "object4android"; //对象位于存储桶中的位置标识符，即对象键
        HeadObjectRequest headObjectRequest = new HeadObjectRequest(bucket, cosPath);
        // 设置签名校验 Host，默认校验所有 Header
        Set<String> headerKeys = new HashSet<>();
        headerKeys.add("Host");
        headObjectRequest.setSignParamsAndHeaders(null, headerKeys);
        // 使用同步方法
        try {
            HeadObjectResult headObjectResult = cosXmlService.headObject(headObjectRequest);
        } catch (CosXmlClientException e) {
            e.printStackTrace();
            assertError(e);
        } catch (CosXmlServiceException e) {
            e.printStackTrace();
            assertError(e);
        }
        
        if (true) {return;}
        // 使用异步回调请求
        cosXmlService.headObjectAsync(headObjectRequest, new CosXmlResultListener() {
            @Override
            public void onSuccess(CosXmlRequest request, CosXmlResult result) {
                // todo Head Bucket success
          HeadObjectResult headObjectResult  = (HeadObjectResult)result;
            }
        
            @Override
            public void onFail(CosXmlRequest cosXmlRequest, CosXmlClientException clientException, CosXmlServiceException serviceException)  {
                // todo Head Bucket failed because of CosXmlClientException or CosXmlServiceException...
            }
        });
        
        
    }
    private void GetObject()
    {
        String bucket = "bucket-cssg-test-android-1253653367"; //存储桶名称，格式：BucketName-APPID
        String cosPath = "object4android"; //对象位于存储桶中的位置标识符，即对象键
        String savePath = context.getExternalCacheDir().toString(); //本地路径
        
        GetObjectRequest getObjectRequest = new GetObjectRequest(bucket, cosPath, savePath);
        getObjectRequest.setProgressListener(new CosXmlProgressListener() {
            @Override
            public void onProgress(long progress, long max) {
                // todo Do something to update progress...
            }
        });
        // 设置签名校验 Host，默认校验所有 Header
        Set<String> headerKeys = new HashSet<>();
        headerKeys.add("Host");
        getObjectRequest.setSignParamsAndHeaders(null, headerKeys);
        // 使用同步方法下载
        try {
            GetObjectResult getObjectResult =cosXmlService.getObject(getObjectRequest);
        } catch (CosXmlClientException e) {
            e.printStackTrace();
            assertError(e);
        } catch (CosXmlServiceException e) {
            e.printStackTrace();
            assertError(e);
        }
        
        if (true) {return;}
        // 使用异步回调请求
        cosXmlService.getObjectAsync(getObjectRequest, new CosXmlResultListener() {
            @Override
            public void onSuccess(CosXmlRequest cosXmlRequest, CosXmlResult cosXmlResult) {
                // todo Get Object success
          GetObjectResult getObjectResult  = (GetObjectResult)cosXmlResult;
            }
        
            @Override
            public void onFail(CosXmlRequest cosXmlRequest, CosXmlClientException clientException, CosXmlServiceException serviceException)  {
                // todo Get Object failed because of CosXmlClientException or CosXmlServiceException...
            }
        });
        
        
    }
    private void DeleteObject()
    {
        String bucket = "bucket-cssg-test-android-1253653367"; //存储桶名称，格式：BucketName-APPID
        String cosPath = "object4android"; //对象在存储桶中的位置标识符，即对象键
        
        DeleteObjectRequest deleteObjectRequest = new DeleteObjectRequest(bucket, cosPath);
        // 设置签名校验 Host，默认校验所有 Header
        Set<String> headerKeys = new HashSet<>();
        headerKeys.add("Host");
        deleteObjectRequest.setSignParamsAndHeaders(null, headerKeys);
        // 使用同步方法删除
        try {
            DeleteObjectResult deleteObjectResult = cosXmlService.deleteObject(deleteObjectRequest);
        } catch (CosXmlClientException e) {
            e.printStackTrace();
            assertError(e);
        } catch (CosXmlServiceException e) {
            e.printStackTrace();
            assertError(e);
        }
        
        if (true) {return;}
        // 使用异步回调请求
        cosXmlService.deleteObjectAsync(deleteObjectRequest, new CosXmlResultListener() {
            @Override
            public void onSuccess(CosXmlRequest cosXmlRequest, CosXmlResult result) {
                // todo Delete Object success...
          DeleteObjectResult deleteObjectResult  = (DeleteObjectResult)result;
            }
        
            @Override
            public void onFail(CosXmlRequest cosXmlRequest, CosXmlClientException clientException, CosXmlServiceException serviceException)  {
                // todo Delete Object failed because of CosXmlClientException or CosXmlServiceException...
            }
        });
        
    }
    private void DeleteMultiObject()
    {
        String bucket = "bucket-cssg-test-android-1253653367"; //存储桶，格式：BucketName-APPID
        List<String> objectList = new ArrayList<String>();
        objectList.add("object4android"); //对象在存储桶中的位置标识符，即对象键
        
        DeleteMultiObjectRequest deleteMultiObjectRequest = new DeleteMultiObjectRequest(bucket, objectList);
        deleteMultiObjectRequest.setQuiet(true);
        // 设置签名校验 Host，默认校验所有 Header
        Set<String> headerKeys = new HashSet<>();
        headerKeys.add("Host");
        deleteMultiObjectRequest.setSignParamsAndHeaders(null, headerKeys);
        // 使用同步方法删除
        try {
             DeleteMultiObjectResult deleteMultiObjectResult =cosXmlService.deleteMultiObject(deleteMultiObjectRequest);
        } catch (CosXmlClientException e) {
            e.printStackTrace();
            assertError(e);
        } catch (CosXmlServiceException e) {
            e.printStackTrace();
            assertError(e);
        }
        
        if (true) {return;}
        // 使用异步回调请求
        cosXmlService.deleteMultiObjectAsync(deleteMultiObjectRequest, new CosXmlResultListener() {
            @Override
            public void onSuccess(CosXmlRequest cosXmlRequest, CosXmlResult result) {
                // Delete Multi Object success...
          DeleteMultiObjectResult deleteMultiObjectResult  = (DeleteMultiObjectResult)result;
            }
        
            @Override
            public void onFail(CosXmlRequest cosXmlRequest, CosXmlClientException clientException, CosXmlServiceException serviceException)  {
                //  Delete Multi Object failed because of CosXmlClientException or CosXmlServiceException...
            }
        });
        
        
    }
    private void PostObject()
    {
        String bucket = "bucket-cssg-test-android-1253653367"; //存储桶名称，格式：BucketName-APPID
        String cosPath = "object4android"; //对象位于存储桶中的位置标识符，即对象键。例如 cosPath = "text.txt";
        String srcPath = new File(context.getExternalCacheDir(), "object4android").toString();//"本地文件的绝对路径";
        
        PostObjectRequest postObjectRequest = new PostObjectRequest(bucket, cosPath, srcPath);
        
        postObjectRequest.setProgressListener(new CosXmlProgressListener() {
            @Override
            public void onProgress(long progress, long max) {
                // todo Do something to update progress...
            }
        });
        // 设置签名校验 Host，默认校验所有 Header
        Set<String> headerKeys = new HashSet<>();
        headerKeys.add("Host");
        postObjectRequest.setSignParamsAndHeaders(null, headerKeys);
        // 使用同步方法上传
        try {
            PostObjectResult postObjectResult = cosXmlService.postObject(postObjectRequest);
        } catch (CosXmlClientException e) {
            e.printStackTrace();
            assertError(e);
        } catch (CosXmlServiceException e) {
            e.printStackTrace();
            assertError(e);
        }
        
        // 使用异步回调上传
        cosXmlService.postObjectAsync(postObjectRequest, new CosXmlResultListener() {
            @Override
            public void onSuccess(CosXmlRequest cosXmlRequest, CosXmlResult result) {
                // todo Put object success...
          PutObjectResult putObjectResult = (PutObjectResult)result;
            }
        
            @Override
            public void onFail(CosXmlRequest cosXmlRequest, CosXmlClientException clientException, CosXmlServiceException serviceException)  {
                // todo Put object failed because of CosXmlClientException or CosXmlServiceException...
            }
        });
        
        
    }
    private void RestoreObject()
    {
        String bucket = "bucket-cssg-test-android-1253653367"; //格式：BucketName-APPID
        String cosPath = "object4android"; //对象在存储桶中的位置标识符，即对象键。 例如 cosPath = "text.txt";
        RestoreRequest restoreRequest = new RestoreRequest(bucket, cosPath);
        restoreRequest.setExpireDays(5); // 保留5天
        restoreRequest.setTier(RestoreConfigure.Tier.Standard); // 标准恢复模式
        // 设置签名校验 Host，默认校验所有 Header
        Set<String> headerKeys = new HashSet<>();
        headerKeys.add("Host");
        restoreRequest.setSignParamsAndHeaders(null, headerKeys);
        // 使用同步方法
        try {
            RestoreResult restoreResult = cosXmlService.restoreObject(restoreRequest);
        } catch (CosXmlClientException e) {
            e.printStackTrace();
        } catch (CosXmlServiceException e) {
            e.printStackTrace();
        }
        
        if (true) {return;}
        // 使用异步回调请求
        cosXmlService.restoreObjectAsync(restoreRequest, new CosXmlResultListener() {
            @Override
            public void onSuccess(CosXmlRequest request, CosXmlResult result) {
                // todo Get Bucket ACL success
          RestoreResult restoreResult = (RestoreResult)result;
            }
        
            @Override
            public void onFail(CosXmlRequest cosXmlRequest, CosXmlClientException clientException, CosXmlServiceException serviceException)  {
                // todo Get Bucket ACL failed because of CosXmlClientException or CosXmlServiceException...
            }
        });
        
        
    }
    private void GetPresignDownloadUrl()
    {
        try {
            String bucket = "bucket-cssg-test-android-1253653367"; //存储桶名称
            String cosPath = "object4android"; //即对象在存储桶中的位置标识符。例如 cosPath = "text.txt";
            String method = "GET"; //请求 HTTP 方法.
            PresignedUrlRequest presignedUrlRequest = new PresignedUrlRequest(bucket, cosPath);
            presignedUrlRequest.setRequestMethod(method);
        
            String urlWithSign = cosXmlService.getPresignedURL(presignedUrlRequest); //上传预签名 URL (使用永久密钥方式计算的签名 URL )
        
            //String urlWithSign = cosXmlService.getPresignedURL(getObjectRequest)； //直接使用 GetObjectRequest
        
            String savePath = context.getExternalCacheDir().toString(); //本地路径
            String saveFileName = "object4android"; //本地文件名
            GetObjectRequest getObjectRequest = new GetObjectRequest("bucket-cssg-test-android-1253653367", "object4android", savePath, saveFileName);
        
            // 设置上传请求预签名 URL
            getObjectRequest.setRequestURL(urlWithSign);
            // 设置进度回调
            getObjectRequest.setProgressListener(new CosXmlProgressListener() {
                    @Override
                    public void onProgress(long progress, long max) {
                            // todo Do something to update progress...
                    }
            });
                 // 使用同步方法下载
            GetObjectResult getObjectResult =cosXmlService.getObject(getObjectRequest);
        
        } catch (CosXmlClientException e) {
            e.printStackTrace();
            assertError(e);
        } catch (CosXmlServiceException e) {
            e.printStackTrace();
            assertError(e);
        }
        
        
    }
    private void GetPresignUploadUrl()
    {
        try {
        
         String bucket = "bucket-cssg-test-android-1253653367"; //存储桶名称
         String cosPath = "object4android"; //即对象在存储桶中的位置标识符。例如 cosPath = "text.txt";
         String method = "PUT"; //请求 HTTP 方法
         PresignedUrlRequest presignedUrlRequest = new PresignedUrlRequest(bucket, cosPath){
             @Override
                public RequestBodySerializer getRequestBody() throws CosXmlClientException {
                    //用于计算 put 等需要带上 body 的请求的签名 URL
                    return RequestBodySerializer.string("text/plain", "this is test");
                 }
            };
         presignedUrlRequest.setRequestMethod(method);
        
         String urlWithSign = cosXmlService.getPresignedURL(presignedUrlRequest); //上传预签名 URL (使用永久密钥方式计算的签名 URL )
        
         //String urlWithSign = cosXmlService.getPresignedURL(putObjectRequest)； //直接使用PutObjectRequest
        
         String srcPath = new File(context.getExternalCacheDir(), "object4android").toString();
         PutObjectRequest putObjectRequest = new PutObjectRequest("bucket-cssg-test-android-1253653367", "object4android", srcPath);
         //设置上传请求预签名 URL
         putObjectRequest.setRequestURL(urlWithSign);
         //设置进度回调
         putObjectRequest.setProgressListener(new CosXmlProgressListener() {
             @Override
             public void onProgress(long progress, long max) {
                 // todo Do something to update progress...
             }
         });
         // 使用同步方法上传
         PutObjectResult putObjectResult = cosXmlService.putObject(putObjectRequest);
        } catch (CosXmlClientException e) {
         e.printStackTrace();
         assertError(e);
        } catch (CosXmlServiceException e) {
         e.printStackTrace();
         assertError(e);
        }
        
        
    }
    private void DeleteBucket()
    {
        String bucket = "bucket-cssg-test-android-1253653367"; //格式：BucketName-APPID
        DeleteBucketRequest deleteBucketRequest = new DeleteBucketRequest(bucket);
        // 设置签名校验 Host，默认校验所有 Header
        Set<String> headerKeys = new HashSet<>();
        headerKeys.add("Host");
        deleteBucketRequest.setSignParamsAndHeaders(null, headerKeys);
        // 使用同步方法
        try {
            DeleteBucketResult deleteBucketResult = cosXmlService.deleteBucket(deleteBucketRequest);
        } catch (CosXmlClientException e) {
            e.printStackTrace();
        } catch (CosXmlServiceException e) {
            e.printStackTrace();
        }
        
        if (true) {return;}
        // 使用异步回调请求
        cosXmlService.deleteBucketAsync(deleteBucketRequest, new CosXmlResultListener() {
            @Override
            public void onSuccess(CosXmlRequest request, CosXmlResult result) {
                // todo Delete Bucket success
          DeleteBucketResult deleteBucketResult = (DeleteBucketResult)result;
            }
        
            @Override
            public void onFail(CosXmlRequest cosXmlRequest, CosXmlClientException clientException, CosXmlServiceException serviceException)  {
                // todo Delete Bucket failed because of CosXmlClientException or CosXmlServiceException...
            }
        });
        
    }

    private void initService() {
        String region = "ap-guangzhou";
        
        // 创建 CosXmlServiceConfig 对象，根据需要修改默认的配置参数
        CosXmlServiceConfig serviceConfig = new CosXmlServiceConfig.Builder()
                .setRegion(region)
                .isHttps(true) // 使用 HTTPS 请求, 默认为 HTTP 请求
                .builder();
        
        String secretId = BuildConfig.COS_SECRET_ID; //永久密钥 secretId
        String secretKey =BuildConfig.COS_SECRET_KEY; //永久密钥 secretKey
        
        /**
         * 初始化 {@link QCloudCredentialProvider} 对象，来给 SDK 提供临时密钥
         * @parma secretId 永久密钥 secretId
         * @param secretKey 永久密钥 secretKey
         * @param keyDuration 密钥有效期，单位为秒
         */
        QCloudCredentialProvider credentialProvider = new ShortTimeCredentialProvider(secretId, secretKey, 300);
        
        CosXmlService cosXmlService = new CosXmlService(context, serviceConfig, credentialProvider);
        
        this.cosXmlService = cosXmlService;

        try {
            File srcFile = new File(context.getExternalCacheDir(), "object4android");
            if (!srcFile.exists() && srcFile.createNewFile()) {
                RandomAccessFile raf = new RandomAccessFile(srcFile, "rw");
                raf.setLength(1024);
                raf.close();
            }
        } catch (IOException e) {
            e.printStackTrace();
        }

    }

    @Before public void setUp() {
        initService();
        PutBucket();
    }

    @After public void tearDown() {
        DeleteObject();
        DeleteBucket();
    }

    @Test public void testObject() {
        PutObject();
        PutObjectAcl();
        GetObjectAcl();
        HeadObject();
        GetObject();
        DeleteObject();
        DeleteMultiObject();
        PostObject();
        RestoreObject();
        GetPresignDownloadUrl();
        GetPresignUploadUrl();
    }
}
