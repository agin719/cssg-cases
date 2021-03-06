package com.qcloud.cssg;

import com.qcloud.cos.COSClient;
import com.qcloud.cos.COSEncryptionClient;
import com.qcloud.cos.ClientConfig;
import com.qcloud.cos.auth.*;
import com.qcloud.cos.exception.*;
import com.qcloud.cos.model.*;
import com.qcloud.cos.internal.crypto.*;
import com.qcloud.cos.region.Region;
import com.qcloud.cos.http.HttpMethodName;
import com.qcloud.cos.utils.DateUtils;
import com.qcloud.cos.transfer.*;
import com.qcloud.cos.model.lifecycle.*;

import com.qcloud.util.FileUtil;

import org.junit.After;
import org.junit.Before;
import org.junit.Test;

import java.io.*;
import java.security.KeyPairGenerator;
import java.security.NoSuchAlgorithmException;
import java.security.SecureRandom;
import java.util.Date;
import java.util.ArrayList;
import java.util.LinkedList;
import java.util.List;
import java.net.URL;
import javax.crypto.KeyGenerator;
import javax.crypto.SecretKey;
import java.security.KeyPair;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.concurrent.ThreadLocalRandom;

public class ObjectTest {

    private COSClient cosClient;
    private String bucketName = "bucket-cssg-test-java-1253653367";

    private String uploadId;
    private String localFilePath;
    private List<PartETag> partETags;

    public void putBucketComp() throws InterruptedException, IOException, NoSuchAlgorithmException {
        //.cssg-snippet-body-start:[put-bucket-comp]
        String bucket = "bucket-cssg-test-java-1253653367"; //存储桶名称，格式：BucketName-APPID
        CreateBucketRequest createBucketRequest = new CreateBucketRequest(bucket);
        // 设置 bucket 的权限为 Private(私有读写), 其他可选有公有读私有写, 公有读写
        createBucketRequest.setCannedAcl(CannedAccessControlList.Private);
        try{
            Bucket bucketResult = cosClient.createBucket(createBucketRequest);
        } catch (CosServiceException serverException) {
            serverException.printStackTrace();
        } catch (CosClientException clientException) {
            clientException.printStackTrace();
        }
        //.cssg-snippet-body-end
    }

    public void deleteObject() throws InterruptedException, IOException, NoSuchAlgorithmException {
        //.cssg-snippet-body-start:[delete-object]
        // Bucket的命名格式为 BucketName-APPID ，此处填写的存储桶名称必须为此格式
        String bucketName = "bucket-cssg-test-java-1253653367";
        String key = "object4java";
        cosClient.deleteObject(bucketName, key);
        //.cssg-snippet-body-end
    }

    public void deleteBucket() throws InterruptedException, IOException, NoSuchAlgorithmException {
        //.cssg-snippet-body-start:[delete-bucket]
        // bucket的命名规则为 BucketName-APPID ，此处填写的存储桶名称必须为此格式
        String bucketName = "bucket-cssg-test-java-1253653367";
        cosClient.deleteBucket(bucketName);
        //.cssg-snippet-body-end
    }

    public void putObject() throws InterruptedException, IOException, NoSuchAlgorithmException {
        //.cssg-snippet-body-start:[put-object]
        // 指定要上传的文件
        File localFile = new File(localFilePath);
        // 指定要上传到的存储桶
        String bucketName = "bucket-cssg-test-java-1253653367";
        // 指定要上传到 COS 上对象键
        String key = "object4java";
        PutObjectRequest putObjectRequest = new PutObjectRequest(bucketName, key, localFile);
        PutObjectResult putObjectResult = cosClient.putObject(putObjectRequest);
        //.cssg-snippet-body-end
    }

    public void putObjectAcl() throws InterruptedException, IOException, NoSuchAlgorithmException {
        //.cssg-snippet-body-start:[put-object-acl]
        // 权限信息中身份信息有格式要求，对于主账号与子账号的范式如下：
        // 下面的 root_uin 和 sub_uin 都必须是有效的 QQ 号
        // 主账号 qcs::cam::uin/<root_uin>:uin/<root_uin> 表示授予主账号 root_uin 这个用户（即前后填的 uin 一样）
        //  如 qcs::cam::uin/2779643970:uin/2779643970
        // 子账号 qcs::cam::uin/<root_uin>:uin/<sub_uin> 表示授予 root_uin 的子账号 sub_uin 这个客户
        //  如 qcs::cam::uin/2779643970:uin/73001122 
        // 存储桶的命名格式为 BucketName-APPID
        String bucketName = "bucket-cssg-test-java-1253653367";
        String key = "object4java";
        // 设置自定义 ACL
        AccessControlList acl = new AccessControlList();
        Owner owner = new Owner();
        // 设置 owner 的信息, owner 只能是主账号
        owner.setId("qcs::cam::uin/1278687956:uin/1278687956");
        acl.setOwner(owner);
        
        // 授权给主账号73410000可读可写权限
        UinGrantee uinGrantee1 = new UinGrantee("qcs::cam::uin/2779643970:uin/2779643970");
        acl.grantPermission(uinGrantee1, Permission.FullControl);
        cosClient.setObjectAcl(bucketName, key, acl);
        
        // 设置预定义 ACL
        // 设置私有读写（Object 的权限默认集成 Bucket的）
        cosClient.setObjectAcl(bucketName, key, CannedAccessControlList.Private);
        // 设置公有读私有写
        cosClient.setObjectAcl(bucketName, key, CannedAccessControlList.PublicRead);
        // 设置公有读写
        cosClient.setObjectAcl(bucketName, key, CannedAccessControlList.PublicReadWrite);
        //.cssg-snippet-body-end
    }

    public void getObjectAcl() throws InterruptedException, IOException, NoSuchAlgorithmException {
        //.cssg-snippet-body-start:[get-object-acl]
        // 存储桶的命名格式为 BucketName-APPID
        String bucketName = "bucket-cssg-test-java-1253653367";
        String key = "object4java";
        AccessControlList acl = cosClient.getObjectAcl(bucketName, key);
        //.cssg-snippet-body-end
    }

    public void headObject() throws InterruptedException, IOException, NoSuchAlgorithmException {
        //.cssg-snippet-body-start:[head-object]
        // Bucket的命名格式为 BucketName-APPID ，此处填写的存储桶名称必须为此格式
        String bucketName = "bucket-cssg-test-java-1253653367";
        String key = "object4java";
        ObjectMetadata objectMetadata = cosClient.getObjectMetadata(bucketName, key);
        //.cssg-snippet-body-end
    }

    public void getObject() throws InterruptedException, IOException, NoSuchAlgorithmException {
        //.cssg-snippet-body-start:[get-object]
        // Bucket的命名格式为 BucketName-APPID ，此处填写的存储桶名称必须为此格式
        String bucketName = "bucket-cssg-test-java-1253653367";
        String key = "object4java";
        // 方法1 获取下载输入流
        GetObjectRequest getObjectRequest = new GetObjectRequest(bucketName, key);
        COSObject cosObject = cosClient.getObject(getObjectRequest);
        COSObjectInputStream cosObjectInput = cosObject.getObjectContent();
        
        // 方法2 下载文件到本地
        String outputFilePath = "object4java";
        File downFile = new File(outputFilePath);
        getObjectRequest = new GetObjectRequest(bucketName, key);
        ObjectMetadata downObjectMeta = cosClient.getObject(getObjectRequest, downFile);
        //.cssg-snippet-body-end
    }

    public void getPresignDownloadUrl() throws InterruptedException, IOException, NoSuchAlgorithmException {
        //.cssg-snippet-body-start:[get-presign-download-url]
        // 初始化永久密钥信息
        String secretId = System.getenv("COS_KEY");
        String secretKey = System.getenv("COS_SECRET");
        COSCredentials cred = new BasicCOSCredentials(secretId, secretKey);
        Region region = new Region("ap-guangzhou");
        ClientConfig clientConfig = new ClientConfig(region);
        // 生成 cos 客户端。
        COSClient cosClient = new COSClient(cred, clientConfig);
        // 存储桶的命名格式为 BucketName-APPID，此处填写的存储桶名称必须为此格式
        String bucketName = "bucket-cssg-test-java-1253653367";
        String key = "object4java";
        GeneratePresignedUrlRequest req =
                new GeneratePresignedUrlRequest(bucketName, key, HttpMethodName.GET);
        // 设置签名过期时间(可选), 若未进行设置, 则默认使用 ClientConfig 中的签名过期时间(1小时)
        // 这里设置签名在半个小时后过期
        Date expirationDate = new Date(System.currentTimeMillis() + 30L * 60L * 1000L);
        req.setExpiration(expirationDate);
        URL url = cosClient.generatePresignedUrl(req);
        System.out.println(url.toString());
        cosClient.shutdown();
        //.cssg-snippet-body-end
    }

    public void getPresignUploadUrl() throws InterruptedException, IOException, NoSuchAlgorithmException {
        //.cssg-snippet-body-start:[get-presign-upload-url]
        // 存储桶的命名格式为 BucketName-APPID，此处填写的存储桶名称必须为此格式
        String bucketName = "bucket-cssg-test-java-1253653367";
        String key = "object4java";
        // 设置签名过期时间(可选), 若未进行设置, 则默认使用 ClientConfig 中的签名过期时间(1小时)
        // 这里设置签名在半个小时后过期
        Date expirationTime = new Date(System.currentTimeMillis() + 30L * 60L * 1000L);
        URL url = cosClient.generatePresignedUrl(bucketName, key, expirationTime, HttpMethodName.PUT);
        System.out.println(url.toString());
        cosClient.shutdown();
        //.cssg-snippet-body-end
    }

    public void deleteMultiObject() throws InterruptedException, IOException, NoSuchAlgorithmException {
        //.cssg-snippet-body-start:[delete-multi-object]
        // Bucket的命名格式为 BucketName-APPID ，此处填写的存储桶名称必须为此格式
        String bucketName = "bucket-cssg-test-java-1253653367";
        
        DeleteObjectsRequest deleteObjectsRequest = new DeleteObjectsRequest(bucketName);
        // 设置要删除的key列表, 最多一次删除1000个
        ArrayList<DeleteObjectsRequest.KeyVersion> keyList = new ArrayList<DeleteObjectsRequest.KeyVersion>();
        // 传入要删除的文件名
        keyList.add(new DeleteObjectsRequest.KeyVersion("project/folder1/picture.jpg"));
        keyList.add(new DeleteObjectsRequest.KeyVersion("project/folder2/text.txt"));
        keyList.add(new DeleteObjectsRequest.KeyVersion("project/folder2/music.mp3"));
        deleteObjectsRequest.setKeys(keyList);
        
        // 批量删除文件
        try {
            DeleteObjectsResult deleteObjectsResult = cosClient.deleteObjects(deleteObjectsRequest);
            List<DeleteObjectsResult.DeletedObject> deleteObjectResultArray = deleteObjectsResult.getDeletedObjects();
        } catch (MultiObjectDeleteException mde) { // 如果部分删除成功部分失败, 返回MultiObjectDeleteException
            List<DeleteObjectsResult.DeletedObject> deleteObjects = mde.getDeletedObjects();
            List<MultiObjectDeleteException.DeleteError> deleteErrors = mde.getErrors();
        } catch (CosServiceException e) { // 如果是其他错误，例如参数错误， 身份验证不过等会抛出 CosServiceException
            e.printStackTrace();
            throw e;
        } catch (CosClientException e) { // 如果是客户端错误，例如连接不上COS
            e.printStackTrace();
            throw e;
        }
        //.cssg-snippet-body-end
    }

    public void restoreObject() throws InterruptedException, IOException, NoSuchAlgorithmException {
        //.cssg-snippet-body-start:[restore-object]
        // 存储桶的命名格式为 BucketName-APPID，此处填写的存储桶名称必须为此格式
        String bucketName = "bucket-cssg-test-java-1253653367";
        String key = "object4java";
        
        // 设置 restore 得到的临时副本过期天数为1天
        RestoreObjectRequest restoreObjectRequest = new RestoreObjectRequest(bucketName, key, 1);
        // 设置恢复模式为 Standard，其他的可选模式包括 Expedited 和 Bulk，三种恢复模式在费用和速度上不一样
        CASJobParameters casJobParameters = new CASJobParameters();
        casJobParameters.setTier(Tier.Standard);
        restoreObjectRequest.setCASJobParameters(casJobParameters);
        cosClient.restoreObject(restoreObjectRequest);
        //.cssg-snippet-body-end
    }

    public void initMultiUpload() throws InterruptedException, IOException, NoSuchAlgorithmException {
        //.cssg-snippet-body-start:[init-multi-upload]
        // Bucket的命名格式为 BucketName-APPID
        String bucketName = "bucket-cssg-test-java-1253653367";
        String key = "object4java";
        InitiateMultipartUploadRequest initRequest = new InitiateMultipartUploadRequest(bucketName, key);
        InitiateMultipartUploadResult initResponse = cosClient.initiateMultipartUpload(initRequest);
        uploadId = initResponse.getUploadId();
        //.cssg-snippet-body-end
    }

    public void listMultiUpload() throws InterruptedException, IOException, NoSuchAlgorithmException {
        //.cssg-snippet-body-start:[list-multi-upload]
        // Bucket的命名格式为 BucketName-APPID ，此处填写的存储桶名称必须为此格式
        String bucketName = "bucket-cssg-test-java-1253653367";
        ListMultipartUploadsRequest listMultipartUploadsRequest = new ListMultipartUploadsRequest(bucketName);
        listMultipartUploadsRequest.setDelimiter("/");
        listMultipartUploadsRequest.setMaxUploads(100);
        listMultipartUploadsRequest.setPrefix("");
        listMultipartUploadsRequest.setEncodingType("url");
        MultipartUploadListing multipartUploadListing = cosClient.listMultipartUploads(listMultipartUploadsRequest);
        //.cssg-snippet-body-end
    }

    public void uploadPart() throws InterruptedException, IOException, NoSuchAlgorithmException {
        //.cssg-snippet-body-start:[upload-part]
        // 上传分块, 最多10000个分块, 分块大小支持为1M - 5G。
        // 分块大小设置为4M。如果总计 n 个分块, 则 1 ~ n-1 的分块大小一致，最后一块小于等于前面的分块大小。
        partETags = new ArrayList<PartETag>();
        int partNumber = 1;
        int partSize = 4 * 1024 * 1024;
        String bucketName = "bucket-cssg-test-java-1253653367";
        String key = "object4java";
        byte data[] = new byte[partSize];
        ByteArrayInputStream partStream = new ByteArrayInputStream(data);
        // partStream 代表 part 数据的输入流, 流长度为 partSize
        UploadPartRequest uploadRequest = new UploadPartRequest().withBucketName(bucketName).
                withUploadId(uploadId).withKey(key).withPartNumber(partNumber).
                withInputStream(partStream).withPartSize(partSize);
        UploadPartResult uploadPartResult = cosClient.uploadPart(uploadRequest);
        String eTag = uploadPartResult.getETag();  // 获取 part 的 Etag
        partETags.add(new PartETag(partNumber, eTag));  // partETags 记录所有已上传的 part 的 Etag 信息
        // ... 上传 partNumber 第2个到第 n 个分块
        //.cssg-snippet-body-end
    }

    public void listParts() throws InterruptedException, IOException, NoSuchAlgorithmException {
        //.cssg-snippet-body-start:[list-parts]
        // ListPart 用于在 complete 分块上传前或者 abort 分块上传前获取 uploadId 对应的已上传的分块信息, 可以用来构造 partEtags
        List<PartETag> partETags = new ArrayList<PartETag>();
        String bucketName = "bucket-cssg-test-java-1253653367";
        String key = "object4java";
        ListPartsRequest listPartsRequest = new ListPartsRequest(bucketName, key, uploadId);
        PartListing partListing = null;
        do {
            partListing = cosClient.listParts(listPartsRequest);
            for (PartSummary partSummary : partListing.getParts()) {
                partETags.add(new PartETag(partSummary.getPartNumber(), partSummary.getETag()));
            }
            listPartsRequest.setPartNumberMarker(partListing.getNextPartNumberMarker());
        } while (partListing.isTruncated());
        //.cssg-snippet-body-end
    }

    public void completeMultiUpload() throws InterruptedException, IOException, NoSuchAlgorithmException {
        //.cssg-snippet-body-start:[complete-multi-upload]
        // complete 完成分块上传.
        String bucketName = "bucket-cssg-test-java-1253653367";
        String key = "object4java";
        CompleteMultipartUploadRequest compRequest = new CompleteMultipartUploadRequest(bucketName, key, uploadId, partETags);
        CompleteMultipartUploadResult result = cosClient.completeMultipartUpload(compRequest);
        //.cssg-snippet-body-end
    }

    public void abortMultiUpload() throws InterruptedException, IOException, NoSuchAlgorithmException {
        //.cssg-snippet-body-start:[abort-multi-upload]
        // abortMultipartUpload 用于终止一个还未 complete 的分块上传
        String bucketName = "bucket-cssg-test-java-1253653367";
        String key = "object4java";
        AbortMultipartUploadRequest abortMultipartUploadRequest = new AbortMultipartUploadRequest(bucketName, key, uploadId);
        cosClient.abortMultipartUpload(abortMultipartUploadRequest);
        //.cssg-snippet-body-end
    }

    public void transferUploadObject() throws InterruptedException, IOException, NoSuchAlgorithmException {
        //.cssg-snippet-body-start:[transfer-upload-object]
        // 示例1：
        // 存储桶的命名格式为 BucketName-APPID，此处填写的存储桶名称必须为此格式
        ExecutorService threadPool = Executors.newFixedThreadPool(1);
        // 传入一个threadpool, 若不传入线程池, 默认TransferManager中会生成一个单线程的线程池。
        TransferManager transferManager = new TransferManager(cosClient, threadPool);
        String bucketName = "bucket-cssg-test-java-1253653367";
        String key = "object4java";
        File localFile = new File(localFilePath);
        PutObjectRequest putObjectRequest = new PutObjectRequest(bucketName, key, localFile);
        // 本地文件上传
        Upload upload = transferManager.upload(putObjectRequest);
        // 等待传输结束（如果想同步的等待上传结束，则调用 waitForCompletion）
        UploadResult uploadResult = upload.waitForUploadResult();
        transferManager.shutdownNow();
        //.cssg-snippet-body-end
    }

    public void transferDownloadObject() throws InterruptedException, IOException, NoSuchAlgorithmException {
        //.cssg-snippet-body-start:[transfer-download-object]
        // Bucket 的命名格式为 BucketName-APPID ，此处填写的存储桶名称必须为此格式
        ExecutorService threadPool = Executors.newFixedThreadPool(1);
        // 传入一个threadpool, 若不传入线程池, 默认TransferManager中会生成一个单线程的线程池。
        TransferManager transferManager = new TransferManager(cosClient, threadPool);
        String bucketName = "bucket-cssg-test-java-1253653367";
        String key = "object4java";
        File localDownFile = new File(localFilePath);
        GetObjectRequest getObjectRequest = new GetObjectRequest(bucketName, key);
        // 下载文件
        Download download = transferManager.download(getObjectRequest, localDownFile);
        // 等待传输结束（如果想同步的等待上传结束，则调用 waitForCompletion）
        download.waitForCompletion();
        transferManager.shutdownNow();
        //.cssg-snippet-body-end
    }

    public void transferCopyObject() throws InterruptedException, IOException, NoSuchAlgorithmException {
        //.cssg-snippet-body-start:[transfer-copy-object]
        // 要拷贝的 bucket region, 支持跨地域拷贝
        ExecutorService threadPool = Executors.newFixedThreadPool(1);
        // 传入一个threadpool, 若不传入线程池, 默认TransferManager中会生成一个单线程的线程池。
        TransferManager transferManager = new TransferManager(cosClient, threadPool);
        String secretId = System.getenv("COS_KEY");
        String secretKey = System.getenv("COS_SECRET");
        COSCredentials srcCredentials = new BasicCOSCredentials(secretId, secretKey);
        Region srcBucketRegion = new Region("ap-guangzhou");
        // 源 Bucket, 存储桶的命名格式为 BucketName-APPID，此处填写的存储桶名称必须为此格式
        String srcBucketName = "bucket-cssg-source-1253653367";
        // 要拷贝的源文件
        String srcKey = "sourceObject";
        // 目的 Bucket, 存储桶的命名格式为 BucketName-APPID，此处填写的存储桶名称必须为此格式
        String destBucketName = "bucket-cssg-test-java-1253653367";
        // 要拷贝的目的文件
        String destKey = "object4java";
        // 生成用于获取源文件信息的 srcCOSClient
        COSClient srcCOSClient = new COSClient(srcCredentials, new ClientConfig(srcBucketRegion));
        CopyObjectRequest copyObjectRequest = new CopyObjectRequest(srcBucketRegion, srcBucketName,
                srcKey, destBucketName, destKey);
        Copy copy = transferManager.copy(copyObjectRequest, srcCOSClient, null);
        // 返回一个异步结果 copy, 可同步的调用 waitForCopyResult 等待 copy 结束, 成功返回 CopyResult, 失败抛出异常.
        CopyResult copyResult = copy.waitForCopyResult();
        transferManager.shutdownNow();
        //.cssg-snippet-body-end
    }

    public void transferEmpty() throws InterruptedException, IOException, NoSuchAlgorithmException {
        //.cssg-snippet-body-start:[transfer-empty]
        // 线程池大小，建议在客户端与 COS 网络充足（例如使用腾讯云的 CVM，同地域上传 COS）的情况下，设置成16或32即可，可较充分的利用网络资源
        // 对于使用公网传输且网络带宽质量不高的情况，建议减小该值，避免因网速过慢，造成请求超时。
        ExecutorService threadPool = Executors.newFixedThreadPool(1);
        // 传入一个 threadpool, 若不传入线程池，默认 TransferManager 中会生成一个单线程的线程池。
        TransferManager transferManager = new TransferManager(cosClient, threadPool);
        // 设置高级接口的分块上传阈值和分块大小为10MB
        TransferManagerConfiguration transferManagerConfiguration = new TransferManagerConfiguration();
        transferManagerConfiguration.setMultipartUploadThreshold(10 * 1024 * 1024);
        transferManagerConfiguration.setMinimumUploadPartSize(10 * 1024 * 1024);
        transferManager.setConfiguration(transferManagerConfiguration);
        // .....(提交上传下载请求, 如下文所属)
        // 关闭 TransferManger
        transferManager.shutdownNow();
        //.cssg-snippet-body-end
    }

    public void transferUploadObjectComplete() throws InterruptedException, IOException, NoSuchAlgorithmException {
        //.cssg-snippet-body-start:[transfer-upload-object-complete]
        ExecutorService threadPool = Executors.newFixedThreadPool(1);
        TransferManager transferManager = new TransferManager(cosClient, threadPool);
        
        String key = "object4java";
        File localFile = new File(localFilePath);
        String bucketName = "bucket-cssg-test-java-1253653367";
        PutObjectRequest putObjectRequest = new PutObjectRequest(bucketName, key, localFile);
        // 返回一个异步结果 Upload, 可同步的调用 waitForUploadResult 等待 upload 结束, 成功返回 UploadResult, 失败抛出异常.
        Upload upload = transferManager.upload(putObjectRequest);
        Thread.sleep(1000);
        
        // 暂停任务，获取 PersistableUpload
        PersistableUpload persistableUpload = upload.pause();
        //也可通过如下方式，获取PersistableUpload
        // while(persistableUpload == null) {
        //     persistableUpload = upload.getResumeableMultipartUploadId();
        //     System.out.println(System.currentTimeMillis());
        //     Thread.sleep(100);
        // }
        // 恢复上传
        upload = transferManager.resumeUpload(persistableUpload);
        // 等待上传任务完成
        UploadResult uploadResult = upload.waitForUploadResult();
        System.out.println(uploadResult.getETag());
        
        transferManager.shutdownNow();
        //.cssg-snippet-body-end
    }

    public void copyObject() throws InterruptedException, IOException, NoSuchAlgorithmException {
        //.cssg-snippet-body-start:[copy-object]
        // 同地域同账号拷贝
        // 源 Bucket, Bucket的命名格式为 BucketName-APPID，此处填写的存储桶名称必须为此格式
        String srcBucketName = "bucket-cssg-source-1253653367";
        // 要拷贝的源文件
        String srcKey = "sourceObject";
        // 目标存储桶, Bucket的命名格式为 BucketName-APPID，此处填写的存储桶名称必须为此格式
        String destBucketName = "bucket-cssg-test-java-1253653367";
        // 要拷贝的目的文件
        String destKey = "object4java";
        CopyObjectRequest copyObjectRequest = new CopyObjectRequest(srcBucketName, srcKey, destBucketName, destKey);
        CopyObjectResult copyObjectResult = cosClient.copyObject(copyObjectRequest);
        
        // 跨账号跨地域拷贝（需要拥有对源文件的读取权限以及目的文件的写入权限）
        String srcBucketNameOfDiffAppid = "bucket-own-by-others-1251668577";
        Region srcBucketRegion = new Region("ap-shanghai");
        copyObjectRequest = new CopyObjectRequest(srcBucketRegion, srcBucketNameOfDiffAppid, srcKey, destBucketName, destKey);
        copyObjectResult = cosClient.copyObject(copyObjectRequest);
        //.cssg-snippet-body-end
    }

    public void uploadPartCopy() throws InterruptedException, IOException, NoSuchAlgorithmException {
        //.cssg-snippet-body-start:[upload-part-copy]
        // 1 初始化用户身份信息（secretId, secretKey）。
        String secretId = System.getenv("COS_KEY");
        String secretKey = System.getenv("COS_SECRET");
        COSCredentials cred = new BasicCOSCredentials(secretId, secretKey);
        // 采用了新的 region 名字，可用 region 的列表可以在官网文档中获取，也可以参见下面的 XML SDK 和 JSON SDK 的地域对照表
        ClientConfig clientConfig = new ClientConfig(new Region("ap-guangzhou"));
        COSClient cosClient = new COSClient(cred, clientConfig);
        // 存储桶名称，格式为：BucketName-APPID
        // 设置目标存储桶名称，对象名称和分块上传 ID
        String destinationBucketName = "bucket-cssg-test-java-1253653367";
        String destinationTargetKey = "object4java";
        int partNumber = 1;
        CopyPartRequest copyPartRequest = new CopyPartRequest();
        copyPartRequest.setDestinationBucketName(destinationBucketName);
        copyPartRequest.setDestinationKey(destinationTargetKey);
        copyPartRequest.setUploadId(uploadId);
        copyPartRequest.setPartNumber(partNumber);
        // 设置源存储桶的区域和名称，以及对象名称，偏移量区间
        String sourceBucketRegion = "ap-guangzhou";
        String sourceBucketName = "bucket-cssg-source-1253653367";
        String sourceKey = "sourceObject";
        Long firstByte = 1L;
        Long lastByte = 1048576L;
        copyPartRequest.setSourceBucketRegion(new Region(sourceBucketRegion));
        copyPartRequest.setSourceBucketName(sourceBucketName);
        copyPartRequest.setSourceKey(sourceKey);
        copyPartRequest.setFirstByte(firstByte);
        copyPartRequest.setLastByte(lastByte);
        
        CopyPartResult copyPartResult = cosClient.copyPart(copyPartRequest);
        partETags = new ArrayList<PartETag>();
        partETags.add(copyPartResult.getPartETag());
        //.cssg-snippet-body-end
    }

    public void putBucketComplete() throws InterruptedException, IOException, NoSuchAlgorithmException {
        //.cssg-snippet-body-start:[put-bucket-complete]
        COSCredentials cred = new BasicCOSCredentials(System.getenv("COS_KEY"), System.getenv("COS_SECRET"));
        // 采用了新的 region 名字，可用 region 的列表可以在官网文档中获取，也可以参考下面的 XML SDK 和 JSON SDK 的地域对照表
        ClientConfig clientConfig = new ClientConfig(new Region("ap-guangzhou"));
        COSClient cosClient = new COSClient(cred, clientConfig);
        // 存储桶名称，格式为：BucketName-APPID
        String bucketName = "bucket-cssg-test-java-1253653367";
        
        // 以下是向这个存储桶上传一个文件的示例
        String key = "object4java";
        File localFile = new File(localFilePath);
        PutObjectRequest putObjectRequest = new PutObjectRequest(bucketName, key, localFile);
        // 设置存储类型：标准存储（Standard）, 低频存储（Standard_IA）和归档存储（ARCHIVE）。默认是标准存储（Standard）
        putObjectRequest.setStorageClass(StorageClass.Standard_IA);
        
        PutObjectResult putObjectResult = cosClient.putObject(putObjectRequest);
        // putobjectResult 会返回文件的 etag
        String etag = putObjectResult.getETag();
        
        // 关闭客户端
        cosClient.shutdown();
        //.cssg-snippet-body-end
    }

    public void getPresignDownloadUrlOverrideHeaders() throws InterruptedException, IOException, NoSuchAlgorithmException {
        //.cssg-snippet-body-start:[get-presign-download-url-override-headers]
        // 传入获取到的临时密钥 (tmpSecretId, tmpSecretKey, sessionToken)
        String tmpSecretId = System.getenv("COS_KEY");
        String tmpSecretKey = System.getenv("COS_SECRET");
        String sessionToken = "COS_TOKEN";
        COSCredentials cred = new BasicSessionCredentials(tmpSecretId, tmpSecretKey, sessionToken);
        // 设置 bucket 的区域, COS 地域的简称请参照 https://cloud.tencent.com/document/product/436/6224
        // clientConfig 中包含了设置 region, https(默认 http), 超时, 代理等 set 方法, 使用可参见源码或者常见问题 Java SDK 部分
        Region region = new Region("ap-guangzhou");
        ClientConfig clientConfig = new ClientConfig(region);
        // 生成 cos 客户端
        COSClient cosClient = new COSClient(cred, clientConfig);
        // 存储桶的命名格式为 BucketName-APPID 
        String bucketName = "bucket-cssg-test-java-1253653367";
        String key = "object4java";
        GeneratePresignedUrlRequest req =
                new GeneratePresignedUrlRequest(bucketName, key, HttpMethodName.GET);
        // 设置下载时返回的 http 头
        ResponseHeaderOverrides responseHeaders = new ResponseHeaderOverrides();
        String responseContentType = "image/x-icon";
        String responseContentLanguage = "zh-CN";
        String responseContentDispositon = "filename=\"object4java\"";
        String responseCacheControl = "no-cache";
        String cacheExpireStr =
                DateUtils.formatRFC822Date(new Date(System.currentTimeMillis() + 24L * 3600L * 1000L));
        responseHeaders.setContentType(responseContentType);
        responseHeaders.setContentLanguage(responseContentLanguage);
        responseHeaders.setContentDisposition(responseContentDispositon);
        responseHeaders.setCacheControl(responseCacheControl);
        responseHeaders.setExpires(cacheExpireStr);
        req.setResponseHeaders(responseHeaders);
        // 设置签名过期时间(可选)，若未进行设置，则默认使用 ClientConfig 中的签名过期时间(1小时)
        // 这里设置签名在半个小时后过期
        Date expirationDate = new Date(System.currentTimeMillis() + 30L * 60L * 1000L);
        req.setExpiration(expirationDate);
        URL url = cosClient.generatePresignedUrl(req);
        System.out.println(url.toString());
        cosClient.shutdown();
        //.cssg-snippet-body-end
    }

    public void getPresignDownloadUrlPublic() throws InterruptedException, IOException, NoSuchAlgorithmException {
        //.cssg-snippet-body-start:[get-presign-download-url-public]
        // 生成匿名的请求签名，需要重新初始化一个匿名的 cosClient
        // 初始化用户身份信息, 匿名身份不用传入 SecretId、SecretKey 等密钥信息
        COSCredentials cred = new AnonymousCOSCredentials();
        // 设置 bucket 的区域，COS 地域的简称请参照 https://cloud.tencent.com/document/product/436/6224
        ClientConfig clientConfig = new ClientConfig(new Region("ap-guangzhou"));
        // 生成 cos 客户端
        COSClient cosClient = new COSClient(cred, clientConfig);
        // bucket 名需包含 appid
        String bucketName = "bucket-cssg-test-java-1253653367";
        
        String key = "object4java";
        GeneratePresignedUrlRequest req =
                new GeneratePresignedUrlRequest(bucketName, key, HttpMethodName.GET);
        URL url = cosClient.generatePresignedUrl(req);
        System.out.println(url.toString());
        cosClient.shutdown();
        //.cssg-snippet-body-end
    }

    public void putObjectCseCAes() throws InterruptedException, IOException, NoSuchAlgorithmException {
        //.cssg-snippet-body-start:[put-object-cse-c-aes]
        // 初始化用户身份信息(secretId, secretKey)
        String secretId = System.getenv("COS_KEY");
        String secretKey = System.getenv("COS_SECRET");
        COSCredentials cred = new BasicCOSCredentials(secretId, secretKey);
        // 设置存储桶地域，COS 地域的简称请参照 https://www..com/document/product/436/6224
        ClientConfig clientConfig = new ClientConfig(new Region("ap-guangzhou"));
        
        // 生成对称密钥，你可以将其保存在文件中
        KeyGenerator symKeyGenerator = KeyGenerator.getInstance("AES");
        symKeyGenerator.init(256);
        SecretKey symKey = symKeyGenerator.generateKey();
        
        EncryptionMaterials encryptionMaterials = new EncryptionMaterials(symKey);
        // 使用 AES/GCM 模式，并将加密信息存储在文件元数据中.
        CryptoConfiguration cryptoConf = new CryptoConfiguration(CryptoMode.AuthenticatedEncryption)
                .withStorageMode(CryptoStorageMode.ObjectMetadata);
        
        // 生成加密客户端 EncryptionClient，COSEncryptionClient 是 COSClient 的子类, 所有 COSClient 支持的接口他都支持。
        // EncryptionClient 覆盖了 COSClient 上传下载逻辑，操作内部会执行加密操作，其他操作执行逻辑和 COSClient 一致
        COSEncryptionClient cosEncryptionClient =
                new COSEncryptionClient(new COSStaticCredentialsProvider(cred),
                        new StaticEncryptionMaterialsProvider(encryptionMaterials), clientConfig,
                        cryptoConf);
        
        // 上传文件
        // 这里给出 putObject 的示例, 对于高级 API 上传，只用在生成 TransferManager 时传入 COSEncryptionClient 对象即可
        String bucketName = "bucket-cssg-test-java-1253653367";
        String key = "object4java";
        File localFile = new File(localFilePath);
        PutObjectRequest putObjectRequest = new PutObjectRequest(bucketName, key, localFile);
        cosEncryptionClient.putObject(putObjectRequest);
        //.cssg-snippet-body-end
    }

    public void putObjectCseCRsa() throws InterruptedException, IOException, NoSuchAlgorithmException {
        //.cssg-snippet-body-start:[put-object-cse-c-rsa]
        // 初始化用户身份信息(secretId, secretKey)
        String secretId = System.getenv("COS_KEY");
        String secretKey = System.getenv("COS_SECRET");
        COSCredentials cred = new BasicCOSCredentials(secretId, secretKey);
        // 设置存储桶地域，COS 地域的简称请参照 https://cloud.tencent.com/document/product/436/6224
        ClientConfig clientConfig = new ClientConfig(new Region("ap-guangzhou"));
        
        // 生成非对称密钥
        KeyPairGenerator keyGenerator = KeyPairGenerator.getInstance("RSA");
        SecureRandom srand = new SecureRandom();
        keyGenerator.initialize(1024, srand);
        KeyPair asymKeyPair = keyGenerator.generateKeyPair();
        
        EncryptionMaterials encryptionMaterials = new EncryptionMaterials(asymKeyPair);
        // 使用 AES/GCM 模式，并将加密信息存储在文件元数据中.
        CryptoConfiguration cryptoConf = new CryptoConfiguration(CryptoMode.AuthenticatedEncryption)
                .withStorageMode(CryptoStorageMode.ObjectMetadata);
        
        // 生成加密客户端 EncryptionClient, COSEncryptionClient 是 COSClient 的子类, 所有COSClient 支持的接口他都支持。
        // EncryptionClient 覆盖了 COSClient 上传下载逻辑，操作内部会执行加密操作，其他操作执行逻辑和 COSClient 一致
        COSEncryptionClient cosEncryptionClient =
                new COSEncryptionClient(new COSStaticCredentialsProvider(cred),
                        new StaticEncryptionMaterialsProvider(encryptionMaterials), clientConfig,
                        cryptoConf);
        
        // 上传文件
        // 这里给出 putObject 的示例，对于高级 API 上传，只用在生成 TransferManager 时传入 COSEncryptionClient 对象即可
        String bucketName = "bucket-cssg-test-java-1253653367";
        String key = "object4java";
        File localFile = new File(localFilePath);
        PutObjectRequest putObjectRequest = new PutObjectRequest(bucketName, key, localFile);
        cosEncryptionClient.putObject(putObjectRequest);
        //.cssg-snippet-body-end
    }

    public void putAndListObjects() throws InterruptedException, IOException, NoSuchAlgorithmException {
        //.cssg-snippet-body-start:[put-and-list-objects]
        String bucketName = "bucket-cssg-test-java-1253653367";
        cosClient.putObject(bucketName, "project/folder1/picture.jpg", "content");
        cosClient.putObject(bucketName, "project/folder2/text.txt", "content");
        cosClient.putObject(bucketName, "project/folder2/music.mp3", "content");
        cosClient.putObject(bucketName, "project/video.mp4", "content");
        
        ListObjectsRequest listObjectsRequest = new ListObjectsRequest();
        listObjectsRequest.setBucketName(bucketName);
        listObjectsRequest.setPrefix("project/");
        listObjectsRequest.setDelimiter("/");
        // 实际使用，您可以将 maxKeys 设为最大值 1000，以减少请求次数
        listObjectsRequest.setMaxKeys(2);
        String nextMarker = "";
        for (; ; ) {
            listObjectsRequest.setMarker(nextMarker);
            ObjectListing objectListing = cosClient.listObjects(listObjectsRequest);
            // getCommonPrefixes + getObjectSummaries 返回条目数 <= maxKeys
            // 两次循环会输出 project/folder1/ 和 project/folder2/
            for (String prefix : objectListing.getCommonPrefixes()) {
                System.out.println(prefix);
            }
            // 两次循环会输出 project/video.mp4
            for (COSObjectSummary object : objectListing.getObjectSummaries()) {
                System.out.println(object.getKey());
            }
            // 判断是否还有条目
            if (!objectListing.isTruncated()) {
                break;
            }
            // 一次未获取完毕，以 nextMarker 作为下一次 listObjects 请求的 marker
            nextMarker = objectListing.getNextMarker();
        }
        //.cssg-snippet-body-end
    }

    public void putObjectFlex() throws InterruptedException, IOException, NoSuchAlgorithmException {
        //.cssg-snippet-body-start:[put-object-flex]
        // Bucket的命名格式为 BucketName-APPID ，此处填写的存储桶名称必须为此格式
        String bucketName = "bucket-cssg-test-java-1253653367";
        // 方法1 本地文件上传
        File localFile = new File(localFilePath);
        String key = "object4java";
        PutObjectResult putObjectResult = cosClient.putObject(bucketName, key, localFile);
        String etag = putObjectResult.getETag();  // 获取文件的 etag
        
        // 方法2 从输入流上传(需提前告知输入流的长度, 否则可能导致 oom)
        FileInputStream fileInputStream = new FileInputStream(localFile);
        ObjectMetadata objectMetadata = new ObjectMetadata();
        // 设置输入流长度为500
        objectMetadata.setContentLength(500);
        // 设置 Content type, 默认是 application/octet-stream
        objectMetadata.setContentType("application/pdf");
        putObjectResult = cosClient.putObject(bucketName, key, fileInputStream, objectMetadata);
        etag = putObjectResult.getETag();
        // 关闭输入流...
        
        // 方法3 提供更多细粒度的控制, 常用的设置如下
        // 1 storage-class 存储类型, 枚举值：Standard，Standard_IA，Archive。默认值：Standard
        // 2 content-type, 对于本地文件上传，默认根据本地文件的后缀进行映射，例如 jpg 文件映射 为image/jpeg
        //   对于流式上传 默认是 application/octet-stream
        // 3 上传的同时指定权限(也可通过调用 API set object acl 来设置)
        // 4 若要全局关闭上传MD5校验, 则设置系统环境变量，此设置会对所有的会影响所有的上传校验。 默认是进行校验的。
        // 关闭MD5校验：  System.setProperty(SkipMd5CheckStrategy.DISABLE_PUT_OBJECT_MD5_VALIDATION_PROPERTY, "true");
        // 打开MD5校验  System.setProperty(SkipMd5CheckStrategy.DISABLE_PUT_OBJECT_MD5_VALIDATION_PROPERTY, null);
        localFile = new File(localFilePath);
        key = "picture.jpg";
        PutObjectRequest putObjectRequest = new PutObjectRequest(bucketName, key, localFile);
        // 设置存储类型为低频
        putObjectRequest.setStorageClass(StorageClass.Standard_IA);
        // 设置自定义属性(如 content-type, content-disposition 等)
        objectMetadata = new ObjectMetadata();
        // 设置 Content type, 默认是 application/octet-stream
        objectMetadata.setContentType("image/jpeg");
        putObjectRequest.setMetadata(objectMetadata);
        putObjectResult = cosClient.putObject(putObjectRequest);
        etag = putObjectResult.getETag();  // 获取文件的 etag
        //.cssg-snippet-body-end
    }


    @Before
    public void setup() throws InterruptedException, IOException, NoSuchAlgorithmException{
        //.cssg-snippet-body-start:[global-init]
        // 1 初始化用户身份信息（secretId, secretKey）。
        String secretId = System.getenv("COS_KEY");
        String secretKey = System.getenv("COS_SECRET");
        COSCredentials cred = new BasicCOSCredentials(secretId, secretKey);
        // 2 设置 bucket 的区域, COS 地域的简称请参照 https://cloud.tencent.com/document/product/436/6224
        // clientConfig 中包含了设置 region, https(默认 http), 超时, 代理等 set 方法, 使用可参见源码或者常见问题 Java SDK 部分。
        Region region = new Region("ap-guangzhou");
        ClientConfig clientConfig = new ClientConfig(region);
        // 3 生成 cos 客户端。
        cosClient = new COSClient(cred, clientConfig);
        //.cssg-snippet-body-end
        putBucketComp();
        localFilePath = "test.txt";
        FileUtil.buildTestFile(localFilePath, 5 * 1024 * 1024);
    }

    @After
    public void teardown() throws InterruptedException, IOException, NoSuchAlgorithmException{
        new File(localFilePath).delete();
        cosClient.deleteObject(bucketName, "project/folder1/picture.jpg");
        cosClient.deleteObject(bucketName, "project/folder2/text.txt");
        cosClient.deleteObject(bucketName, "project/folder2/music.mp3");
        cosClient.deleteObject(bucketName, "project/video.mp4");
        cosClient.deleteObject(bucketName, "picture.jpg");
        deleteObject();
        deleteBucket();
    }

    @Test
    public void testObjectMetadata() throws InterruptedException, IOException, NoSuchAlgorithmException {
        putObject();
        putObjectAcl();
        getObjectAcl();
        headObject();
        getObject();
        getPresignDownloadUrl();
        getPresignUploadUrl();
        deleteObject();
        deleteMultiObject();
    }

    @Test
    public void testObjectMultiUpload() throws InterruptedException, IOException, NoSuchAlgorithmException {
        initMultiUpload();
        listMultiUpload();
        uploadPart();
        listParts();
        completeMultiUpload();
    }

    @Test
    public void testObjectAbortMultiUpload() throws InterruptedException, IOException, NoSuchAlgorithmException {
        initMultiUpload();
        uploadPart();
        abortMultiUpload();
    }

    @Test
    public void testObjectTransfer() throws InterruptedException, IOException, NoSuchAlgorithmException {
        transferUploadObject();
        transferDownloadObject();
        transferCopyObject();
        transferEmpty();
    }

    @Test
    public void testObjectCopy() throws InterruptedException, IOException, NoSuchAlgorithmException {
        copyObject();
        initMultiUpload();
        uploadPartCopy();
        completeMultiUpload();
    }

    @Test
    public void testPutBucketComplete() throws InterruptedException, IOException, NoSuchAlgorithmException {
        putBucketComplete();
    }

    @Test
    public void testGetPresignUrl() throws InterruptedException, IOException, NoSuchAlgorithmException {
        getPresignDownloadUrlOverrideHeaders();
        getPresignDownloadUrlPublic();
    }

    @Test
    public void testPutObjectFlex() throws InterruptedException, IOException, NoSuchAlgorithmException {
        putAndListObjects();
        putObjectFlex();
    }

}