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
public class TransferDownloadObject {

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


    private void TransferDownloadObject()
    {
        Context applicationContext = context.getApplicationContext(); // application context
        String bucket = "bucket-cssg-test-1253653367"; //存储桶，格式：BucketName-APPID
        String cosPath = "object4android"; //对象在存储桶中的位置标识符，即称对象键
        String savePathDir = context.getExternalCacheDir().toString(); //本地目录路径
        String savedFileName = "object4android";//本地保存的文件名，若不填（null），则与 COS 上的文件名一样
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
                    assertError(serviceException);assertError(exception);
                        Log.d("TEST",  "Failed: " + (exception == null ? serviceException.getMessage() : exception.toString()));
                    }
                });
        //设置任务状态回调，可以查看任务过程
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

    private void initService() {
        context = InstrumentationRegistry.getInstrumentation().getTargetContext();
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
    }

    @Before public void setUp() {
        initService();
    }

    @After public void tearDown() {
    }

    @Test public void testTransferDownloadObject() {
        TransferDownloadObject();
    }
}
