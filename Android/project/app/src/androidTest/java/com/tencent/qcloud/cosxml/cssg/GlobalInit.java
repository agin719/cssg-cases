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
public class GlobalInit {

    private static Context context;

    private static void assertError(Exception e) {
        throw new RuntimeException(e.getMessage());
    }

    @BeforeClass public static void setUp() {
        context = InstrumentationRegistry.getInstrumentation().getTargetContext();
        
    }

    @AfterClass public static void tearDown() {
        
    }

    public void GlobalInit()
    {
        String region = "存储桶所在的地域";
        
        CosXmlServiceConfig serviceConfig = new CosXmlServiceConfig.Builder()
                .setRegion(region)
             .isHttps(true) // 使用 https 请求, 默认 http 请求
                .builder();
        
        /**
         * 获取授权服务的 url 地址
         */
        URL url = null; // 后台授权服务的 url 地址
        try {
            url = new URL("your_auth_server_url");
        } catch (MalformedURLException e) {
            e.printStackTrace();
            return;
        }
        
        /**
         * 初始化 {@link QCloudCredentialProvider} 对象，来给 SDK 提供临时密钥。
         */
        QCloudCredentialProvider credentialProvider = new SessionCredentialProvider(new HttpRequest.Builder<String>()
                .url(url)
                .method("GET")
                .build());
        
        CosXmlService cosXmlService = new CosXmlService(context, serviceConfig, credentialProvider);
    }

    @Test public void testGlobalInit() {
      GlobalInit();
    }
}
