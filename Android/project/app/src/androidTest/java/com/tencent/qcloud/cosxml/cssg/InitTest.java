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
public class InitTest {


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

    public InitTest() {
        super();
        context = InstrumentationRegistry.getInstrumentation().getTargetContext();
    }


    private void globalInit()
    {
        //.cssg-snippet-body-start:[global-init]
        String region = "ap-guangzhou";
        
        CosXmlServiceConfig serviceConfig = new CosXmlServiceConfig.Builder()
                .setRegion(region)
             .isHttps(true) // 使用 HTTPS 请求，默认为 HTTP 请求
                .builder();
        
        URL url = null;
        try {
            // URL 是后台临时密钥服务的地址，如何搭建服务请参考（https://cloud.tencent.com/document/product/436/14048）
            url = new URL("https://your_auth_server_url");
        } catch (MalformedURLException e) {
            e.printStackTrace();
            assertError(e);
            return;
        }
        
        /**
         * 初始化 {@link QCloudCredentialProvider} 对象，来给 SDK 提供临时密钥
         */
        QCloudCredentialProvider credentialProvider = new SessionCredentialProvider(new HttpRequest.Builder<String>()
                .url(url)
                .method("GET")
                .build());
        
        CosXmlService cosXmlService = new CosXmlService(context, serviceConfig, credentialProvider);
        //.cssg-snippet-body-end
    }
    private void globalInitCustom()
    {
        //.cssg-snippet-body-start:[global-init-custom]
        String region = "ap-guangzhou";
        
        // 创建 CosXmlServiceConfig 对象，根据需要修改默认的配置参数
        CosXmlServiceConfig serviceConfig = new CosXmlServiceConfig.Builder()
               .setRegion(region)
            .isHttps(true) // 使用 HTTPS 请求, 默认为 HTTP 请求
               .builder();
        
        /**
         * 初始化 {@link QCloudCredentialProvider} 对象，来给 SDK 提供临时密钥
         */
        QCloudCredentialProvider credentialProvider = new MyCredentialProvider();
        
        CosXmlService cosXmlService = new CosXmlService(context, serviceConfig, credentialProvider);
        //.cssg-snippet-body-end
    }


    @Test public void testInitService() {
        globalInit();
    }
    @Test public void testInitCustom() {
        globalInitCustom();
    }
}
