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
public class TransferCopyObject {

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

    private void TransferCopyObject()
    {
        String sourceAppid = ""; //账号 APPID
        String sourceBucket = "bucket-cssg-test-1253653367"; //源对象所在的存储桶
        String sourceRegion = "ap-guangzhou"; //源对象的存储桶所在的地域
        String sourceCosPath = ""; //源对象的对象键
        //构造源对象属性
        CopyObjectRequest.CopySourceStruct copySourceStruct = new CopyObjectRequest.CopySourceStruct(sourceAppid, sourceBucket, sourceRegion, sourceCosPath);
        
        String bucket = "bucket-cssg-test-1253653367"; //存储桶，格式：BucketName-APPID
        String cosPath = "object4android"; //对象在存储桶中的位置标识符，即对象键
        
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

    @Test public void testTransferCopyObject() {
        TransferCopyObject();
    }
}
