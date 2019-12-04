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
public class ObjectACL {

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
    private void PutObjectAcl()
    {
        String bucket = "bucket-cssg-test-1253653367"; //格式：BucketName-APPID
        String cosPath = "object4android"; //对象在存储桶中的位置标识符，即对象键。 如 cosPath = "text.txt";
        PutObjectACLRequest putObjectACLRequest = new PutObjectACLRequest(bucket, cosPath);
        
        //设置 bucket 访问权限
        putObjectACLRequest.setXCOSACL("public-read");
        
        //赋予被授权者读的权限
        ACLAccount readACLS = new ACLAccount();
        readACLS.addAccount("1278687956", "1278687956");
        putObjectACLRequest.setXCOSGrantRead(readACLS);
        
        //赋予被授权者读写的权限
        ACLAccount writeandReadACLS = new ACLAccount();
        writeandReadACLS.addAccount("1278687956", "1278687956");
        putObjectACLRequest.setXCOSGrantRead(writeandReadACLS);
        //设置签名校验Host, 默认校验所有Header
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
        String bucket = "bucket-cssg-test-1253653367"; //格式：BucketName-APPID
        String cosPath = "object4android"; //对象在存储桶中的位置标识符，即对象键。 如 cosPath = "text.txt";
        GetObjectACLRequest getBucketACLRequest = new GetObjectACLRequest(bucket, cosPath);
        //设置签名校验Host, 默认校验所有Header
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

    @Test public void testObjectACL() {
        PutObject();
        PutObjectAcl();
        GetObjectAcl();
    }
}
