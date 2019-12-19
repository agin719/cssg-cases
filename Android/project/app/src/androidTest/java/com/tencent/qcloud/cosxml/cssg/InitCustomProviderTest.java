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
public class InitCustomProviderTest {

        //.cssg-snippet-body-start:[global-init-custom-provider]
        public static class MyCredentialProvider extends BasicLifecycleCredentialProvider {
        
            @Override
            protected QCloudLifecycleCredentials fetchNewCredentials() throws QCloudClientException {
        
                // 首先从您的临时密钥服务器获取包含了签名信息的响应
        
                // 然后解析响应，获取密钥信息
                String tmpSecretId = BuildConfig.COS_SECRET_ID; //临时密钥 secretId
                String tmpSecretKey = BuildConfig.COS_SECRET_KEY; //临时密钥 secretKey
                String sessionToken = "TOKEN"; //临时密钥 Token
                long expiredTime = 1556183496L;//临时密钥有效截止时间戳，单位是秒
        
                // 返回服务器时间作为签名的起始时间
                long beginTime = 1556182000L; //临时密钥有效起始时间，单位是秒
        
                // todo something you want
        
                // 最后返回临时密钥信息对象
                return new SessionQCloudCredentials(tmpSecretId, tmpSecretKey, sessionToken, beginTime, expiredTime);
            }
        }
        //.cssg-snippet-body-end

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

    public InitCustomProviderTest() {
        super();
        context = InstrumentationRegistry.getInstrumentation().getTargetContext();
    }




    @Test public void testInitCustomProvider() {
    }
}
