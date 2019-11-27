package com.tencent.qcloud.cosxml.cssg;

import android.os.Environment;
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
import com.tencent.qcloud.cosxml.cssg.GlobalInitCustomProvider.MyCredentialProvider;

import org.junit.Test;
import org.junit.AfterClass;
import org.junit.BeforeClass;
import org.junit.runner.RunWith;

import android.content.Context;
import android.util.Log;

import java.net.*;
import java.util.*;
import java.nio.charset.Charset;
import java.io.*;

@RunWith(AndroidJUnit4.class)
public class ObjectMultiUpload {

    private static Context context;

    private static void assertError(Exception e) {
        throw new RuntimeException(e.getMessage());
    }

    @BeforeClass public static void setUp() {
        context = InstrumentationRegistry.getInstrumentation().getTargetContext();
        
    }

    @AfterClass public static void tearDown() {
        
    }

    public void InitMultiUpload()
    {
        CosXmlServiceConfig serviceConfig = new CosXmlServiceConfig.Builder()
               .isHttps(true) // 设置 Https 请求
               .setRegion("ap-guangzhou") // 设置默认的存储桶地域
               .builder();
        
        // 构建一个从临时密钥服务器拉取临时密钥的 Http 请求
        HttpRequest<String> httpRequest = null;
        try {
           httpRequest = new HttpRequest.Builder<String>()
                   .url(new URL(""))
                   .build();
        } catch (MalformedURLException e) {
           e.printStackTrace();
        }
        QCloudCredentialProvider credentialProvider = new SessionCredentialProvider(httpRequest);
        credentialProvider = new ShortTimeCredentialProvider(BuildConfig.COS_SECRET_ID, BuildConfig.COS_SECRET_KEY, 3600); // for ut
        CosXmlService cosXmlService = new CosXmlService(context, serviceConfig, credentialProvider);
        
        String bucket = "bucket-cssg-test-1253653367"; //格式：BucketName-APPID
        String cosPath = "object4Android"; //对象在存储桶中的位置标识符，即对象键。 如 cosPath = "text.txt";
        
        InitMultipartUploadRequest initMultipartUploadRequest = new InitMultipartUploadRequest(bucket, cosPath);
        //设置签名校验Host, 默认校验所有Header
        Set<String> headerKeys = new HashSet<>();
        headerKeys.add("Host");
        initMultipartUploadRequest.setSignParamsAndHeaders(null, headerKeys);
        // 使用同步方法请求
        try {
            InitMultipartUploadResult initMultipartUploadResult = cosXmlService.initMultipartUpload(initMultipartUploadRequest);
            String uploadId =initMultipartUploadResult.initMultipartUpload.uploadId;
        } catch (CosXmlClientException e) {
            e.printStackTrace();
            assertError(e);
        } catch (CosXmlServiceException e) {
            e.printStackTrace();
            assertError(e);
        }
        
        // 使用异步方法请求
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
    public void ListMultiUpload()
    {
        CosXmlServiceConfig serviceConfig = new CosXmlServiceConfig.Builder()
               .isHttps(true) // 设置 Https 请求
               .setRegion("ap-guangzhou") // 设置默认的存储桶地域
               .builder();
        
        // 构建一个从临时密钥服务器拉取临时密钥的 Http 请求
        HttpRequest<String> httpRequest = null;
        try {
           httpRequest = new HttpRequest.Builder<String>()
                   .url(new URL(""))
                   .build();
        } catch (MalformedURLException e) {
           e.printStackTrace();
        }
        QCloudCredentialProvider credentialProvider = new SessionCredentialProvider(httpRequest);
        credentialProvider = new ShortTimeCredentialProvider(BuildConfig.COS_SECRET_ID, BuildConfig.COS_SECRET_KEY, 3600); // for ut
        CosXmlService cosXmlService = new CosXmlService(context, serviceConfig, credentialProvider);
        
        String bucket = "bucket-cssg-test-1253653367"; //格式：BucketName-APPID
        ListMultiUploadsRequest listMultiUploadsRequest = new ListMultiUploadsRequest(bucket);
        //设置签名校验Host, 默认校验所有Header
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
    public void UploadPart()
    {
        CosXmlServiceConfig serviceConfig = new CosXmlServiceConfig.Builder()
               .isHttps(true) // 设置 Https 请求
               .setRegion("ap-guangzhou") // 设置默认的存储桶地域
               .builder();
        
        // 构建一个从临时密钥服务器拉取临时密钥的 Http 请求
        HttpRequest<String> httpRequest = null;
        try {
           httpRequest = new HttpRequest.Builder<String>()
                   .url(new URL(""))
                   .build();
        } catch (MalformedURLException e) {
           e.printStackTrace();
        }
        QCloudCredentialProvider credentialProvider = new SessionCredentialProvider(httpRequest);
        credentialProvider = new ShortTimeCredentialProvider(BuildConfig.COS_SECRET_ID, BuildConfig.COS_SECRET_KEY, 3600); // for ut
        CosXmlService cosXmlService = new CosXmlService(context, serviceConfig, credentialProvider);
        
        String bucket = "bucket-cssg-test-1253653367"; //存储桶，格式：BucketName-APPID
        String cosPath = "object4Android"; //对象在存储桶中的位置标识符，即对象键。
        String uploadId ="xxxxxxxx"; //初始化分片上传返回的 uploadId
        int partNumber = 1; //分片块编号，必须从1开始递增
        String srcPath = Environment.getExternalStorageDirectory().getPath() + "/object4Android"; //本地文件绝对路径
        UploadPartRequest uploadPartRequest = new UploadPartRequest(bucket, cosPath, partNumber, srcPath, uploadId);
        
        uploadPartRequest.setProgressListener(new CosXmlProgressListener() {
            @Override
            public void onProgress(long progress, long max) {
                float result = (float) (progress * 100.0/max);
                Log.w("TEST","progress =" + (long)result + "%");
            }
        });
        //设置签名校验Host, 默认校验所有Header
        Set<String> headerKeys = new HashSet<>();
        headerKeys.add("Host");
        uploadPartRequest.setSignParamsAndHeaders(null, headerKeys);
        //使用同步方法上传
        try {
            UploadPartResult uploadPartResult = cosXmlService.uploadPart(uploadPartRequest);
            String eTag = uploadPartResult.eTag; // 获取分片块的 eTag
        
        } catch (CosXmlClientException e) {
            e.printStackTrace();
            assertError(e);
        } catch (CosXmlServiceException e) {
            e.printStackTrace();
            assertError(e);
        }
        
        
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
    public void ListParts()
    {
        CosXmlServiceConfig serviceConfig = new CosXmlServiceConfig.Builder()
               .isHttps(true) // 设置 Https 请求
               .setRegion("ap-guangzhou") // 设置默认的存储桶地域
               .builder();
        
        // 构建一个从临时密钥服务器拉取临时密钥的 Http 请求
        HttpRequest<String> httpRequest = null;
        try {
           httpRequest = new HttpRequest.Builder<String>()
                   .url(new URL(""))
                   .build();
        } catch (MalformedURLException e) {
           e.printStackTrace();
        }
        QCloudCredentialProvider credentialProvider = new SessionCredentialProvider(httpRequest);
        credentialProvider = new ShortTimeCredentialProvider(BuildConfig.COS_SECRET_ID, BuildConfig.COS_SECRET_KEY, 3600); // for ut
        CosXmlService cosXmlService = new CosXmlService(context, serviceConfig, credentialProvider);
        
        String bucket = "bucket-cssg-test-1253653367"; //格式：BucketName-APPID
        String cosPath = "object4Android"; //对象在存储桶中的位置标识符，即对象键。 如 cosPath = "text.txt";
        String uploadId = "初始化分片返回的 uploadId";
        
        ListPartsRequest listPartsRequest = new ListPartsRequest(bucket, cosPath, uploadId);
        //设置签名校验Host, 默认校验所有Header
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
    public void CompleteMultiUpload()
    {
        CosXmlServiceConfig serviceConfig = new CosXmlServiceConfig.Builder()
               .isHttps(true) // 设置 Https 请求
               .setRegion("ap-guangzhou") // 设置默认的存储桶地域
               .builder();
        
        // 构建一个从临时密钥服务器拉取临时密钥的 Http 请求
        HttpRequest<String> httpRequest = null;
        try {
           httpRequest = new HttpRequest.Builder<String>()
                   .url(new URL(""))
                   .build();
        } catch (MalformedURLException e) {
           e.printStackTrace();
        }
        QCloudCredentialProvider credentialProvider = new SessionCredentialProvider(httpRequest);
        credentialProvider = new ShortTimeCredentialProvider(BuildConfig.COS_SECRET_ID, BuildConfig.COS_SECRET_KEY, 3600); // for ut
        CosXmlService cosXmlService = new CosXmlService(context, serviceConfig, credentialProvider);
        
        String bucket = "bucket-cssg-test-1253653367"; //格式：BucketName-APPID
        String cosPath = "object4Android"; //对象在存储桶中的位置标识符，即对象键。 如 cosPath = "text.txt";
        String uploadId = "初始化分片返回的 uploadId";
        int partNumber = 1;
        String etag = "编号为 partNumber 对应分片上传结束返回的 etag ";
        Map<Integer, String> partNumberAndETag = new HashMap<>();
        partNumberAndETag.put(partNumber, etag);
        
        CompleteMultiUploadRequest completeMultiUploadRequest = new CompleteMultiUploadRequest(bucket, cosPath, uploadId, partNumberAndETag);
        //设置签名校验Host, 默认校验所有Header
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
    public void AbortMultiUpload()
    {
        CosXmlServiceConfig serviceConfig = new CosXmlServiceConfig.Builder()
               .isHttps(true) // 设置 Https 请求
               .setRegion("ap-guangzhou") // 设置默认的存储桶地域
               .builder();
        
        // 构建一个从临时密钥服务器拉取临时密钥的 Http 请求
        HttpRequest<String> httpRequest = null;
        try {
           httpRequest = new HttpRequest.Builder<String>()
                   .url(new URL(""))
                   .build();
        } catch (MalformedURLException e) {
           e.printStackTrace();
        }
        QCloudCredentialProvider credentialProvider = new SessionCredentialProvider(httpRequest);
        credentialProvider = new ShortTimeCredentialProvider(BuildConfig.COS_SECRET_ID, BuildConfig.COS_SECRET_KEY, 3600); // for ut
        CosXmlService cosXmlService = new CosXmlService(context, serviceConfig, credentialProvider);
        
        String bucket = "bucket-cssg-test-1253653367"; //格式：BucketName-APPID
        String cosPath = "object4Android"; //对象在存储桶中的位置标识符，即对象键。 如 cosPath = "text.txt";
        String uploadId = "初始化分片返回的 uploadId";
        
        AbortMultiUploadRequest abortMultiUploadRequest = new AbortMultiUploadRequest(bucket, cosPath, uploadId);
        //设置签名校验Host, 默认校验所有Header
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
        }
        
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

    @Test public void testObjectMultiUpload() {
      InitMultiUpload();
      ListMultiUpload();
      UploadPart();
      ListParts();
      CompleteMultiUpload();
      AbortMultiUpload();
    }
}
