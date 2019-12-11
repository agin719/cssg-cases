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
public class BucketTest {


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

    public BucketTest() {
        super();
        context = InstrumentationRegistry.getInstrumentation().getTargetContext();
    }


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
    private void getBucket()
    {
        String bucketName = "bucket-cssg-test-android-1253653367"; //格式：BucketName-APPID;
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
        
        if (true) {return;}
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
        
        bucketName = "bucket-cssg-test-android-1253653367";
        getBucketRequest = new GetBucketRequest(bucketName);
        
        // prefix 表示列出的 object 的 key 以 prefix 开始
        getBucketRequest.setPrefix("images/");
        // delimiter 表示分隔符，设置为 / 表示列出当前目录下的 object, 设置为空表示列出所有的 object
        getBucketRequest.setDelimiter("/");
        // 设置最大遍历出多少个对象，一次 listobject 最大支持1000
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
            // commonPrefixs 表示表示被 delimiter 截断的路径，例如 delimter 设置为 /，commonPrefixs 则表示子目录的路径
            List<ListBucket.CommonPrefixes> commonPrefixs = getBucketResult.listBucket.commonPrefixesList;
        
            // contents 表示列出的 object 列表
            List<ListBucket.Contents> contents = getBucketResult.listBucket.contentsList;
        
            String nextMarker = getBucketResult.listBucket.nextMarker;
            getBucketRequest.setMarker(nextMarker);
        } while (getBucketResult.listBucket.isTruncated);
        
    }
    private void headBucket()
    {
        String bucket = "bucket-cssg-test-android-1253653367"; //格式：BucketName-APPID
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
        
        if (true) {return;}
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
    private void putBucketAcl()
    {
        String bucket = "bucket-cssg-test-android-1253653367"; //格式：BucketName-APPID
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
        
        if (true) {return;}
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
    private void getBucketAcl()
    {
        String bucket = "bucket-cssg-test-android-1253653367"; //格式：BucketName-APPID
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
        
        if (true) {return;}
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
    private void putBucketCors()
    {
        String bucket = "bucket-cssg-test-android-1253653367"; //格式：BucketName-APPID
        PutBucketCORSRequest putBucketCORSRequest = new PutBucketCORSRequest(bucket);
        
        /**
         * CORSConfiguration.cORSRule: 跨域访问配置信息
         * corsRule.id： 配置规则的 ID
         * corsRule.allowedOrigin: 允许的访问来源，支持通配符 *，格式为：协议://域名[:端口]，例如：http://www.qq.com
         * corsRule.maxAgeSeconds: 设置 OPTIONS 请求得到结果的有效期
         * corsRule.allowedMethod: 允许的 HTTP 操作，例如：GET，PUT，HEAD，POST，DELETE
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
        
        // 设置跨域访问配置信息
        putBucketCORSRequest.addCORSRule(corsRule);
        
        // 设置签名校验 Host，默认校验所有 Header
        Set<String> headerKeys = new HashSet<>();
        headerKeys.add("Host");
        putBucketCORSRequest.setSignParamsAndHeaders(null, headerKeys);
        
        // 使用同步方法
        try {
            PutBucketCORSResult putBucketCORSResult = cosXmlService.putBucketCORS(putBucketCORSRequest);
        } catch (CosXmlClientException e) {
            e.printStackTrace();
            assertError(e);
        } catch (CosXmlServiceException e) {
            e.printStackTrace();
            assertError(e);
        }
        
        if (true) {return;}
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
    private void getBucketCors()
    {
        String bucket = "bucket-cssg-test-android-1253653367"; //格式：BucketName-APPID
        GetBucketCORSRequest getBucketCORSRequest = new GetBucketCORSRequest(bucket);
        // 设置签名校验 Host，默认校验所有 Header
        Set<String> headerKeys = new HashSet<>();
        headerKeys.add("Host");
        getBucketCORSRequest.setSignParamsAndHeaders(null, headerKeys);
        // 使用同步方法
        try {
            GetBucketCORSResult getBucketCORSResult = cosXmlService.getBucketCORS(getBucketCORSRequest);
        } catch (CosXmlClientException e) {
            e.printStackTrace();
            assertError(e);
        } catch (CosXmlServiceException e) {
            e.printStackTrace();
            assertError(e);
        }
        
        if (true) {return;}
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
    private void optionObject()
    {
        String bucket = "bucket-cssg-test-android-1253653367"; //存储桶名称，格式：BucketName-APPID
        String cosPath = "object4android"; //对象位于存储桶中的位置标识符，即对象键
        String origin = "https://cloud.tencent.com";
        String accessMethod = "PUT";
        OptionObjectRequest optionObjectRequest = new OptionObjectRequest(bucket, cosPath, origin, accessMethod);
        // 设置签名校验 Host，默认校验所有 Header
        Set<String> headerKeys = new HashSet<>();
        headerKeys.add("Host");
        optionObjectRequest.setSignParamsAndHeaders(null, headerKeys);
        // 使用同步方法
        try {
           OptionObjectResult result = cosXmlService.optionObject(optionObjectRequest);
        } catch (CosXmlClientException e) {
            e.printStackTrace();
            assertError(e);
        } catch (CosXmlServiceException e) {
            e.printStackTrace();
            assertError(e);
        }
        
        if (true) {return;}
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
    private void deleteBucketCors()
    {
        String bucket = "bucket-cssg-test-android-1253653367"; //格式：BucketName-APPID
        DeleteBucketCORSRequest deleteBucketCORSRequest = new DeleteBucketCORSRequest(bucket);
        // 设置签名校验 Host，默认校验所有 Header
        Set<String> headerKeys = new HashSet<>();
        headerKeys.add("Host");
        deleteBucketCORSRequest.setSignParamsAndHeaders(null, headerKeys);
        // 使用同步方法
        try {
            DeleteBucketCORSResult deleteBucketCORSResult = cosXmlService.deleteBucketCORS(deleteBucketCORSRequest);
        } catch (CosXmlClientException e) {
            e.printStackTrace();
            assertError(e);
        } catch (CosXmlServiceException e) {
            e.printStackTrace();
            assertError(e);
        }
        
        if (true) {return;}
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
    private void putBucketLifecycle()
    {
        String bucket = "bucket-cssg-test-android-1253653367"; //格式：BucketName-APPID
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
        // 设置签名校验 Host，默认校验所有 Header
        Set<String> headerKeys = new HashSet<>();
        headerKeys.add("Host");
        putBucketLifecycleRequest.setSignParamsAndHeaders(null, headerKeys);
        // 使用同步方法
        try {
            PutBucketLifecycleResult putBucketLifecycleResult = cosXmlService.putBucketLifecycle(putBucketLifecycleRequest);
        } catch (CosXmlClientException e) {
            e.printStackTrace();
            assertError(e);
        } catch (CosXmlServiceException e) {
            e.printStackTrace();
            assertError(e);
        }
        
        if (true) {return;}
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
    private void getBucketLifecycle()
    {
        String bucket = "bucket-cssg-test-android-1253653367"; //格式：BucketName-APPID
        GetBucketLifecycleRequest getBucketLifecycleRequest = new GetBucketLifecycleRequest(bucket);
        // 设置签名校验 Host，默认校验所有 Header
        Set<String> headerKeys = new HashSet<>();
        headerKeys.add("Host");
        getBucketLifecycleRequest.setSignParamsAndHeaders(null, headerKeys);
        // 使用同步方法
        try {
            GetBucketLifecycleResult getBucketLifecycleResult = cosXmlService.getBucketLifecycle(getBucketLifecycleRequest);
        } catch (CosXmlClientException e) {
            e.printStackTrace();
            assertError(e);
        } catch (CosXmlServiceException e) {
            e.printStackTrace();
            assertError(e);
        }
        
        if (true) {return;}
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
    private void deleteBucketLifecycle()
    {
        String bucket = "bucket-cssg-test-android-1253653367"; //格式：BucketName-APPID
        DeleteBucketLifecycleRequest deleteBucketLifecycleRequest = new DeleteBucketLifecycleRequest(bucket);
        // 设置签名校验 Host，默认校验所有 Header
        Set<String> headerKeys = new HashSet<>();
        headerKeys.add("Host");
        deleteBucketLifecycleRequest.setSignParamsAndHeaders(null, headerKeys);
        // 使用同步方法
        try {
            DeleteBucketLifecycleResult deleteBucketLifecycleResult = cosXmlService.deleteBucketLifecycle(deleteBucketLifecycleRequest);
        
        } catch (CosXmlClientException e) {
            e.printStackTrace();
            assertError(e);
        } catch (CosXmlServiceException e) {
            e.printStackTrace();
            assertError(e);
        }
        
        if (true) {return;}
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
    private void putBucketVersioning()
    {
        String bucket = "bucket-cssg-test-android-1253653367"; //格式：BucketName-APPID
        PutBucketVersioningRequest putBucketVersioningRequest = new PutBucketVersioningRequest(bucket);
        putBucketVersioningRequest.setEnableVersion(true); //true：开启版本控制; false：暂停版本控制
        // 设置签名校验 Host，默认校验所有 Header
        Set<String> headerKeys = new HashSet<>();
        headerKeys.add("Host");
        putBucketVersioningRequest.setSignParamsAndHeaders(null, headerKeys);
        // 使用同步方法
        try {
            PutBucketVersioningResult putBucketVersioningResult = cosXmlService.putBucketVersioning(putBucketVersioningRequest);
        } catch (CosXmlClientException e) {
            e.printStackTrace();
            assertError(e);
        } catch (CosXmlServiceException e) {
            e.printStackTrace();
            assertError(e);
        }
        if (true) {return;}
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
    private void getBucketVersioning()
    {
        String bucket = "bucket-cssg-test-android-1253653367"; //格式：BucketName-APPID
        GetBucketVersioningRequest getBucketVersioningRequest = new GetBucketVersioningRequest(bucket);
        // 设置签名校验 Host，默认校验所有 Header
        Set<String> headerKeys = new HashSet<>();
        headerKeys.add("Host");
        getBucketVersioningRequest.setSignParamsAndHeaders(null, headerKeys);
        // 使用同步方法
        try {
            GetBucketVersioningResult getBucketVersioningResult = cosXmlService.getBucketVersioning(getBucketVersioningRequest);
        } catch (CosXmlClientException e) {
            e.printStackTrace();
            assertError(e);
        } catch (CosXmlServiceException e) {
            e.printStackTrace();
            assertError(e);
        }
        if (true) {return;}
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
    private void putBucketReplication()
    {
        String bucket = "bucket-cssg-test-android-1253653367"; //格式：BucketName-APPID
        String ownerUin = "1278687956"; //发起者身份标示：OwnerUin
        String subUin = "1278687956"; //发起者身份标示：SubUin
        PutBucketReplicationRequest putBucketReplicationRequest = new PutBucketReplicationRequest(bucket);
        putBucketReplicationRequest.setReplicationConfigurationWithRole(ownerUin, subUin);
        PutBucketReplicationRequest.RuleStruct ruleStruct = new PutBucketReplicationRequest.RuleStruct();
        ruleStruct.id = "replication_01"; //用来标注具体 Rule 的名称
        ruleStruct.isEnable = true; //标识 Rule 是否生效。true：生效；false：不生效
        ruleStruct.region = "ap-beijing"; //目标存储桶地域信息
        ruleStruct.bucket = "bucket-cssg-assist-1253653367";  // 目标存储桶
        ruleStruct.prefix = "34"; //前缀匹配策略，
        putBucketReplicationRequest.setReplicationConfigurationWithRule(ruleStruct);
        // 设置签名校验 Host，默认校验所有 Header
        Set<String> headerKeys = new HashSet<>();
        headerKeys.add("Host");
        putBucketReplicationRequest.setSignParamsAndHeaders(null, headerKeys);
        // 使用同步方法
        try {
            PutBucketReplicationResult putBucketReplicationResult = cosXmlService.putBucketReplication(putBucketReplicationRequest);
        } catch (CosXmlClientException e) {
            e.printStackTrace();
            assertError(e);
        } catch (CosXmlServiceException e) {
            e.printStackTrace();
            assertError(e);
        }
        if (true) {return;}
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
    private void getBucketReplication()
    {
        String bucket = "bucket-cssg-test-android-1253653367"; //格式：BucketName-APPID
        GetBucketReplicationRequest getBucketReplicationRequest = new GetBucketReplicationRequest(bucket);
        //设置签名校验 Host，默认校验所有 Header
        Set<String> headerKeys = new HashSet<>();
        headerKeys.add("Host");
        getBucketReplicationRequest.setSignParamsAndHeaders(null, headerKeys);
        // 使用同步方法
        try {
            GetBucketReplicationResult getBucketReplicationResult = cosXmlService.getBucketReplication(getBucketReplicationRequest);
        } catch (CosXmlClientException e) {
            e.printStackTrace();
            assertError(e);
        } catch (CosXmlServiceException e) {
            e.printStackTrace();
            assertError(e);
        }
        if (true) {return;}
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
    private void deleteBucketReplication()
    {
        String bucket = "bucket-cssg-test-android-1253653367"; //格式：BucketName-APPID
        DeleteBucketReplicationRequest deleteBucketReplicationRequest = new DeleteBucketReplicationRequest(bucket);
        // 设置签名校验 Host，默认校验所有 Header
        Set<String> headerKeys = new HashSet<>();
        headerKeys.add("Host");
        deleteBucketReplicationRequest.setSignParamsAndHeaders(null, headerKeys);
        // 使用同步方法
        try {
            DeleteBucketReplicationResult deleteBucketReplicationResult = cosXmlService.deleteBucketReplication(deleteBucketReplicationRequest);
        } catch (CosXmlClientException e) {
            e.printStackTrace();
            assertError(e);
        } catch (CosXmlServiceException e) {
            e.printStackTrace();
            assertError(e);
        }
        if (true) {return;}
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
        deleteBucket();
    }

    @Test public void testBucketACL() {
        getBucket();
        headBucket();
        putBucketAcl();
        getBucketAcl();
    }
    @Test public void testBucketCORS() {
        putBucketCors();
        getBucketCors();
        optionObject();
        deleteBucketCors();
    }
    @Test public void testBucketLifecycle() {
        putBucketLifecycle();
        getBucketLifecycle();
        deleteBucketLifecycle();
    }
    @Test public void testBucketReplicationAndVersioning() {
        putBucketVersioning();
        getBucketVersioning();
        putBucketReplication();
        getBucketReplication();
        deleteBucketReplication();
    }
}
