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
import com.tencent.qcloud.cosxml.cssg.InitCustomProviderTest.MyCredentialProvider;

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

    private String uploadId;
    private String eTag;

    private void putBucket()
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
    private void deleteObject()
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
    private void deleteBucket()
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
    private void putObject()
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
    private void putObjectAcl()
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
    private void getObjectAcl()
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
    private void headObject()
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
    private void getObject()
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
    private void getPresignDownloadUrl()
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
    private void getPresignUploadUrl()
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
    private void deleteMultiObject()
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
    private void postObject()
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
    private void restoreObject()
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
    private void initMultiUpload()
    {
        String bucket = "bucket-cssg-test-android-1253653367"; //格式：BucketName-APPID
        String cosPath = "object4android"; //对象在存储桶中的位置标识符，即对象键。 例如 cosPath = "text.txt";
        
        InitMultipartUploadRequest initMultipartUploadRequest = new InitMultipartUploadRequest(bucket, cosPath);
        // 设置签名校验 Host，默认校验所有 Header
        Set<String> headerKeys = new HashSet<>();
        headerKeys.add("Host");
        initMultipartUploadRequest.setSignParamsAndHeaders(null, headerKeys);
        // 使用同步方法请求
        try {
            InitMultipartUploadResult initMultipartUploadResult = cosXmlService.initMultipartUpload(initMultipartUploadRequest);
            uploadId =initMultipartUploadResult.initMultipartUpload.uploadId;
        } catch (CosXmlClientException e) {
            e.printStackTrace();
            assertError(e);
        } catch (CosXmlServiceException e) {
            e.printStackTrace();
            assertError(e);
        }
        
        if (true) {return;}
        // 使用异步回调请求
        cosXmlService.initMultipartUploadAsync(initMultipartUploadRequest, new CosXmlResultListener() {
            @Override
            public void onSuccess(CosXmlRequest cosXmlRequest, CosXmlResult result) {
                String uploadId = ((InitMultipartUploadResult)result).initMultipartUpload.uploadId;
            }
        
            @Override
            public void onFail(CosXmlRequest cosXmlRequest, CosXmlClientException clientException, CosXmlServiceException serviceException)  {
                // todo Init Multipart Upload failed because of CosXmlClientException or CosXmlServiceException...
            }
        });
        
        
    }
    private void listMultiUpload()
    {
        String bucket = "bucket-cssg-test-android-1253653367"; //格式：BucketName-APPID
        ListMultiUploadsRequest listMultiUploadsRequest = new ListMultiUploadsRequest(bucket);
        // 设置签名校验 Host，默认校验所有 Header
        Set<String> headerKeys = new HashSet<>();
        headerKeys.add("Host");
        listMultiUploadsRequest.setSignParamsAndHeaders(null, headerKeys);
        try {
         // 使用同步方法
            ListMultiUploadsResult listMultiUploadsResult = cosXmlService.listMultiUploads(listMultiUploadsRequest);
        } catch (CosXmlClientException e) {
            e.printStackTrace();
            assertError(e);
        } catch (CosXmlServiceException e) {
            e.printStackTrace();
            assertError(e);
        }
        
        if (true) {return;}
        // 使用异步回调请求
        cosXmlService.listMultiUploadsAsync(listMultiUploadsRequest, new CosXmlResultListener() {
            @Override
            public void onSuccess(CosXmlRequest cosXmlRequest, CosXmlResult result) {
                // Delete Multi Object success...
          ListMultiUploadsResult listMultiUploadsResult  = (ListMultiUploadsResult)result;
            }
        
            @Override
            public void onFail(CosXmlRequest cosXmlRequest, CosXmlClientException clientException, CosXmlServiceException serviceException)  {
                //  Delete Multi Object failed because of CosXmlClientException or CosXmlServiceException...
            }
        });
        
        
    }
    private void uploadPart()
    {
        String bucket = "bucket-cssg-test-android-1253653367"; //存储桶，格式：BucketName-APPID
        String cosPath = "object4android"; //对象在存储桶中的位置标识符，即对象键
        String uploadId =this.uploadId; //初始化分块上传返回的 uploadId
        int partNumber = 1; //分块块编号，必须从1开始递增
        String srcPath = new File(context.getExternalCacheDir(), "object4android").toString(); //本地文件绝对路径
        UploadPartRequest uploadPartRequest = new UploadPartRequest(bucket, cosPath, partNumber, srcPath, uploadId);
        
        uploadPartRequest.setProgressListener(new CosXmlProgressListener() {
            @Override
            public void onProgress(long progress, long max) {
                float result = (float) (progress * 100.0/max);
                Log.w("TEST","progress =" + (long)result + "%");
            }
        });
        // 设置签名校验 Host，默认校验所有 Header
        Set<String> headerKeys = new HashSet<>();
        headerKeys.add("Host");
        uploadPartRequest.setSignParamsAndHeaders(null, headerKeys);
        //使用同步方法上传
        try {
            UploadPartResult uploadPartResult = cosXmlService.uploadPart(uploadPartRequest);
            eTag = uploadPartResult.eTag; //获取分块块的 eTag
        } catch (CosXmlClientException e) {
            e.printStackTrace();
            assertError(e);
        } catch (CosXmlServiceException e) {
            e.printStackTrace();
            assertError(e);
        }
        
        
        if (true) {return;}
        // 使用异步回调请求
        cosXmlService.uploadPartAsync(uploadPartRequest, new CosXmlResultListener() {
            @Override
            public void onSuccess(CosXmlRequest cosXmlRequest, CosXmlResult result) {
                String eTag =((UploadPartResult)result).eTag;
            }
        
            @Override
            public void onFail(CosXmlRequest cosXmlRequest, CosXmlClientException clientException, CosXmlServiceException serviceException)  {
                // todo Upload Part failed because of CosXmlClientException or CosXmlServiceException...
            }
        });
        
        
    }
    private void listParts()
    {
        String bucket = "bucket-cssg-test-android-1253653367"; //格式：BucketName-APPID
        String cosPath = "object4android"; //对象在存储桶中的位置标识符，即对象键。 例如 cosPath = "text.txt";
        String uploadId = this.uploadId;
        
        ListPartsRequest listPartsRequest = new ListPartsRequest(bucket, cosPath, uploadId);
        // 设置签名校验 Host，默认校验所有 Header
        Set<String> headerKeys = new HashSet<>();
        headerKeys.add("Host");
        listPartsRequest.setSignParamsAndHeaders(null, headerKeys);
        // 使用同步方法请求
        try {
            ListPartsResult listPartsResult = cosXmlService.listParts(listPartsRequest);
            ListParts listParts = listPartsResult.listParts;
        } catch (CosXmlClientException e) {
            e.printStackTrace();
            assertError(e);
        } catch (CosXmlServiceException e) {
            e.printStackTrace();
            assertError(e);
        }
        
        if (true) {return;}
        // 使用异步回调请求
        cosXmlService.listPartsAsync(listPartsRequest, new CosXmlResultListener() {
            @Override
            public void onSuccess(CosXmlRequest cosXmlRequest, CosXmlResult result) {
                ListParts listParts = ((ListPartsResult)result).listParts;
            }
        
            @Override
            public void onFail(CosXmlRequest cosXmlRequest, CosXmlClientException clientException, CosXmlServiceException serviceException)  {
                // todo List Part failed because of CosXmlClientException or CosXmlServiceException...
            }
        });
        
        
    }
    private void completeMultiUpload()
    {
        String bucket = "bucket-cssg-test-android-1253653367"; //格式：BucketName-APPID
        String cosPath = "object4android"; //对象在存储桶中的位置标识符，即对象键。 例如 cosPath = "text.txt";
        String uploadId = this.uploadId;
        int partNumber = 1;
        String etag = this.eTag;
        Map<Integer, String> partNumberAndETag = new HashMap<>();
        partNumberAndETag.put(partNumber, etag);
        
        CompleteMultiUploadRequest completeMultiUploadRequest = new CompleteMultiUploadRequest(bucket, cosPath, uploadId, partNumberAndETag);
        // 设置签名校验 Host，默认校验所有 Header
        Set<String> headerKeys = new HashSet<>();
        headerKeys.add("Host");
        completeMultiUploadRequest.setSignParamsAndHeaders(null, headerKeys);
        // 使用同步方法请求
        try {
            CompleteMultiUploadResult completeMultiUploadResult = cosXmlService.completeMultiUpload(completeMultiUploadRequest);
        } catch (CosXmlClientException e) {
            e.printStackTrace();
            assertError(e);
        } catch (CosXmlServiceException e) {
            e.printStackTrace();
            assertError(e);
        }
        
        if (true) {return;}
        // 使用异步回调请求
        cosXmlService.completeMultiUploadAsync(completeMultiUploadRequest, new CosXmlResultListener() {
            @Override
            public void onSuccess(CosXmlRequest cosXmlRequest, CosXmlResult result) {
                // todo Complete Multi Upload success...
          CompleteMultiUploadResult completeMultiUploadResult = (CompleteMultiUploadResult)result;
            }
        
            @Override
            public void onFail(CosXmlRequest cosXmlRequest, CosXmlClientException clientException, CosXmlServiceException serviceException)  {
                // todo Complete Multi Upload failed because of CosXmlClientException or CosXmlServiceException...
            }
        });
        
        
    }
    private void abortMultiUpload()
    {
        String bucket = "bucket-cssg-test-android-1253653367"; //格式：BucketName-APPID
        String cosPath = "object4android"; //对象在存储桶中的位置标识符，即对象键。 例如 cosPath = "text.txt";
        String uploadId = this.uploadId;
        
        AbortMultiUploadRequest abortMultiUploadRequest = new AbortMultiUploadRequest(bucket, cosPath, uploadId);
        // 设置签名校验 Host，默认校验所有 Header
        Set<String> headerKeys = new HashSet<>();
        headerKeys.add("Host");
        abortMultiUploadRequest.setSignParamsAndHeaders(null, headerKeys);
        // 使用同步方法请求
        try {
            AbortMultiUploadResult abortMultiUploadResult = cosXmlService.abortMultiUpload(abortMultiUploadRequest);
        } catch (CosXmlClientException e) {
            e.printStackTrace();
            assertError(e);
        } catch (CosXmlServiceException e) {
            e.printStackTrace();
            assertError(e);
            //
        }
        
        if (true) {return;}
        // 使用异步回调请求
        cosXmlService.abortMultiUploadAsync(abortMultiUploadRequest, new CosXmlResultListener() {
            @Override
            public void onSuccess(CosXmlRequest cosXmlRequest, CosXmlResult result) {
                // todo Abort Multi Upload success...
          AbortMultiUploadResult abortMultiUploadResult = (AbortMultiUploadResult)result;
            }
        
            @Override
            public void onFail(CosXmlRequest cosXmlRequest, CosXmlClientException clientException, CosXmlServiceException serviceException)  {
                // todo Abort Multi Upload failed because of CosXmlClientException or CosXmlServiceException...
            }
        });
        
        
    }
    private void transferUploadObject()
    {
        // 初始化 TransferConfig
        TransferConfig transferConfig = new TransferConfig.Builder().build();
        
        /*若有特殊要求，则可以如下进行初始化定制。例如限定当对象 >= 2M 时，启用分块上传，且分块上传的分块大小为1M，当源对象大于5M时启用分块复制，且分块复制的大小为5M。*/
        transferConfig = new TransferConfig.Builder()
                .setDividsionForCopy(5 * 1024 * 1024) // 是否启用分块复制的最小对象大小
                .setSliceSizeForCopy(5 * 1024 * 1024) // 分块复制时的分块大小
                .setDivisionForUpload(2 * 1024 * 1024) // 是否启用分块上传的最小对象大小
                .setSliceSizeForUpload(1024 * 1024) // 分块上传时的分块大小
                .build();
        
        // 初始化 TransferManager
        TransferManager transferManager = new TransferManager(cosXmlService, transferConfig);
        
        String bucket = "bucket-cssg-test-android-1253653367"; //存储桶，格式：BucketName-APPID
        String cosPath = "object4android"; //对象在存储桶中的位置标识符，即称对象键
        String srcPath = new File(context.getExternalCacheDir(), "object4android").toString(); //本地文件的绝对路径
        String uploadId = null; //若存在初始化分块上传的 UploadId，则赋值对应的 uploadId 值用于续传；否则，赋值 null
        // 上传对象
        COSXMLUploadTask cosxmlUploadTask = transferManager.upload(bucket, cosPath, srcPath, uploadId);
        
        /**
        * 若是上传字节数组，则可调用 TransferManager 的 upload(string, string, byte[]) 方法实现;
        * byte[] bytes = "this is a test".getBytes(Charset.forName("UTF-8"));
        * cosxmlUploadTask = transferManager.upload(bucket, cosPath, bytes);
        */
        
        /**
        * 若是上传字节流，则可调用 TransferManager 的 upload(String, String, InputStream) 方法实现；
        * InputStream inputStream = new ByteArrayInputStream("this is a test".getBytes(Charset.forName("UTF-8")));
        * cosxmlUploadTask = transferManager.upload(bucket, cosPath, inputStream);
        */
        
        //设置上传进度回调
        cosxmlUploadTask.setCosXmlProgressListener(new CosXmlProgressListener() {
                    @Override
                    public void onProgress(long complete, long target) {
                        float progress = 1.0f * complete / target * 100;
                        Log.d("TEST",  String.format("progress = %d%%", (int)progress));
                    }
                });
        //设置返回结果回调
        cosxmlUploadTask.setCosXmlResultListener(new CosXmlResultListener() {
                    @Override
                    public void onSuccess(CosXmlRequest request, CosXmlResult result) {
            COSXMLUploadTask.COSXMLUploadTaskResult cOSXMLUploadTaskResult = (COSXMLUploadTask.COSXMLUploadTaskResult)result;
                        Log.d("TEST",  "Success: " + cOSXMLUploadTaskResult.printResult());
                    }
        
                    @Override
                    public void onFail(CosXmlRequest request, CosXmlClientException exception, CosXmlServiceException serviceException) {
                        Log.d("TEST",  "Failed: " + (exception == null ? serviceException.getMessage() : exception.toString()));
                    }
                });
        //设置任务状态回调, 可以查看任务过程
        cosxmlUploadTask.setTransferStateListener(new TransferStateListener() {
                    @Override
                    public void onStateChanged(TransferState state) {
                        Log.d("TEST", "Task state:" + state.name());
                    }
                });
        
        /**
        若有特殊要求，则可以如下操作：
         PutObjectRequest putObjectRequest = new PutObjectRequest(bucket, cosPath, srcPath);
         putObjectRequest.setRegion(region); //设置存储桶所在的地域
         putObjectRequest.setNeedMD5(true); //是否启用 Md5 校验
         COSXMLUploadTask cosxmlUploadTask = transferManager.upload(putObjectRequest, uploadId);
        */
        
        //取消上传
        cosxmlUploadTask.cancel();
        
        
        //暂停上传
        cosxmlUploadTask.pause();
        
        //恢复上传
        cosxmlUploadTask.resume();
        
        
    }
    private void transferDownloadObject()
    {
        Context applicationContext = context.getApplicationContext(); // application context
        String bucket = "bucket-cssg-test-android-1253653367"; //存储桶，格式：BucketName-APPID
        String cosPath = "object4android"; //对象在存储桶中的位置标识符，即称对象键
        String savePathDir = context.getExternalCacheDir().toString(); //本地目录路径
        String savedFileName = "object4android";//本地保存的文件名，若不填（null），则与 COS 上的文件名一样
        //下载对象
        TransferConfig transferConfig = new TransferConfig.Builder().build();
        //初始化 TransferManager
        TransferManager transferManager = new TransferManager(cosXmlService, transferConfig);
        COSXMLDownloadTask cosxmlDownloadTask = transferManager.download(applicationContext, bucket, cosPath, savePathDir, savedFileName);
        //设置下载进度回调
        cosxmlDownloadTask.setCosXmlProgressListener(new CosXmlProgressListener() {
                    @Override
                    public void onProgress(long complete, long target) {
                        float progress = 1.0f * complete / target * 100;
                        Log.d("TEST",  String.format("progress = %d%%", (int)progress));
                    }
                });
        //设置返回结果回调
        cosxmlDownloadTask.setCosXmlResultListener(new CosXmlResultListener() {
                    @Override
                    public void onSuccess(CosXmlRequest request, CosXmlResult result) {
            COSXMLDownloadTask.COSXMLDownloadTaskResult cOSXMLDownloadTaskResult = (COSXMLDownloadTask.COSXMLDownloadTaskResult)result;
                        Log.d("TEST",  "Success: " + cOSXMLDownloadTaskResult.printResult());
                    }
        
                    @Override
                    public void onFail(CosXmlRequest request, CosXmlClientException exception, CosXmlServiceException serviceException) {
                        Log.d("TEST",  "Failed: " + (exception == null ? serviceException.getMessage() : exception.toString()));
                    }
                });
        //设置任务状态回调，可以查看任务过程
        cosxmlDownloadTask.setTransferStateListener(new TransferStateListener() {
                    @Override
                    public void onStateChanged(TransferState state) {
                        Log.d("TEST", "Task state:" + state.name());
                    }
                });
        
        /**
        若有特殊要求，则可以如下操作：
        GetObjectRequest getObjectRequest = new GetObjectRequest(bucket, cosPath, localDir, localFileName);
        getObjectRequest.setRegion(region); //设置存储桶所在的地域
        COSXMLDownloadTask cosxmlDownloadTask = transferManager.download(context, getObjectRequest);
        */
        
        //取消下载
        cosxmlDownloadTask.cancel();
        
        //暂停下载
        cosxmlDownloadTask.pause();
        
        //恢复下载
        cosxmlDownloadTask.resume();
        
    }
    private void transferCopyObject()
    {
        String sourceAppid = ""; //账号 APPID
        String sourceBucket = "bucket-cssg-source-1253653367"; //源对象所在的存储桶
        String sourceRegion = "ap-guangzhou"; //源对象的存储桶所在的地域
        String sourceCosPath = ""; //源对象的对象键
        //构造源对象属性
        CopyObjectRequest.CopySourceStruct copySourceStruct = new CopyObjectRequest.CopySourceStruct(sourceAppid, sourceBucket, sourceRegion, sourceCosPath);
        
        String bucket = "bucket-cssg-test-android-1253653367"; //存储桶，格式：BucketName-APPID
        String cosPath = "object4android"; //对象在存储桶中的位置标识符，即对象键
        
        TransferConfig transferConfig = new TransferConfig.Builder().build();
        //初始化 TransferManager
        TransferManager transferManager = new TransferManager(cosXmlService, transferConfig);
        //复制对象
        COSXMLCopyTask cosxmlCopyTask = transferManager.copy(bucket, cosPath, copySourceStruct);
        //设置返回结果回调
        cosxmlCopyTask.setCosXmlResultListener(new CosXmlResultListener() {
                    @Override
                    public void onSuccess(CosXmlRequest request, CosXmlResult result) {
            COSXMLCopyTask.COSXMLCopyTaskResult cOSXMLCopyTaskResult = (COSXMLCopyTask.COSXMLCopyTaskResult)result;
                        Log.d("TEST",  "Success: " + cOSXMLCopyTaskResult.printResult());
                    }
        
                    @Override
                    public void onFail(CosXmlRequest request, CosXmlClientException exception, CosXmlServiceException serviceException) {
                        Log.d("TEST",  "Failed: " + (exception == null ? serviceException.getMessage() : exception.toString()));
                    }
                });
        //设置任务状态回调, 可以查看任务过程
        cosxmlCopyTask.setTransferStateListener(new TransferStateListener() {
                    @Override
                    public void onStateChanged(TransferState state) {
                        Log.d("TEST", "Task state:" + state.name());
                    }
                });
        /**
        若有特殊要求，则可以如下操作：
        CopyObjectRequest copyObjectRequest = new CopyObjectRequest(bucket, cosPath, copySourceStruct);
        copyObjectRequest.setRegion(region); //设置存储桶所在的地域
        COSXMLCopyTask cosxmlCopyTask = transferManager.copy(copyObjectRequest);
        */
        
        //取消复制
        cosxmlCopyTask.cancel();
        
        
        //暂停复制
        cosxmlCopyTask.pause();
        
        //恢复复制
        cosxmlCopyTask.resume();
        
    }
    private void copyObject()
    {
        String sourceAppid = "1253653367"; //账号 APPID
        String sourceBucket = "bucket-cssg-source-1253653367"; //源对象所在的存储桶
        String sourceRegion = "ap-guangzhou"; //源对象的存储桶所在的地域
        String sourceCosPath = "sourceObject"; //源对象键
        // 构造源对象属性
        CopyObjectRequest.CopySourceStruct copySourceStruct = new CopyObjectRequest.CopySourceStruct(sourceAppid, sourceBucket, sourceRegion, sourceCosPath);
        String bucket = "bucket-cssg-test-android-1253653367"; //存储桶，格式：BucketName-APPID
        String cosPath = "object4android"; //对象在存储桶中的位置标识符，即对象键
        
        CopyObjectRequest copyObjectRequest = new CopyObjectRequest(bucket, cosPath, copySourceStruct);
        // 设置签名校验 Host，默认校验所有 Header
        Set<String> headerKeys = new HashSet<>();
        headerKeys.add("Host");
        copyObjectRequest.setSignParamsAndHeaders(null, headerKeys);
        // 使用同步方法
        try {
            CopyObjectResult copyObjectResult = cosXmlService.copyObject(copyObjectRequest);
        } catch (CosXmlClientException e) {
            e.printStackTrace();
            assertError(e);
        } catch (CosXmlServiceException e) {
            e.printStackTrace();
            assertError(e);
        }
        
        if (true) {return;}
        // 使用异步回调请求
        cosXmlService.copyObjectAsync(copyObjectRequest, new CosXmlResultListener() {
            @Override
            public void onSuccess(CosXmlRequest request, CosXmlResult result) {
                // todo Copy Object success
          CopyObjectResult copyObjectResult  = (CopyObjectResult)result;
            }
        
            @Override
            public void onFail(CosXmlRequest cosXmlRequest, CosXmlClientException clientException, CosXmlServiceException serviceException)  {
                // todo Copy Object failed because of CosXmlClientException or CosXmlServiceException...
            }
        });
        
        
    }
    private void uploadPartCopy()
    {
        //具体步骤：
        // 1. 调用 cosXmlService.initMultipartUpload(InitMultipartUploadRequest) 初始化分块,请参考 [InitMultipartUploadRequest 初始化分块](#InitMultipartUploadRequest)。
        // 2. 调用 cosXmlService.copyObject(UploadPartCopyRequest) 完成分块复制。
        // 3. 调用 cosXmlService.completeMultiUpload(CompleteMultiUploadRequest) 完成分块复制,请参考 [CompleteMultiUploadRequest 完成分块复制](#CompleteMultiUploadRequest)。
        
        String sourceAppid = "1253653367"; //账号 APPID
        String sourceBucket = "bucket-cssg-source-1253653367"; //源对象所在的存储桶
        String sourceRegion = "ap-guangzhou"; //源对象的存储桶所在的地域
        String sourceCosPath = "sourceObject"; //源对象键
        // 构造源对象属性
        CopyObjectRequest.CopySourceStruct copySourceStruct = new CopyObjectRequest.CopySourceStruct(sourceAppid, sourceBucket, sourceRegion, sourceCosPath);
        
        String bucket = "bucket-cssg-test-android-1253653367"; //存储桶，格式：BucketName-APPID
        String cosPath = "object4android"; //对象在存储桶中的位置标识符，即对象键
        
        String uploadId = this.uploadId;
        int partNumber = 1; //分块编号
        long start = 0; //复制源对象的开始位置
        long end = 1023; //复制源对象的结束位置
        
        UploadPartCopyRequest uploadPartCopyRequest = new UploadPartCopyRequest(bucket, cosPath, partNumber,  uploadId, copySourceStruct, start, end);
        // 设置签名校验 Host，默认校验所有 Header
        Set<String> headerKeys = new HashSet<>();
        headerKeys.add("Host");
        uploadPartCopyRequest.setSignParamsAndHeaders(null, headerKeys);
        // 使用同步方法
        try {
            UploadPartCopyResult uploadPartCopyResult = cosXmlService.copyObject(uploadPartCopyRequest);
            eTag = uploadPartCopyResult.copyObject.eTag;
        } catch (CosXmlClientException e) {
            e.printStackTrace();
            assertError(e);
        } catch (CosXmlServiceException e) {
            e.printStackTrace();
            assertError(e);
        }
        
        if (true) {return;}
        // 使用异步回调请求
        cosXmlService.copyObjectAsync(uploadPartCopyRequest, new CosXmlResultListener() {
            @Override
            public void onSuccess(CosXmlRequest request, CosXmlResult result) {
                // todo Copy Object success
          UploadPartCopyResult uploadPartCopyResult  = (UploadPartCopyResult)result;
            }
        
            @Override
            public void onFail(CosXmlRequest cosXmlRequest, CosXmlClientException clientException, CosXmlServiceException serviceException)  {
                // todo Copy Object failed because of CosXmlClientException or CosXmlServiceException...
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
        putBucket();
    }

    @After public void tearDown() {
        deleteObject();
        deleteBucket();
    }

    @Test public void testObjectMetadata() {
        putObject();
        putObjectAcl();
        getObjectAcl();
        headObject();
        getObject();
        getPresignDownloadUrl();
        getPresignUploadUrl();
        deleteObject();
        deleteMultiObject();
        postObject();
        restoreObject();
    }
    @Test public void testObjectMultiUpload() {
        initMultiUpload();
        listMultiUpload();
        uploadPart();
        listParts();
        completeMultiUpload();
    }
    @Test public void testObjectAbortMultiUpload() {
        initMultiUpload();
        uploadPart();
        abortMultiUpload();
    }
    @Test public void testObjectTransfer() {
        transferUploadObject();
        transferDownloadObject();
        transferCopyObject();
    }
    @Test public void testObjectCopy() {
        copyObject();
        initMultiUpload();
        uploadPartCopy();
        completeMultiUpload();
    }
}
