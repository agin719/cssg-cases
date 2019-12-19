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
public class ServiceTest {


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

    public ServiceTest() {
        super();
        context = InstrumentationRegistry.getInstrumentation().getTargetContext();
    }


    private void getService()
    {
        //.cssg-snippet-body-start:[get-service]
        GetServiceRequest getServiceRequest = new GetServiceRequest();
        // 设置签名校验 Host，默认校验所有 Header
        Set<String> headerKeys = new HashSet<>();
        headerKeys.add("Host");
        getServiceRequest.setSignParamsAndHeaders(null, headerKeys);
        // 使用同步方法
        try {
            GetServiceResult result = cosXmlService.getService(getServiceRequest);
        } catch (CosXmlClientException e) {
            e.printStackTrace();
            assertError(e);
        } catch (CosXmlServiceException e) {
            e.printStackTrace();
            assertError(e);
        }
        
        if (true) {return;}
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
        //.cssg-snippet-body-end
    }

    private void initService() {
        //.cssg-snippet-body-start:[global-init-secret]
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
        //.cssg-snippet-body-end
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
    }

    @After public void tearDown() {
    }

    @Test public void testGetService() {
        getService();
    }
}
