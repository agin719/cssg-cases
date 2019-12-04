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
import com.tencent.qcloud.cosxml.cssg.InitCustomProvider.MyCredentialProvider;

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
public class Object {

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

    private String uploadId;
    private String part1Etag;

    private void GetBucket()
    {
        String bucketName = "bucket-cssg-test-1253653367"; //格式：BucketName-APPID;
        GetBucketRequest getBucketRequest = new GetBucketRequest(bucketName);
        
        // 前缀匹配，用来规定返回的对象前缀地址
        getBucketRequest.setPrefix("prefix");
        
        // 如果是第一次调用，您无需设置 marker 参数，COS 会从头开始列出对象
        // 如果需列出下一页对象，则需要将 marker 设置为上次列出对象时返回的 GetBucketResult.listBucket.nextMarker 值
        // 如果返回的 GetBucketResult.listBucket.isTruncated 为 false，则说明您已经列出了所有满足条件的对象
        // getBucketRequest.setMarker(marker);
        
        // 单次返回最大的条目数量，默认1000
        getBucketRequest.setMaxKeys(100);
        
        // 定界符为一个符号，如果有 Prefix，
        // 则将 Prefix 到 delimiter 之间的相同路径归为一类，定义为 Common Prefix，
        // 然后列出所有 Common Prefix。如果没有 Prefix，则从路径起点开始
        getBucketRequest.setDelimiter('/');
        
        // 设置签名校验 Host, 默认校验所有 Header
        Set<String> headerKeys = new HashSet<>();
        headerKeys.add("Host");
        getBucketRequest.setSignParamsAndHeaders(null, headerKeys);
        // 使用同步方法
        try {
            GetBucketResult getBucketResult = cosXmlService.getBucket(getBucketRequest);
        } catch (CosXmlClientException e) {
            e.printStackTrace();
            assertError(e);
        } catch (CosXmlServiceException e) {
            e.printStackTrace();
            assertError(e);
        }
        
        // 使用异步回调请求
        cosXmlService.getBucketAsync(getBucketRequest, new CosXmlResultListener() {
            @Override
            public void onSuccess(CosXmlRequest request, CosXmlResult result) {
                // todo Get Bucket success
          GetBucketResult getBucketResult = (GetBucketResult)result;
            }
        
            @Override
            public void onFail(CosXmlRequest cosXmlRequest, CosXmlClientException clientException, CosXmlServiceException serviceException)  {
                // todo Get Bucket failed because of CosXmlClientException or CosXmlServiceException...
            }
        });
        
        // 如果您需列出所有的对象，可以参考如下代码：
        
        bucketName = "bucket-cssg-test-1253653367";
        getBucketRequest = new GetBucketRequest(bucketName);
        
        // prefix 表示列出的 object 的 key 以 prefix 开始
        getBucketRequest.setPrefix("images/");
        // delimiter 表示分隔符, 设置为 / 表示列出当前目录下的 object, 设置为空表示列出所有的 object
        getBucketRequest.setDelimiter("/");
        // 设置最大遍历出多少个对象, 一次 listobject 最大支持1000
        getBucketRequest.setMaxKeys(100);
        GetBucketResult getBucketResult = null;
        do {
            try {
                getBucketResult = cosXmlService.getBucket(getBucketRequest);
            } catch (CosXmlClientException e) {
                e.printStackTrace();
                assertError(e);
                return;
            } catch (CosXmlServiceException e) {
                e.printStackTrace();
                assertError(e);
                return;
            }
            // commonPrefixs 表示表示被 delimiter 截断的路径, 例如 delimter 设置为 /, commonPrefixs 则表示子目录的路径
            List<ListBucket.CommonPrefixes> commonPrefixs = getBucketResult.listBucket.commonPrefixesList;
        
            // contents 表示列出的 object 列表
            List<ListBucket.Contents> contents = getBucketResult.listBucket.contentsList;
        
            String nextMarker = getBucketResult.listBucket.nextMarker;
            getBucketRequest.setMarker(nextMarker);
        } while (getBucketResult.listBucket.isTruncated);
        
    }
    private void PutObject()
    {
        String bucket = "bucket-cssg-test-1253653367"; //存储桶，格式：BucketName-APPID
        String cosPath = "object4android"; //对象位于存储桶中的位置标识符，即对象键。如 cosPath = "text.txt";
        String srcPath = new File(context.getExternalCacheDir(), "object4android").toString();//"本地文件的绝对路径";
        PutObjectRequest putObjectRequest = new PutObjectRequest(bucket, cosPath, srcPath);
        
        putObjectRequest.setProgressListener(new CosXmlProgressListener() {
            @Override
            public void onProgress(long progress, long max) {
                // todo Do something to update progress...
            }
        });
        //设置签名校验Host, 默认校验所有Header
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
        
        
        //上传字节数组
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
        
        
        //上传字节流
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
    private void HeadObject()
    {
        String bucket = bucket = "bucket-cssg-test-1253653367"; //存储桶名称，格式：BucketName-APPID
        String cosPath = "object4android"; //对象位于存储桶中的位置标识符，即对象键
        HeadObjectRequest headObjectRequest = new HeadObjectRequest(bucket, cosPath);
        //设置签名校验Host, 默认校验所有Header
        Set<String> headerKeys = new HashSet<>();
        headerKeys.add("Host");
        headObjectRequest.setSignParamsAndHeaders(null, headerKeys);
        //使用同步方法
        try {
            HeadObjectResult headObjectResult = cosXmlService.headObject(headObjectRequest);
        } catch (CosXmlClientException e) {
            e.printStackTrace();
            assertError(e);
        } catch (CosXmlServiceException e) {
            e.printStackTrace();
            assertError(e);
        }
        
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
        String bucket = "bucket-cssg-test-1253653367"; //存储桶名称，格式：BucketName-APPID
        String cosPath = "object4android"; //对象位于存储桶中的位置标识符，即对象键
        String savePath = context.getExternalCacheDir().toString();//本地路径
        
        GetObjectRequest getObjectRequest = new GetObjectRequest(bucket, cosPath, savePath);
        getObjectRequest.setProgressListener(new CosXmlProgressListener() {
            @Override
            public void onProgress(long progress, long max) {
                // todo Do something to update progress...
            }
        });
        //设置签名校验Host, 默认校验所有Header
        Set<String> headerKeys = new HashSet<>();
        headerKeys.add("Host");
        getObjectRequest.setSignParamsAndHeaders(null, headerKeys);
        //使用同步方法下载
        try {
            GetObjectResult getObjectResult =cosXmlService.getObject(getObjectRequest);
        } catch (CosXmlClientException e) {
            e.printStackTrace();
            assertError(e);
        } catch (CosXmlServiceException e) {
            e.printStackTrace();
            assertError(e);
        }
        
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
        String bucket = "bucket-cssg-test-1253653367"; //存储桶名称，格式：BucketName-APPID
        String cosPath = "object4android"; //对象在存储桶中的位置标识符，即对象键
        
        DeleteObjectRequest deleteObjectRequest = new DeleteObjectRequest(bucket, cosPath);
        //设置签名校验Host, 默认校验所有Header
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
        String bucket = "bucket-cssg-test-1253653367"; //存储桶，格式：BucketName-APPID
        List<String> objectList = new ArrayList<String>();
        objectList.add("object4android");//对象在存储桶中的位置标识符，即对象键
        
        DeleteMultiObjectRequest deleteMultiObjectRequest = new DeleteMultiObjectRequest(bucket, objectList);
        deleteMultiObjectRequest.setQuiet(true);
        //设置签名校验Host, 默认校验所有Header
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
        String bucket = "bucket-cssg-test-1253653367"; //存储桶名称，格式：BucketName-APPID
        String cosPath = "object4android"; //对象位于存储桶中的位置标识符，即对象键。如 cosPath = "text.txt";
        String srcPath = new File(context.getExternalCacheDir(), "object4android").toString();//"本地文件的绝对路径";
        
        PostObjectRequest postObjectRequest = new PostObjectRequest(bucket, cosPath, srcPath);
        
        postObjectRequest.setProgressListener(new CosXmlProgressListener() {
            @Override
            public void onProgress(long progress, long max) {
                // todo Do something to update progress...
            }
        });
        //设置签名校验Host, 默认校验所有Header
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
        String bucket = "bucket-cssg-test-1253653367"; //格式：BucketName-APPID
        String cosPath = "object4android"; //对象在存储桶中的位置标识符，即对象键。 如 cosPath = "text.txt";
        RestoreRequest restoreRequest = new RestoreRequest(bucket, cosPath);
        restoreRequest.setExpireDays(5); // 保留 5天
        restoreRequest.setTier(RestoreConfigure.Tier.Standard); // 标准恢复模式
        //设置签名校验Host, 默认校验所有Header
        Set<String> headerKeys = new HashSet<>();
        headerKeys.add("Host");
        restoreRequest.setSignParamsAndHeaders(null, headerKeys);
        // 使用同步方法
        try {
            RestoreResult restoreResult = cosXmlService.restoreObject(restoreRequest);
        } catch (CosXmlClientException e) {
            e.printStackTrace();
            assertError(e);
        } catch (CosXmlServiceException e) {
            e.printStackTrace();
            assertError(e, e.getStatusCode() == 405);
        }
        
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
            String bucket = "bucket-cssg-test-1253653367"; //存储桶名称
            String cosPath = "object4android"; //即对象在存储桶中的位置标识符。如 cosPath = "text.txt";
            String method = "GET"; //请求 HTTP 方法.
            PresignedUrlRequest presignedUrlRequest = new PresignedUrlRequest(bucket, cosPath);
            presignedUrlRequest.setRequestMethod(method);
        
            String urlWithSign = cosXmlService.getPresignedURL(presignedUrlRequest); //上传预签名 URL (使用永久密钥方式计算的签名 URL )
        
            //String urlWithSign = cosXmlService.getPresignedURL(getObjectRequest)； //直接使用 GetObjectRequest
        
            String savePath = context.getExternalCacheDir().toString(); //本地路径
            String saveFileName = "object4android"; //本地文件名
            GetObjectRequest getObjectRequest = new GetObjectRequest("bucket-cssg-test-1253653367", "object4android", savePath, saveFileName);
        
            //设置上传请求预签名 URL
            getObjectRequest.setRequestURL(urlWithSign);
            //设置进度回调
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
        
         String bucket = "bucket-cssg-android-temp-1253653367"; //存储桶名称
         String cosPath = "object4android"; //即对象在存储桶中的位置标识符。如 cosPath = "text.txt";
         String method = "PUT"; //请求 HTTP 方法.
         PresignedUrlRequest presignedUrlRequest = new PresignedUrlRequest(bucket, cosPath){
             @Override
                public RequestBodySerializer getRequestBody() throws CosXmlClientException {
                    //用于计算 put 等需要带上  body 的请求的签名URL
                    return RequestBodySerializer.string("text/plain", "this is test");
                 }
            };
         presignedUrlRequest.setRequestMethod(method);
        
         String urlWithSign = cosXmlService.getPresignedURL(presignedUrlRequest); //上传预签名 URL (使用永久密钥方式计算的签名 URL )
        
         //String urlWithSign = cosXmlService.getPresignedURL(putObjectRequest)； //直接使用PutObjectRequest
        
         String srcPath = new File(context.getExternalCacheDir(), "object4android").toString();
         PutObjectRequest putObjectRequest = new PutObjectRequest("bucket-cssg-test-1253653367", "object4android", srcPath);
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

    private void initService() {
        context = InstrumentationRegistry.getInstrumentation().getTargetContext();
        CosXmlServiceConfig serviceConfig = new CosXmlServiceConfig.Builder()
            .isHttps(true)
            .setRegion("ap-guangzhou")
            .builder();

        QCloudCredentialProvider credentialProvider = new ShortTimeCredentialProvider(BuildConfig.COS_SECRET_ID, BuildConfig.COS_SECRET_KEY, 3600);
        cosXmlService = new CosXmlService(context, serviceConfig, credentialProvider);

        try {
            File srcFile = new File(context.getExternalCacheDir(), "object4android");
            if (!srcFile.exists() && srcFile.createNewFile()) {
                RandomAccessFile raf = new RandomAccessFile(srcFile, "rw");
                raf.setLength(10);
                raf.close();
            }
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    @Before public void setUp() {
        initService();
    }

    @After public void tearDown() {
    }

    @Test public void testObject() {
        GetBucket();
        PutObject();
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
