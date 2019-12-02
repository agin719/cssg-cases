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
public class SnippetEverything {

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

    private void GetService()
    {
        GetServiceRequest getServiceRequest = new GetServiceRequest();
        //设置签名校验Host, 默认校验所有Header
        Set<String> headerKeys = new HashSet<>();
        headerKeys.add("Host");
        getServiceRequest.setSignParamsAndHeaders(null, headerKeys);
        // 使用同步方法
        try {
            GetServiceResult result = cosXmlService.getService(getServiceRequest);
        } catch (CosXmlClientException e) {
            e.printStackTrace();
        } catch (CosXmlServiceException e) {
            e.printStackTrace();
        }
        
        // 使用异步回调请求
        cosXmlService.getServiceAsync(getServiceRequest, new CosXmlResultListener() {
            @Override
            public void onSuccess(CosXmlRequest request, CosXmlResult result) {
                // todo Put Bucket Lifecycle success
          GetServiceResult getServiceResult = (GetServiceResult)result;
            }
        
            @Override
            public void onFail(CosXmlRequest cosXmlRequest, CosXmlClientException clientException, CosXmlServiceException serviceException)  {
                // todo Put Bucket Lifecycle failed because of CosXmlClientException or CosXmlServiceException...
            }
        });
    }
    private void PutBucket()
    {
        String bucket = "examplebucket-1250000000";
        PutBucketRequest putBucketRequest = new PutBucketRequest(bucket);
        
        //定义存储桶的 ACL 属性。有效值：private，public-read-write，public-read；默认值：private
        putBucketRequest.setXCOSACL("private");
        
        //赋予被授权者读的权限
        ACLAccount readACLS = new ACLAccount();
        readACLS.addAccount("100000000001", "100000000001");
        putBucketRequest.setXCOSGrantRead(readACLS);
        
        //赋予被授权者写的权限
        ACLAccount writeACLS = new ACLAccount();
        writeACLS.addAccount("100000000001", "100000000001");
        putBucketRequest.setXCOSGrantRead(writeACLS);
        
        //赋予被授权者读写的权限
        ACLAccount writeandReadACLS = new ACLAccount();
        writeandReadACLS.addAccount("100000000001", "100000000001");
        putBucketRequest.setXCOSGrantRead(writeandReadACLS);
        //设置签名校验Host, 默认校验所有Header
        Set<String> headerKeys = new HashSet<>();
        headerKeys.add("Host");
        putBucketRequest.setSignParamsAndHeaders(null, headerKeys);
        //使用同步方法
        try {
            PutBucketResult putBucketResult = cosXmlService.putBucket(putBucketRequest);
        } catch (CosXmlClientException e) {
            e.printStackTrace();
        } catch (CosXmlServiceException e) {
            e.printStackTrace();
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
        String bucket = "examplebucket-1250000000"; //格式：BucketName-APPID
        HeadBucketRequest headBucketRequest = new HeadBucketRequest(bucket);
        //设置签名校验Host, 默认校验所有Header
        Set<String> headerKeys = new HashSet<>();
        headerKeys.add("Host");
        headBucketRequest.setSignParamsAndHeaders(null, headerKeys);
        //使用同步方法
        try {
            HeadBucketResult headBucketResult = cosXmlService.headBucket(headBucketRequest);
        } catch (CosXmlClientException e) {
            e.printStackTrace();
        } catch (CosXmlServiceException e) {
            e.printStackTrace();
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
    private void DeleteBucket()
    {
        String bucket = "examplebucket-1250000000"; //格式：BucketName-APPID
        DeleteBucketRequest deleteBucketRequest = new DeleteBucketRequest(bucket);
        //设置签名校验Host, 默认校验所有Header
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
    private void PutBucketAcl()
    {
        String bucket = "examplebucket-1250000000"; //格式：BucketName-APPID
        PutBucketACLRequest putBucketACLRequest = new PutBucketACLRequest(bucket);
        
        //设置 bucket 访问权限
        putBucketACLRequest.setXCOSACL("public-read");
        
        //赋予被授权者读的权限
        ACLAccount readACLS = new ACLAccount();
        readACLS.addAccount("100000000001", "100000000001");
        putBucketACLRequest.setXCOSGrantRead(readACLS);
        
        //赋予被授权者写的权限
        ACLAccount writeACLS = new ACLAccount();
        writeACLS.addAccount("100000000001", "100000000001");
        putBucketACLRequest.setXCOSGrantRead(writeACLS);
        
        //赋予被授权者读写的权限
        ACLAccount writeandReadACLS = new ACLAccount();
        writeandReadACLS.addAccount("100000000001", "100000000001");
        putBucketACLRequest.setXCOSGrantRead(writeandReadACLS);
        //设置签名校验Host, 默认校验所有Header
        Set<String> headerKeys = new HashSet<>();
        headerKeys.add("Host");
        putBucketACLRequest.setSignParamsAndHeaders(null, headerKeys);
        // 使用同步方法
        try {
            PutBucketACLResult putBucketACLResult = cosXmlService.putBucketACL(putBucketACLRequest);
        } catch (CosXmlClientException e) {
            e.printStackTrace();
        } catch (CosXmlServiceException e) {
            e.printStackTrace();
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
        String bucket = "examplebucket-1250000000"; //格式：BucketName-APPID
        GetBucketACLRequest getBucketACLRequest = new GetBucketACLRequest(bucket);
        //设置签名校验Host, 默认校验所有Header
        Set<String> headerKeys = new HashSet<>();
        headerKeys.add("Host");
        getBucketACLRequest.setSignParamsAndHeaders(null, headerKeys);
        // 使用同步方法
        try {
            GetBucketACLResult getBucketACLResult = cosXmlService.getBucketACL(getBucketACLRequest);
        } catch (CosXmlClientException e) {
            e.printStackTrace();
        } catch (CosXmlServiceException e) {
            e.printStackTrace();
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
    private void PutBucketCors()
    {
        String bucket = "examplebucket-1250000000"; //格式：BucketName-APPID
        PutBucketCORSRequest putBucketCORSRequest = new PutBucketCORSRequest(bucket);
        
        /**
         * CORSConfiguration.cORSRule: 跨域访问配置信息
         * corsRule.id： 配置规则的 ID
         * corsRule.allowedOrigin: 允许的访问来源，支持通配符 * , 格式为：协议://域名[:端口]，如：http://www.qq.com
         * corsRule.maxAgeSeconds: 设置 OPTIONS 请求得到结果的有效期
         * corsRule.allowedMethod: 允许的 HTTP 操作，如：GET，PUT，HEAD，POST，DELETE
         * corsRule.allowedHeader：在发送 OPTIONS 请求时告知服务端，接下来的请求可以使用哪些自定义的 HTTP 请求头部，支持通配符 *
         * corsRule.exposeHeader： 设置浏览器可以接收到的来自服务端的自定义头部信息
         */
        CORSConfiguration.CORSRule corsRule = new CORSConfiguration.CORSRule();
        
        corsRule.id = "123";
        corsRule.allowedOrigin = "https://cloud.tencent.com";
        corsRule.maxAgeSeconds = 5000;
        
        List<String> methods = new LinkedList<>();
        methods.add("PUT");
        methods.add("POST");
        methods.add("GET");
        corsRule.allowedMethod = methods;
        
        List<String> headers = new LinkedList<>();
        headers.add("host");
        headers.add("content-type");
        corsRule.allowedHeader = headers;
        
        List<String> exposeHeaders = new LinkedList<>();
        exposeHeaders.add("x-cos-meta-1");
        corsRule.exposeHeader = exposeHeaders;
        
        //设置跨域访问配置信息
        putBucketCORSRequest.addCORSRule(corsRule);
        
        //设置签名校验Host, 默认校验所有Header
        Set<String> headerKeys = new HashSet<>();
        headerKeys.add("Host");
        putBucketCORSRequest.setSignParamsAndHeaders(null, headerKeys);
        
        // 使用同步方法
        try {
            PutBucketCORSResult putBucketCORSResult = cosXmlService.putBucketCORS(putBucketCORSRequest);
        } catch (CosXmlClientException e) {
            e.printStackTrace();
        } catch (CosXmlServiceException e) {
            e.printStackTrace();
        }
        
        // 使用异步回调请求
        cosXmlService.putBucketCORSAsync(putBucketCORSRequest, new CosXmlResultListener() {
            @Override
            public void onSuccess(CosXmlRequest request, CosXmlResult result) {
                // todo Put Bucket CORS success
          PutBucketCORSResult putBucketCORSResult = (PutBucketCORSResult)result;
            }
        
            @Override
            public void onFail(CosXmlRequest cosXmlRequest, CosXmlClientException clientException, CosXmlServiceException serviceException)  {
                // todo Put Bucket CORS failed because of CosXmlClientException or CosXmlServiceException...
            }
        });
    }
    private void GetBucketCors()
    {
        String bucket = "examplebucket-1250000000"; //格式：BucketName-APPID
        GetBucketCORSRequest getBucketCORSRequest = new GetBucketCORSRequest(bucket);
        //设置签名校验Host, 默认校验所有Header
        Set<String> headerKeys = new HashSet<>();
        headerKeys.add("Host");
        getBucketCORSRequest.setSignParamsAndHeaders(null, headerKeys);
        //使用同步方法
        try {
            GetBucketCORSResult getBucketCORSResult = cosXmlService.getBucketCORS(getBucketCORSRequest);
        } catch (CosXmlClientException e) {
            e.printStackTrace();
        } catch (CosXmlServiceException e) {
            e.printStackTrace();
        }
        
        // 使用异步回调请求
        cosXmlService.getBucketCORSAsync(getBucketCORSRequest, new CosXmlResultListener() {
            @Override
            public void onSuccess(CosXmlRequest request, CosXmlResult result) {
                // todo Get Bucket CORS success
          GetBucketCORSResult getBucketCORSResult = (GetBucketCORSResult)result;
            }
        
            @Override
            public void onFail(CosXmlRequest cosXmlRequest, CosXmlClientException clientException, CosXmlServiceException serviceException)  {
                // todo Get Bucket CORS failed because of CosXmlClientException or CosXmlServiceException...
            }
        });
    }
    private void DeleteBucketCors()
    {
        String bucket = "examplebucket-1250000000"; //格式：BucketName-APPID
        DeleteBucketCORSRequest deleteBucketCORSRequest = new DeleteBucketCORSRequest(bucket);
        //设置签名校验Host, 默认校验所有Header
        Set<String> headerKeys = new HashSet<>();
        headerKeys.add("Host");
        deleteBucketCORSRequest.setSignParamsAndHeaders(null, headerKeys);
        // 使用同步方法
        try {
            DeleteBucketCORSResult deleteBucketCORSResult = cosXmlService.deleteBucketCORS(deleteBucketCORSRequest);
        } catch (CosXmlClientException e) {
            e.printStackTrace();
        } catch (CosXmlServiceException e) {
            e.printStackTrace();
        }
        
        // 使用异步回调请求
        cosXmlService.deleteBucketCORSAsync(deleteBucketCORSRequest, new CosXmlResultListener() {
            @Override
            public void onSuccess(CosXmlRequest request, CosXmlResult result) {
                // todo Delete Bucket CORS success
          DeleteBucketCORSResult deleteBucketCORSResult = (DeleteBucketCORSResult)result;
            }
        
            @Override
            public void onFail(CosXmlRequest cosXmlRequest, CosXmlClientException clientException, CosXmlServiceException serviceException)  {
                // todo Delete Bucket CORS failed because of CosXmlClientException or CosXmlServiceException...
            }
        });
    }
    private void PutBucketLifecycle()
    {
        String bucket = "examplebucket-1250000000"; //格式：BucketName-APPID
        PutBucketLifecycleRequest putBucketLifecycleRequest = new PutBucketLifecycleRequest(bucket);
        
        // 声明周期配置规则信息
        LifecycleConfiguration.Rule rule = new LifecycleConfiguration.Rule();
        rule.id = "Lifecycle ID";
        LifecycleConfiguration.Filter filter = new LifecycleConfiguration.Filter();
        filter.prefix = "prefix/";
        rule.filter = filter;
        rule.status = "Enabled";
        LifecycleConfiguration.Transition transition = new LifecycleConfiguration.Transition();
        transition.days = 100;
        transition.storageClass = COSStorageClass.STANDARD.getStorageClass();
        rule.transition = transition;
        putBucketLifecycleRequest.setRuleList(rule);
        //设置签名校验Host, 默认校验所有Header
        Set<String> headerKeys = new HashSet<>();
        headerKeys.add("Host");
        putBucketLifecycleRequest.setSignParamsAndHeaders(null, headerKeys);
        // 使用同步方法
        try {
            PutBucketLifecycleResult putBucketLifecycleResult = cosXmlService.putBucketLifecycle(putBucketLifecycleRequest);
        } catch (CosXmlClientException e) {
            e.printStackTrace();
        } catch (CosXmlServiceException e) {
            e.printStackTrace();
        }
        
        // 使用异步回调请求
        cosXmlService.putBucketLifecycleAsync(putBucketLifecycleRequest, new CosXmlResultListener() {
            @Override
            public void onSuccess(CosXmlRequest request, CosXmlResult result) {
                // todo Put Bucket Lifecycle success
          PutBucketLifecycleResult putBucketLifecycleResult = (PutBucketLifecycleResult)result;
            }
        
            @Override
            public void onFail(CosXmlRequest cosXmlRequest, CosXmlClientException clientException, CosXmlServiceException serviceException)  {
                // todo Put Bucket Lifecycle failed because of CosXmlClientException or CosXmlServiceException...
            }
        });
        
    }
    private void GetBucketLifecycle()
    {
        String bucket = "examplebucket-1250000000"; //格式：BucketName-APPID
        GetBucketLifecycleRequest getBucketLifecycleRequest = new GetBucketLifecycleRequest(bucket);
        //设置签名校验Host, 默认校验所有Header
        Set<String> headerKeys = new HashSet<>();
        headerKeys.add("Host");
        getBucketLifecycleRequest.setSignParamsAndHeaders(null, headerKeys);
        // 使用同步方法
        try {
            GetBucketLifecycleResult getBucketLifecycleResult = cosXmlService.getBucketLifecycle(getBucketLifecycleRequest);
        } catch (CosXmlClientException e) {
            e.printStackTrace();
        } catch (CosXmlServiceException e) {
            e.printStackTrace();
        }
        
        // 使用异步回调请求
        cosXmlService.getBucketLifecycleAsync(getBucketLifecycleRequest, new CosXmlResultListener() {
            @Override
            public void onSuccess(CosXmlRequest request, CosXmlResult result) {
                // todo Get Bucket Lifecycle success
          GetBucketLifecycleResult getBucketLifecycleResult = (GetBucketLifecycleResult)result;
            }
        
            @Override
            public void onFail(CosXmlRequest cosXmlRequest, CosXmlClientException clientException, CosXmlServiceException serviceException)  {
                // todo Get Bucket Lifecycle failed because of CosXmlClientException or CosXmlServiceException...
            }
        });
        
    }
    private void DeleteBucketLifecycle()
    {
        String bucket = "examplebucket-1250000000"; //格式：BucketName-APPID
        DeleteBucketLifecycleRequest deleteBucketLifecycleRequest = new DeleteBucketLifecycleRequest(bucket);
        //设置签名校验Host, 默认校验所有Header
        Set<String> headerKeys = new HashSet<>();
        headerKeys.add("Host");
        deleteBucketLifecycleRequest.setSignParamsAndHeaders(null, headerKeys);
        //使用同步方法
        try {
            DeleteBucketLifecycleResult deleteBucketLifecycleResult = cosXmlService.deleteBucketLifecycle(deleteBucketLifecycleRequest);
        
        } catch (CosXmlClientException e) {
            e.printStackTrace();
        } catch (CosXmlServiceException e) {
            e.printStackTrace();
        }
        
        // 使用异步回调请求
        cosXmlService.deleteBucketLifecycleAsync(deleteBucketLifecycleRequest, new CosXmlResultListener() {
            @Override
            public void onSuccess(CosXmlRequest request, CosXmlResult result) {
                // todo Delete Bucket Lifecycle success
          DeleteBucketLifecycleResult deleteBucketLifecycleResult = (DeleteBucketLifecycleResult)result;
            }
        
            @Override
            public void onFail(CosXmlRequest cosXmlRequest, CosXmlClientException clientException, CosXmlServiceException serviceException)  {
                // todo Delete Bucket Lifecycle failed because of CosXmlClientException or CosXmlServiceException...
            }
        });
        
    }
    private void PutBucketVersioning()
    {
        String bucket = "examplebucket-1250000000"; //格式：BucketName-APPID
        PutBucketVersioningRequest putBucketVersioningRequest = new PutBucketVersioningRequest(bucket);
        putBucketVersioningRequest.setEnableVersion(true); //true: 开启版本控制; false:暂停版本控制
        //设置签名校验Host, 默认校验所有Header
        Set<String> headerKeys = new HashSet<>();
        headerKeys.add("Host");
        putBucketVersioningRequest.setSignParamsAndHeaders(null, headerKeys);
        // 使用同步方法
        try {
            PutBucketVersioningResult putBucketVersioningResult = cosXmlService.putBucketVersioning(putBucketVersioningRequest);
        } catch (CosXmlClientException e) {
            e.printStackTrace();
        } catch (CosXmlServiceException e) {
            e.printStackTrace();
        }
        // 使用异步回调请求
        cosXmlService.putBucketVersionAsync(putBucketVersioningRequest, new CosXmlResultListener() {
            @Override
            public void onSuccess(CosXmlRequest request, CosXmlResult result) {
                // todo PUT Bucket versioning success
                PutBucketVersioningResult putBucketVersioningResult = (PutBucketVersioningResult)result;
            }
        
            @Override
            public void onFail(CosXmlRequest cosXmlRequest, CosXmlClientException clientException, CosXmlServiceException serviceException)  {
                // todo PUT Bucket versioning failed because of CosXmlClientException or CosXmlServiceException...
            }
        });
        
    }
    private void GetBucketVersioning()
    {
        String bucket = "examplebucket-1250000000"; //格式：BucketName-APPID
        GetBucketVersioningRequest getBucketVersioningRequest = new GetBucketVersioningRequest(bucket);
        //设置签名校验Host, 默认校验所有Header
        Set<String> headerKeys = new HashSet<>();
        headerKeys.add("Host");
        getBucketVersioningRequest.setSignParamsAndHeaders(null, headerKeys);
        // 使用同步方法
        try {
            GetBucketVersioningResult getBucketVersioningResult = cosXmlService.getBucketVersioning(getBucketVersioningRequest);
        } catch (CosXmlClientException e) {
            e.printStackTrace();
        } catch (CosXmlServiceException e) {
            e.printStackTrace();
        }
        // 使用异步回调请求
        cosXmlService.getBucketVersioningAsync(getBucketVersioningRequest, new CosXmlResultListener() {
            @Override
            public void onSuccess(CosXmlRequest request, CosXmlResult result) {
                // todo GET Bucket versioning success
                GetBucketVersioningResult getBucketVersioningResult = (GetBucketVersioningResult)result;
            }
        
            @Override
            public void onFail(CosXmlRequest cosXmlRequest, CosXmlClientException clientException, CosXmlServiceException serviceException)  {
                // todo GET Bucket versioning failed because of CosXmlClientException or CosXmlServiceException...
            }
        });
    }
    private void PutBucketReplication()
    {
        String bucket = "examplebucket-1250000000"; //格式：BucketName-APPID
        String ownerUin = "100000000001"; //发起者身份标示:OwnerUin
        String subUin = "100000000001"; //发起者身份标示:SubUin
        PutBucketReplicationRequest putBucketReplicationRequest = new PutBucketReplicationRequest(bucket);
        putBucketReplicationRequest.setReplicationConfigurationWithRole(ownerUin, subUin);
        PutBucketReplicationRequest.RuleStruct ruleStruct = new PutBucketReplicationRequest.RuleStruct();
        ruleStruct.id = "replication_01"; //用来标注具体 Rule 的名称
        ruleStruct.isEnable = true; //标识 Rule 是否生效 :true, 生效； false, 不生效
        ruleStruct.region = "ap-beijing"; //目标存储桶地域信息
        ruleStruct.bucket = "destinationbucket-1250000000";  // 目标存储桶
        ruleStruct.prefix = "34"; //前缀匹配策略，
        putBucketReplicationRequest.setReplicationConfigurationWithRule(ruleStruct);
        //设置签名校验Host, 默认校验所有Header
        Set<String> headerKeys = new HashSet<>();
        headerKeys.add("Host");
        putBucketReplicationRequest.setSignParamsAndHeaders(null, headerKeys);
        // 使用同步方法
        try {
            PutBucketReplicationResult putBucketReplicationResult = cosXmlService.putBucketReplication(putBucketReplicationRequest);
        } catch (CosXmlClientException e) {
            e.printStackTrace();
        } catch (CosXmlServiceException e) {
            e.printStackTrace();
        }
        // 使用异步回调请求
        cosXmlService.putBucketReplicationAsync(putBucketReplicationRequest, new CosXmlResultListener() {
            @Override
            public void onSuccess(CosXmlRequest request, CosXmlResult result) {
                // todo PUT Bucket replication success
                PutBucketReplicationResult putBucketReplicationResult = (PutBucketReplicationResult)result;
            }
        
            @Override
            public void onFail(CosXmlRequest cosXmlRequest, CosXmlClientException clientException, CosXmlServiceException serviceException)  {
                // todo PUT Bucket replication failed because of CosXmlClientException or CosXmlServiceException...
            }
        });
    }
    private void GetBucketReplication()
    {
        String bucket = "examplebucket-1250000000"; //格式：BucketName-APPID
        GetBucketReplicationRequest getBucketReplicationRequest = new GetBucketReplicationRequest(bucket);
        //设置签名校验Host, 默认校验所有Header
        Set<String> headerKeys = new HashSet<>();
        headerKeys.add("Host");
        getBucketReplicationRequest.setSignParamsAndHeaders(null, headerKeys);
        // 使用同步方法
        try {
            GetBucketReplicationResult getBucketReplicationResult = cosXmlService.getBucketReplication(getBucketReplicationRequest);
        } catch (CosXmlClientException e) {
            e.printStackTrace();
        } catch (CosXmlServiceException e) {
            e.printStackTrace();
        }
        // 使用异步回调请求
        cosXmlService.getBucketReplicationAsync(getBucketReplicationRequest, new CosXmlResultListener() {
            @Override
            public void onSuccess(CosXmlRequest request, CosXmlResult result) {
                // todo GET Bucket replication success
                GetBucketReplicationResult getBucketReplicationResult = (GetBucketReplicationResult)result;
            }
        
            @Override
            public void onFail(CosXmlRequest cosXmlRequest, CosXmlClientException clientException, CosXmlServiceException serviceException)  {
                // todo GET Bucket replication failed because of CosXmlClientException or CosXmlServiceException...
            }
        });
        
    }
    private void DeleteBucketReplication()
    {
        String bucket = "examplebucket-1250000000"; //格式：BucketName-APPID
        DeleteBucketReplicationRequest deleteBucketReplicationRequest = new DeleteBucketReplicationRequest(bucket);
        //设置签名校验Host, 默认校验所有Header
        Set<String> headerKeys = new HashSet<>();
        headerKeys.add("Host");
        deleteBucketReplicationRequest.setSignParamsAndHeaders(null, headerKeys);
        // 使用同步方法
        try {
            DeleteBucketReplicationResult deleteBucketReplicationResult = cosXmlService.deleteBucketReplication(deleteBucketReplicationRequest);
        } catch (CosXmlClientException e) {
            e.printStackTrace();
        } catch (CosXmlServiceException e) {
            e.printStackTrace();
        }
        // 使用异步回调请求
        cosXmlService.deleteBucketReplicationAsync(deleteBucketReplicationRequest, new CosXmlResultListener() {
            @Override
            public void onSuccess(CosXmlRequest request, CosXmlResult result) {
                // todo DELETE Bucket replication success
                DeleteBucketReplicationResult deleteBucketReplicationResult = (DeleteBucketReplicationResult)result;
            }
        
            @Override
            public void onFail(CosXmlRequest cosXmlRequest, CosXmlClientException clientException, CosXmlServiceException serviceException)  {
                // todo DELETE Bucket replication failed because of CosXmlClientException or CosXmlServiceException...
            }
        });
        
    }
    private void GetBucket()
    {
        String bucketName = "examplebucket-1250000000"; //格式：BucketName-APPID;
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
        } catch (CosXmlServiceException e) {
            e.printStackTrace();
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
        
        bucketName = "examplebucket-1250000000";
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
                return;
            } catch (CosXmlServiceException e) {
                e.printStackTrace();
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
        String bucket = "examplebucket-1250000000"; //存储桶，格式：BucketName-APPID
        String cosPath = "exampleobject"; //对象位于存储桶中的位置标识符，即对象键。如 cosPath = "text.txt";
        String srcPath = new File(context.getExternalCacheDir(), "exampleobject").toString();//"本地文件的绝对路径";
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
        } catch (CosXmlServiceException e) {
            e.printStackTrace();
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
        } catch (CosXmlServiceException e) {
            e.printStackTrace();
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
        } catch (CosXmlServiceException e) {
            e.printStackTrace();
        }
        
    }
    private void PostObject()
    {
        String bucket = "examplebucket-1250000000"; //存储桶名称，格式：BucketName-APPID
        String cosPath = "exampleobject"; //对象位于存储桶中的位置标识符，即对象键。如 cosPath = "text.txt";
        String srcPath = new File(context.getExternalCacheDir(), "exampleobject").toString();//"本地文件的绝对路径";
        
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
        } catch (CosXmlServiceException e) {
            e.printStackTrace();
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
    private void HeadObject()
    {
        String bucket = bucket = "examplebucket-1250000000"; //存储桶名称，格式：BucketName-APPID
        String cosPath = "exampleobject"; //对象位于存储桶中的位置标识符，即对象键
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
        } catch (CosXmlServiceException e) {
            e.printStackTrace();
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
        String bucket = "examplebucket-1250000000"; //存储桶名称，格式：BucketName-APPID
        String cosPath = "exampleobject"; //对象位于存储桶中的位置标识符，即对象键
        String savePath = Environment.getExternalStorageDirectory().getPath();//本地路径
        
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
        } catch (CosXmlServiceException e) {
            e.printStackTrace();
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
    private void OptionObject()
    {
        String bucket = "examplebucket-1250000000"; //存储桶名称，格式：BucketName-APPID
        String cosPath = "exampleobject"; //对象位于存储桶中的位置标识符，即对象键
        String origin = "https://cloud.tencent.com";
        String accessMethod = "PUT";
        OptionObjectRequest optionObjectRequest = new OptionObjectRequest(bucket, cosPath, origin, accessMethod);
        //设置签名校验Host, 默认校验所有Header
        Set<String> headerKeys = new HashSet<>();
        headerKeys.add("Host");
        optionObjectRequest.setSignParamsAndHeaders(null, headerKeys);
        // 使用同步方法
        try {
           OptionObjectResult result = cosXmlService.optionObject(optionObjectRequest);
        } catch (CosXmlClientException e) {
            e.printStackTrace();
        } catch (CosXmlServiceException e) {
            e.printStackTrace();
        }
        
        // 使用异步回调请求
        cosXmlService.optionObjectAsync(optionObjectRequest, new CosXmlResultListener() {
            @Override
            public void onSuccess(CosXmlRequest cosXmlRequest, CosXmlResult result) {
                // todo OptionOb Object success...
          OptionObjectResult optionObjectResult  = (OptionObjectResult)result;
            }
        
            @Override
            public void onFail(CosXmlRequest cosXmlRequest, CosXmlClientException clientException, CosXmlServiceException serviceException)  {
                // todo OptionOb Object failed because of CosXmlClientException or CosXmlServiceException...
            }
        });
        
    }
    private void CopyObject()
    {
        String sourceAppid = "1250000000"; //账号 appid
        String sourceBucket = "source-1250000000"; //"源对象所在的存储桶
        String sourceRegion = "ap-guangzhou"; //源对象的存储桶所在的地域
        String sourceCosPath = "sourceObject"; //源对象键
        //构造源对象属性
        CopyObjectRequest.CopySourceStruct copySourceStruct = new CopyObjectRequest.CopySourceStruct(sourceAppid, sourceBucket, sourceRegion, sourceCosPath);
        String bucket = "examplebucket-1250000000"; //存储桶，格式：BucketName-APPID
        String cosPath = "exampleobject"; //对象在存储桶中的位置标识符，即对象键
        
        CopyObjectRequest copyObjectRequest = new CopyObjectRequest(bucket, cosPath, copySourceStruct);
        //设置签名校验Host, 默认校验所有Header
        Set<String> headerKeys = new HashSet<>();
        headerKeys.add("Host");
        copyObjectRequest.setSignParamsAndHeaders(null, headerKeys);
        // 使用同步方法
        try {
            CopyObjectResult copyObjectResult = cosXmlService.copyObject(copyObjectRequest);
        } catch (CosXmlClientException e) {
            e.printStackTrace();
        } catch (CosXmlServiceException e) {
            e.printStackTrace();
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
    private void DeleteObject()
    {
        String bucket = "examplebucket-1250000000"; //存储桶名称，格式：BucketName-APPID
        String cosPath = "exampleobject"; //对象在存储桶中的位置标识符，即对象键
        
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
        } catch (CosXmlServiceException e) {
            e.printStackTrace();
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
        String bucket = "examplebucket-1250000000"; //存储桶，格式：BucketName-APPID
        List<String> objectList = new ArrayList<String>();
        objectList.add("exampleobject");//对象在存储桶中的位置标识符，即对象键
        
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
        } catch (CosXmlServiceException e) {
            e.printStackTrace();
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
    private void ListMultiUpload()
    {
        String bucket = "examplebucket-1250000000"; //格式：BucketName-APPID
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
        } catch (CosXmlServiceException e) {
            e.printStackTrace();
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
    private void InitMultiUpload()
    {
        String bucket = "examplebucket-1250000000"; //格式：BucketName-APPID
        String cosPath = "exampleobject"; //对象在存储桶中的位置标识符，即对象键。 如 cosPath = "text.txt";
        
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
        } catch (CosXmlServiceException e) {
            e.printStackTrace();
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
    private void ListParts()
    {
        String bucket = "examplebucket-1250000000"; //格式：BucketName-APPID
        String cosPath = "exampleobject"; //对象在存储桶中的位置标识符，即对象键。 如 cosPath = "text.txt";
        String uploadId = "example-uploadId";
        
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
        } catch (CosXmlServiceException e) {
            e.printStackTrace();
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
    private void UploadPart()
    {
        String bucket = "examplebucket-1250000000"; //存储桶，格式：BucketName-APPID
        String cosPath = "exampleobject"; //对象在存储桶中的位置标识符，即对象键。
        String uploadId ="example-uploadId"; //初始化分片上传返回的 uploadId
        int partNumber = 1; //分片块编号，必须从1开始递增
        String srcPath = new File(context.getExternalCacheDir(), "exampleobject").toString(); //本地文件绝对路径
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
        } catch (CosXmlServiceException e) {
            e.printStackTrace();
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
    private void UploadPartCopy()
    {
        //具体步骤：
        // 1. 调用 cosXmlService.initMultipartUpload(InitMultipartUploadRequest) 初始化分片,请参考 [InitMultipartUploadRequest 初始化分片](#InitMultipartUploadRequest)。
        // 2. 调用 cosXmlService.copyObject(UploadPartCopyRequest) 完成分片复制。
        // 3. 调用 cosXmlService.completeMultiUpload(CompleteMultiUploadRequest) 完成分片复制,请参考 [CompleteMultiUploadRequest 完成分片复制](#CompleteMultiUploadRequest)。
        
        String sourceAppid = "1250000000"; //账号 appid
        String sourceBucket = "source-1250000000"; //"源对象所在的存储桶
        String sourceRegion = "ap-guangzhou"; //源对象的存储桶所在的地域
        String sourceCosPath = "sourceObject"; //源对象键
        //构造源对象属性
        CopyObjectRequest.CopySourceStruct copySourceStruct = new CopyObjectRequest.CopySourceStruct(sourceAppid, sourceBucket, sourceRegion, sourceCosPath);
        
        String bucket = "examplebucket-1250000000"; //存储桶，格式：BucketName-APPID
        String cosPath = "exampleobject"; //对象在存储桶中的位置标识符，即对象键。
        
        String uploadId = "example-uploadId";
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
            String eTag = uploadPartCopyResult.copyObject.eTag;
        } catch (CosXmlClientException e) {
            e.printStackTrace();
        } catch (CosXmlServiceException e) {
            e.printStackTrace();
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
        String bucket = "examplebucket-1250000000"; //格式：BucketName-APPID
        String cosPath = "exampleobject"; //对象在存储桶中的位置标识符，即对象键。 如 cosPath = "text.txt";
        String uploadId = "example-uploadId";
        int partNumber = 1;
        String etag = "etag";
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
        } catch (CosXmlServiceException e) {
            e.printStackTrace();
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
    private void AbortMultiUpload()
    {
        String bucket = "examplebucket-1250000000"; //格式：BucketName-APPID
        String cosPath = "exampleobject"; //对象在存储桶中的位置标识符，即对象键。 如 cosPath = "text.txt";
        String uploadId = "example-uploadId";
        
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
        } catch (CosXmlServiceException e) {
            e.printStackTrace();
            //
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
    private void RestoreObject()
    {
        String bucket = "examplebucket-1250000000"; //格式：BucketName-APPID
        String cosPath = "exampleobject"; //对象在存储桶中的位置标识符，即对象键。 如 cosPath = "text.txt";
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
        } catch (CosXmlServiceException e) {
            e.printStackTrace();
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
    private void PutObjectAcl()
    {
        String bucket = "examplebucket-1250000000"; //格式：BucketName-APPID
        String cosPath = "exampleobject"; //对象在存储桶中的位置标识符，即对象键。 如 cosPath = "text.txt";
        PutObjectACLRequest putObjectACLRequest = new PutObjectACLRequest(bucket, cosPath);
        
        //设置 bucket 访问权限
        putObjectACLRequest.setXCOSACL("public-read");
        
        //赋予被授权者读的权限
        ACLAccount readACLS = new ACLAccount();
        readACLS.addAccount("100000000001", "100000000001");
        putObjectACLRequest.setXCOSGrantRead(readACLS);
        
        //赋予被授权者读写的权限
        ACLAccount writeandReadACLS = new ACLAccount();
        writeandReadACLS.addAccount("100000000001", "100000000001");
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
        } catch (CosXmlServiceException e) {
            e.printStackTrace();
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
        String bucket = "examplebucket-1250000000"; //格式：BucketName-APPID
        String cosPath = "exampleobject"; //对象在存储桶中的位置标识符，即对象键。 如 cosPath = "text.txt";
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
        } catch (CosXmlServiceException e) {
            e.printStackTrace();
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
    private void TransferUploadObject()
    {
        // 初始化 TransferConfig
        TransferConfig transferConfig = new TransferConfig.Builder().build();
        
        /*若有特殊要求，则可以如下进行初始化定制。如限定当对象 >= 2M 时，启用分片上传，且分片上传的分片大小为 1M, 当源对象大于 5M 时启用分片复制，且分片复制的大小为 5M。*/
        transferConfig = new TransferConfig.Builder()
                .setDividsionForCopy(5 * 1024 * 1024) // 是否启用分片复制的最小对象大小
                .setSliceSizeForCopy(5 * 1024 * 1024) //分片复制时的分片大小
                .setDivisionForUpload(2 * 1024 * 1024) // 是否启用分片上传的最小对象大小
                .setSliceSizeForUpload(1024 * 1024) //分片上传时的分片大小
                .build();
        
        //初始化 TransferManager
        TransferManager transferManager = new TransferManager(cosXmlService, transferConfig);
        
        String bucket = "examplebucket-1250000000"; //存储桶，格式：BucketName-APPID
        String cosPath = "exampleobject"; //对象在存储桶中的位置标识符，即称对象键
        String srcPath = new File(context.getExternalCacheDir(), "exampleobject").toString();//"本地文件的绝对路径";
        String uploadId = null; //若存在初始化分片上传的 UploadId，则赋值对应的uploadId值用于续传;否则，赋值null。
        //上传对象
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
         putObjectRequest.setNeedMD5(true); //是否启用Md5校验
         COSXMLUploadTask cosxmlUploadTask = transferManager.upload(putObjectRequest, uploadId);
        */
        
        //取消上传
        cosxmlUploadTask.cancel();
        
        
        //暂停上传
        cosxmlUploadTask.pause();
        
        //恢复上传
        cosxmlUploadTask.resume();
        
    }
    private void TransferDownloadObject()
    {
        Context applicationContext = context.getApplicationContext(); // application context
        String bucket = "examplebucket-1250000000"; //存储桶，格式：BucketName-APPID
        String cosPath = "exampleobject"; //对象在存储桶中的位置标识符，即称对象键
        String savePathDir = Environment.getExternalStorageDirectory().getPath();//本地目录路径
        String savedFileName = "exampleobject";//本地保存的文件名，若不填（null）,则与cos上的文件名一样
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
        //设置任务状态回调, 可以查看任务过程
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
    private void TransferCopyObject()
    {
        String sourceAppid = ""; //账号 appid
        String sourceBucket = "source-1250000000"; //"源对象所在的存储桶
        String sourceRegion = "ap-guangzhou"; //源对象的存储桶所在的地域
        String sourceCosPath = ""; //源对象的对象键
        //构造源对象属性
        CopyObjectRequest.CopySourceStruct copySourceStruct = new CopyObjectRequest.CopySourceStruct(sourceAppid, sourceBucket, sourceRegion, sourceCosPath);
        
        String bucket = "examplebucket-1250000000"; //存储桶，格式：BucketName-APPID
        String cosPath = "exampleobject"; //对象在存储桶中的位置标识符，即对象键。
        
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
    private void GetPresignUploadUrl()
    {
        try {
        
         String bucket = "examplebucket-1250000000"; //存储桶名称
         String cosPath = "exampleobject"; //即对象在存储桶中的位置标识符。如 cosPath = "text.txt";
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
        
         String srcPath = new File(context.getExternalCacheDir(), "exampleobject").toString();
         PutObjectRequest putObjectRequest = new PutObjectRequest("examplebucket-1250000000", "exampleobject", srcPath);
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
        } catch (CosXmlServiceException e) {
         e.printStackTrace();
        }
        
    }
    private void GetPresignDownloadUrl()
    {
        try {
            String bucket = "examplebucket-1250000000"; //存储桶名称
            String cosPath = "exampleobject"; //即对象在存储桶中的位置标识符。如 cosPath = "text.txt";
            String method = "GET"; //请求 HTTP 方法.
            PresignedUrlRequest presignedUrlRequest = new PresignedUrlRequest(bucket, cosPath);
            presignedUrlRequest.setRequestMethod(method);
        
            String urlWithSign = cosXmlService.getPresignedURL(presignedUrlRequest); //上传预签名 URL (使用永久密钥方式计算的签名 URL )
        
            //String urlWithSign = cosXmlService.getPresignedURL(getObjectRequest)； //直接使用 GetObjectRequest
        
            String savePath = Environment.getExternalStorageDirectory().getPath(); //本地路径
            String saveFileName = "exampleobject"; //本地文件名
            GetObjectRequest getObjectRequest = new GetObjectRequest("examplebucket-1250000000", "exampleobject", savePath, saveFileName);
        
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
        } catch (CosXmlServiceException e) {
            e.printStackTrace();
        }
        
    }


    @Test public void testSnippetEverything() {
    }
}
