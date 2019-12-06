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
public class BucketACL {

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

    private void PutBucket()
    {
        String bucket = "bucket-cssg-android-temp-1253653367";
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
            assertError(e);
        } catch (CosXmlServiceException e) {
            e.printStackTrace();
            assertError(e, e.getStatusCode() == 409);
        }
        
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
    private void HeadBucket()
    {
        String bucket = "bucket-cssg-android-temp-1253653367"; //格式：BucketName-APPID
        HeadBucketRequest headBucketRequest = new HeadBucketRequest(bucket);
        // 设置签名校验 Host，默认校验所有 Header
        Set<String> headerKeys = new HashSet<>();
        headerKeys.add("Host");
        headBucketRequest.setSignParamsAndHeaders(null, headerKeys);
        // 使用同步方法
        try {
            HeadBucketResult headBucketResult = cosXmlService.headBucket(headBucketRequest);
        } catch (CosXmlClientException e) {
            e.printStackTrace();
            assertError(e);
        } catch (CosXmlServiceException e) {
            e.printStackTrace();
            assertError(e);
        }
        
        // 使用异步回调请求
        cosXmlService.headBucketAsync(headBucketRequest, new CosXmlResultListener() {
            @Override
            public void onSuccess(CosXmlRequest request, CosXmlResult result) {
                // todo Head Bucket success
          HeadBucketResult headBucketResult = (HeadBucketResult)result;
            }
        
            @Override
            public void onFail(CosXmlRequest cosXmlRequest, CosXmlClientException clientException, CosXmlServiceException serviceException)  {
                // todo Head Bucket failed because of CosXmlClientException or CosXmlServiceException...
            }
        });
    }
    private void PutBucketAcl()
    {
        String bucket = "bucket-cssg-android-temp-1253653367"; //格式：BucketName-APPID
        PutBucketACLRequest putBucketACLRequest = new PutBucketACLRequest(bucket);
        
        // 设置 bucket 访问权限
        putBucketACLRequest.setXCOSACL("public-read");
        
        // 赋予被授权者读的权限
        ACLAccount readACLS = new ACLAccount();
        readACLS.addAccount("1278687956", "1278687956");
        putBucketACLRequest.setXCOSGrantRead(readACLS);
        
        // 赋予被授权者写的权限
        ACLAccount writeACLS = new ACLAccount();
        writeACLS.addAccount("1278687956", "1278687956");
        putBucketACLRequest.setXCOSGrantRead(writeACLS);
        
        // 赋予被授权者读写的权限
        ACLAccount writeandReadACLS = new ACLAccount();
        writeandReadACLS.addAccount("1278687956", "1278687956");
        putBucketACLRequest.setXCOSGrantRead(writeandReadACLS);
        // 设置签名校验 Host，默认校验所有 Header
        Set<String> headerKeys = new HashSet<>();
        headerKeys.add("Host");
        putBucketACLRequest.setSignParamsAndHeaders(null, headerKeys);
        // 使用同步方法
        try {
            PutBucketACLResult putBucketACLResult = cosXmlService.putBucketACL(putBucketACLRequest);
        } catch (CosXmlClientException e) {
            e.printStackTrace();
            assertError(e);
        } catch (CosXmlServiceException e) {
            e.printStackTrace();
            assertError(e);
        }
        
        // 使用异步回调请求
        cosXmlService.putBucketACLAsync(putBucketACLRequest, new CosXmlResultListener() {
            @Override
            public void onSuccess(CosXmlRequest request, CosXmlResult result) {
                // todo Put Bucket ACL success
          PutBucketACLResult putBucketACLResult = (PutBucketACLResult)result;
            }
        
            @Override
            public void onFail(CosXmlRequest cosXmlRequest, CosXmlClientException clientException, CosXmlServiceException serviceException)  {
                // todo Put Bucket ACL failed because of CosXmlClientException or CosXmlServiceException...
            }
        });
        
    }
    private void GetBucketAcl()
    {
        String bucket = "bucket-cssg-android-temp-1253653367"; //格式：BucketName-APPID
        GetBucketACLRequest getBucketACLRequest = new GetBucketACLRequest(bucket);
        // 设置签名校验 Host，默认校验所有 Header
        Set<String> headerKeys = new HashSet<>();
        headerKeys.add("Host");
        getBucketACLRequest.setSignParamsAndHeaders(null, headerKeys);
        // 使用同步方法
        try {
            GetBucketACLResult getBucketACLResult = cosXmlService.getBucketACL(getBucketACLRequest);
        } catch (CosXmlClientException e) {
            e.printStackTrace();
            assertError(e);
        } catch (CosXmlServiceException e) {
            e.printStackTrace();
            assertError(e);
        }
        
        // 使用异步回调请求
        cosXmlService.getBucketACLAsync(getBucketACLRequest, new CosXmlResultListener() {
            @Override
            public void onSuccess(CosXmlRequest request, CosXmlResult result) {
                // todo Get Bucket ACL success
          GetBucketACLResult getBucketACLResult = (GetBucketACLResult)result;
            }
        
            @Override
            public void onFail(CosXmlRequest cosXmlRequest, CosXmlClientException clientException, CosXmlServiceException serviceException)  {
                // todo Get Bucket ACL failed because of CosXmlClientException or CosXmlServiceException...
            }
        });
        
    }
    private void DeleteBucket()
    {
        String bucket = "bucket-cssg-android-temp-1253653367"; //格式：BucketName-APPID
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
            assertError(e);
        } catch (CosXmlServiceException e) {
            e.printStackTrace();
            assertError(e);
        }
        
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
        PutBucket();
    }

    @After public void tearDown() {
        DeleteBucket();
    }

    @Test public void testBucketACL() {
        HeadBucket();
        PutBucketAcl();
        GetBucketAcl();
    }
}
