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
public class ObjectCopy {

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

    private void CopyObject()
    {
        String sourceAppid = "1253653367"; //账号 APPID
        String sourceBucket = "bucket-cssg-test-1253653367"; //源对象所在的存储桶
        String sourceRegion = "ap-guangzhou"; //源对象的存储桶所在的地域
        String sourceCosPath = "sourceObject"; //源对象键
        // 构造源对象属性
        CopyObjectRequest.CopySourceStruct copySourceStruct = new CopyObjectRequest.CopySourceStruct(sourceAppid, sourceBucket, sourceRegion, sourceCosPath);
        String bucket = "bucket-cssg-test-1253653367"; //存储桶，格式：BucketName-APPID
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
    private void InitMultiUpload()
    {
        String bucket = "bucket-cssg-test-1253653367"; //格式：BucketName-APPID
        String cosPath = "object4android"; //对象在存储桶中的位置标识符，即对象键。 例如 cosPath = "text.txt";
        
        InitMultipartUploadRequest initMultipartUploadRequest = new InitMultipartUploadRequest(bucket, cosPath);
        // 设置签名校验 Host，默认校验所有 Header
        Set<String> headerKeys = new HashSet<>();
        headerKeys.add("Host");
        initMultipartUploadRequest.setSignParamsAndHeaders(null, headerKeys);
        // 使用同步方法请求
        try {
            InitMultipartUploadResult initMultipartUploadResult = cosXmlService.initMultipartUpload(initMultipartUploadRequest);
            String uploadId =initMultipartUploadResult.initMultipartUpload.uploadId;
            this.uploadId = uploadId;
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
    private void UploadPartCopy()
    {
        //具体步骤：
        // 1. 调用 cosXmlService.initMultipartUpload(InitMultipartUploadRequest) 初始化分块,请参考 [InitMultipartUploadRequest 初始化分块](#InitMultipartUploadRequest)。
        // 2. 调用 cosXmlService.copyObject(UploadPartCopyRequest) 完成分块复制。
        // 3. 调用 cosXmlService.completeMultiUpload(CompleteMultiUploadRequest) 完成分块复制,请参考 [CompleteMultiUploadRequest 完成分块复制](#CompleteMultiUploadRequest)。
        
        String sourceAppid = "1253653367"; //账号 APPID
        String sourceBucket = "bucket-cssg-test-1253653367"; //源对象所在的存储桶
        String sourceRegion = "ap-guangzhou"; //源对象的存储桶所在的地域
        String sourceCosPath = "sourceObject"; //源对象键
        // 构造源对象属性
        CopyObjectRequest.CopySourceStruct copySourceStruct = new CopyObjectRequest.CopySourceStruct(sourceAppid, sourceBucket, sourceRegion, sourceCosPath);
        
        String bucket = "bucket-cssg-test-1253653367"; //存储桶，格式：BucketName-APPID
        String cosPath = "object4android"; //对象在存储桶中的位置标识符，即对象键
        
        String uploadId = "example-uploadId";
        uploadId = this.uploadId;
        int partNumber = 1; //分块编号
        long start = 0; //复制源对象的开始位置
        long end = 100; //复制源对象的结束位置
        
        UploadPartCopyRequest uploadPartCopyRequest = new UploadPartCopyRequest(bucket, cosPath, partNumber,  uploadId, copySourceStruct, start, end);
        // 设置签名校验 Host，默认校验所有 Header
        Set<String> headerKeys = new HashSet<>();
        headerKeys.add("Host");
        uploadPartCopyRequest.setSignParamsAndHeaders(null, headerKeys);
        // 使用同步方法
        try {
            UploadPartCopyResult uploadPartCopyResult = cosXmlService.copyObject(uploadPartCopyRequest);
            String eTag = uploadPartCopyResult.copyObject.eTag;
            this.part1Etag = eTag;
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
    private void CompleteMultiUpload()
    {
        String bucket = "bucket-cssg-test-1253653367"; //格式：BucketName-APPID
        String cosPath = "object4android"; //对象在存储桶中的位置标识符，即对象键。 例如 cosPath = "text.txt";
        String uploadId = "example-uploadId";
        uploadId = this.uploadId;
        int partNumber = 1;
        String etag = "etag";
        etag = this.part1Etag;
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

    @Test public void testObjectCopy() {
        CopyObject();
        InitMultiUpload();
        UploadPartCopy();
        CompleteMultiUpload();
    }
}
