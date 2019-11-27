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
public class ObjectCopy {

    private static Context context;

    private static void assertError(Exception e) {
        throw new RuntimeException(e.getMessage());
    }

    @BeforeClass public static void setUp() {
        context = InstrumentationRegistry.getInstrumentation().getTargetContext();
        
    }

    @AfterClass public static void tearDown() {
        
    }

    public void CopyObject()
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
        
        //具体步骤：
        // 1. 调用 cosXmlService.initMultipartUpload(InitMultipartUploadRequest) 初始化分片,请参考 [InitMultipartUploadRequest 初始化分片](#InitMultipartUploadRequest)。
        // 2. 调用 cosXmlService.copyObject(UploadPartCopyRequest) 完成分片复制。
        // 3. 调用 cosXmlService.completeMultiUpload(CompleteMultiUploadRequest) 完成分片复制,请参考 [CompleteMultiUploadRequest 完成分片复制](#CompleteMultiUploadRequest)。
        
        String sourceAppid = "1250000000"; //账号 appid
        String sourceBucket = "sourcebucket-1250000000"; //"源对象所在的存储桶
        String sourceRegion = "ap-beijing"; //源对象的存储桶所在的地域
        String sourceCosPath = "source-object4Android"; //源对象键
        //构造源对象属性
        CopyObjectRequest.CopySourceStruct copySourceStruct = new CopyObjectRequest.CopySourceStruct(sourceAppid, sourceBucket, sourceRegion, sourceCosPath);
        
        String bucket = "bucket-cssg-test-1253653367"; //存储桶，格式：BucketName-APPID
        String cosPath = "object4Android"; //对象在存储桶中的位置标识符，即对象键。
        
        String uploadId = "初始化分片的uploadId";
        int partNumber = 1; //分片编号
        long start = 0;//复制源对象的开始位置
        long end = 100; //复制源对象的结束位置
        
        UploadPartCopyRequest uploadPartCopyRequest = new UploadPartCopyRequest(bucket, cosPath, partNumber,  uploadId, copySourceStruct, start, end);
        //设置签名校验Host, 默认校验所有Header
        Set<String> headerKeys = new HashSet<>();
        headerKeys.add("Host");
        uploadPartCopyRequest.setSignParamsAndHeaders(null, headerKeys);
        // 使用同步方法
        try {
            UploadPartCopyResult uploadPartCopyResult = cosXmlService.copyObject(uploadPartCopyRequest);
        } catch (CosXmlClientException e) {
            e.printStackTrace();
            assertError(e);
        } catch (CosXmlServiceException e) {
            e.printStackTrace();
            assertError(e);
        }
        
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

    @Test public void testObjectCopy() {
      CopyObject();
      InitMultiUpload();
      CompleteMultiUpload();
    }
}
