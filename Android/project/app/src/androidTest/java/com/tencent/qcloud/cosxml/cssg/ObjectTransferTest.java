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
import com.tencent.qcloud.cosxml.cssg.GlobalInitCustomProviderTest.MyCredentialProvider;

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
public class ObjectTransferTest {

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

    public ObjectTransferTest() {
        super();
        context = InstrumentationRegistry.getInstrumentation().getTargetContext();
    }

    private String uploadId;
    private String eTag;

    private void PutBucket()
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
    private void InitMultiUpload()
    {
        String bucket = "bucket-cssg-test-android-1253653367"; //格式：BucketName-APPID
        String cosPath = "object4android"; //对象在存储桶中的位置标识符，即对象键。 例如 cosPath = "text.txt";
        
        InitMultipartUploadRequest initMultipartUploadRequest = new InitMultipartUploadRequest(bucket, cosPath);
        // 设置签名校验 Host，默认校验所有 Header
        Set<String> headerKeys = new HashSet<>();
        headerKeys.add("Host");
        initMultipartUploadRequest.setSignParamsAndHeaders(null, headerKeys);
        // 使用同步方法请求
        try {
            InitMultipartUploadResult initMultipartUploadResult = cosXmlService.initMultipartUpload(initMultipartUploadRequest);
            uploadId =initMultipartUploadResult.initMultipartUpload.uploadId;
        } catch (CosXmlClientException e) {
            e.printStackTrace();
            assertError(e);
        } catch (CosXmlServiceException e) {
            e.printStackTrace();
            assertError(e);
        }
        
        if (true) {return;}
        // 使用异步回调请求
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
    private void ListMultiUpload()
    {
        String bucket = "bucket-cssg-test-android-1253653367"; //格式：BucketName-APPID
        ListMultiUploadsRequest listMultiUploadsRequest = new ListMultiUploadsRequest(bucket);
        // 设置签名校验 Host，默认校验所有 Header
        Set<String> headerKeys = new HashSet<>();
        headerKeys.add("Host");
        listMultiUploadsRequest.setSignParamsAndHeaders(null, headerKeys);
        try {
         // 使用同步方法
            ListMultiUploadsResult listMultiUploadsResult = cosXmlService.listMultiUploads(listMultiUploadsRequest);
        } catch (CosXmlClientException e) {
            e.printStackTrace();
            assertError(e);
        } catch (CosXmlServiceException e) {
            e.printStackTrace();
            assertError(e);
        }
        
        if (true) {return;}
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
    private void UploadPart()
    {
        String bucket = "bucket-cssg-test-android-1253653367"; //存储桶，格式：BucketName-APPID
        String cosPath = "object4android"; //对象在存储桶中的位置标识符，即对象键
        String uploadId =this.uploadId; //初始化分块上传返回的 uploadId
        int partNumber = 1; //分块块编号，必须从1开始递增
        String srcPath = new File(context.getExternalCacheDir(), "object4android").toString(); //本地文件绝对路径
        UploadPartRequest uploadPartRequest = new UploadPartRequest(bucket, cosPath, partNumber, srcPath, uploadId);
        
        uploadPartRequest.setProgressListener(new CosXmlProgressListener() {
            @Override
            public void onProgress(long progress, long max) {
                float result = (float) (progress * 100.0/max);
                Log.w("TEST","progress =" + (long)result + "%");
            }
        });
        // 设置签名校验 Host，默认校验所有 Header
        Set<String> headerKeys = new HashSet<>();
        headerKeys.add("Host");
        uploadPartRequest.setSignParamsAndHeaders(null, headerKeys);
        //使用同步方法上传
        try {
            UploadPartResult uploadPartResult = cosXmlService.uploadPart(uploadPartRequest);
            eTag = uploadPartResult.eTag; //获取分块块的 eTag
        } catch (CosXmlClientException e) {
            e.printStackTrace();
            assertError(e);
        } catch (CosXmlServiceException e) {
            e.printStackTrace();
            assertError(e);
        }
        
        
        if (true) {return;}
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
    private void ListParts()
    {
        String bucket = "bucket-cssg-test-android-1253653367"; //格式：BucketName-APPID
        String cosPath = "object4android"; //对象在存储桶中的位置标识符，即对象键。 例如 cosPath = "text.txt";
        String uploadId = this.uploadId;
        
        ListPartsRequest listPartsRequest = new ListPartsRequest(bucket, cosPath, uploadId);
        // 设置签名校验 Host，默认校验所有 Header
        Set<String> headerKeys = new HashSet<>();
        headerKeys.add("Host");
        listPartsRequest.setSignParamsAndHeaders(null, headerKeys);
        // 使用同步方法请求
        try {
            ListPartsResult listPartsResult = cosXmlService.listParts(listPartsRequest);
            ListParts listParts = listPartsResult.listParts;
        } catch (CosXmlClientException e) {
            e.printStackTrace();
            assertError(e);
        } catch (CosXmlServiceException e) {
            e.printStackTrace();
            assertError(e);
        }
        
        if (true) {return;}
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
    private void CompleteMultiUpload()
    {
        String bucket = "bucket-cssg-test-android-1253653367"; //格式：BucketName-APPID
        String cosPath = "object4android"; //对象在存储桶中的位置标识符，即对象键。 例如 cosPath = "text.txt";
        String uploadId = this.uploadId;
        int partNumber = 1;
        String etag = this.eTag;
        Map<Integer, String> partNumberAndETag = new HashMap<>();
        partNumberAndETag.put(partNumber, etag);
        
        CompleteMultiUploadRequest completeMultiUploadRequest = new CompleteMultiUploadRequest(bucket, cosPath, uploadId, partNumberAndETag);
        // 设置签名校验 Host，默认校验所有 Header
        Set<String> headerKeys = new HashSet<>();
        headerKeys.add("Host");
        completeMultiUploadRequest.setSignParamsAndHeaders(null, headerKeys);
        // 使用同步方法请求
        try {
            CompleteMultiUploadResult completeMultiUploadResult = cosXmlService.completeMultiUpload(completeMultiUploadRequest);
        } catch (CosXmlClientException e) {
            e.printStackTrace();
            assertError(e);
        } catch (CosXmlServiceException e) {
            e.printStackTrace();
            assertError(e);
        }
        
        if (true) {return;}
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
        String bucket = "bucket-cssg-test-android-1253653367"; //格式：BucketName-APPID
        String cosPath = "object4android"; //对象在存储桶中的位置标识符，即对象键。 例如 cosPath = "text.txt";
        String uploadId = this.uploadId;
        
        AbortMultiUploadRequest abortMultiUploadRequest = new AbortMultiUploadRequest(bucket, cosPath, uploadId);
        // 设置签名校验 Host，默认校验所有 Header
        Set<String> headerKeys = new HashSet<>();
        headerKeys.add("Host");
        abortMultiUploadRequest.setSignParamsAndHeaders(null, headerKeys);
        // 使用同步方法请求
        try {
            AbortMultiUploadResult abortMultiUploadResult = cosXmlService.abortMultiUpload(abortMultiUploadRequest);
        } catch (CosXmlClientException e) {
            e.printStackTrace();
            assertError(e);
        } catch (CosXmlServiceException e) {
            e.printStackTrace();
            assertError(e);
            //
        }
        
        if (true) {return;}
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
    private void TransferUploadObject()
    {
        // 初始化 TransferConfig
        TransferConfig transferConfig = new TransferConfig.Builder().build();
        
        /*若有特殊要求，则可以如下进行初始化定制。例如限定当对象 >= 2M 时，启用分块上传，且分块上传的分块大小为1M，当源对象大于5M时启用分块复制，且分块复制的大小为5M。*/
        transferConfig = new TransferConfig.Builder()
                .setDividsionForCopy(5 * 1024 * 1024) // 是否启用分块复制的最小对象大小
                .setSliceSizeForCopy(5 * 1024 * 1024) // 分块复制时的分块大小
                .setDivisionForUpload(2 * 1024 * 1024) // 是否启用分块上传的最小对象大小
                .setSliceSizeForUpload(1024 * 1024) // 分块上传时的分块大小
                .build();
        
        // 初始化 TransferManager
        TransferManager transferManager = new TransferManager(cosXmlService, transferConfig);
        
        String bucket = "bucket-cssg-test-android-1253653367"; //存储桶，格式：BucketName-APPID
        String cosPath = "object4android"; //对象在存储桶中的位置标识符，即称对象键
        String srcPath = new File(context.getExternalCacheDir(), "object4android").toString(); //本地文件的绝对路径
        String uploadId = null; //若存在初始化分块上传的 UploadId，则赋值对应的 uploadId 值用于续传；否则，赋值 null
        // 上传对象
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
         putObjectRequest.setNeedMD5(true); //是否启用 Md5 校验
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
        String bucket = "bucket-cssg-test-android-1253653367"; //存储桶，格式：BucketName-APPID
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
    private void TransferCopyObject()
    {
        String sourceAppid = ""; //账号 APPID
        String sourceBucket = "bucket-cssg-source-1253653367"; //源对象所在的存储桶
        String sourceRegion = "ap-guangzhou"; //源对象的存储桶所在的地域
        String sourceCosPath = ""; //源对象的对象键
        //构造源对象属性
        CopyObjectRequest.CopySourceStruct copySourceStruct = new CopyObjectRequest.CopySourceStruct(sourceAppid, sourceBucket, sourceRegion, sourceCosPath);
        
        String bucket = "bucket-cssg-test-android-1253653367"; //存储桶，格式：BucketName-APPID
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
    private void DeleteObject()
    {
        String bucket = "bucket-cssg-test-android-1253653367"; //存储桶名称，格式：BucketName-APPID
        String cosPath = "object4android"; //对象在存储桶中的位置标识符，即对象键
        
        DeleteObjectRequest deleteObjectRequest = new DeleteObjectRequest(bucket, cosPath);
        // 设置签名校验 Host，默认校验所有 Header
        Set<String> headerKeys = new HashSet<>();
        headerKeys.add("Host");
        deleteObjectRequest.setSignParamsAndHeaders(null, headerKeys);
        // 使用同步方法删除
        try {
            DeleteObjectResult deleteObjectResult = cosXmlService.deleteObject(deleteObjectRequest);
        } catch (CosXmlClientException e) {
            e.printStackTrace();
            assertError(e);
        } catch (CosXmlServiceException e) {
            e.printStackTrace();
            assertError(e);
        }
        
        if (true) {return;}
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
    private void DeleteBucket()
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
        PutBucket();
    }

    @After public void tearDown() {
        DeleteObject();
        DeleteBucket();
    }

    @Test public void testObjectTransfer() {
        InitMultiUpload();
        ListMultiUpload();
        UploadPart();
        ListParts();
        CompleteMultiUpload();
        InitMultiUpload();
        UploadPart();
        AbortMultiUpload();
        TransferUploadObject();
        TransferDownloadObject();
        TransferCopyObject();
    }
}
