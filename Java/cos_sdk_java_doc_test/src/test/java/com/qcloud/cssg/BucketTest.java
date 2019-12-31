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

import org.junit.After;
import org.junit.Before;
import org.junit.Test;

import java.util.Date;
import java.util.ArrayList;
import java.util.List;
import java.net.URL;
import java.io.File;
import java.io.FileInputStream;
import javax.crypto.SecretKey;
import java.security.KeyPair;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

import static com.qcloud.cos.demo.SymmetricKeyEncryptionClientDemo.loadSymmetricAESKey;

public class BucketTest {

    private COSClient cosClient;


    public void putBucket() {
        //.cssg-snippet-body-start:[put-bucket]
        String bucket = "bucket-cssg-test-java-1253653367"; //存储桶名称，格式：BucketName-APPID
        CreateBucketRequest createBucketRequest = new CreateBucketRequest(bucket);
        // 设置 bucket 的权限为 Private(私有读写), 其他可选有公有读私有写, 公有读写
        createBucketRequest.setCannedAcl(CannedAccessControlList.Private);
        Bucket bucketResult = cosClient.createBucket(createBucketRequest);

        //.cssg-snippet-body-end
    }

    public void deleteBucket() {
        //.cssg-snippet-body-start:[delete-bucket]
        // bucket的命名规则为 BucketName-APPID ，此处填写的存储桶名称必须为此格式
        String bucketName = "bucket-cssg-test-java-1253653367";
        cosClient.deleteBucket(bucketName);
        //.cssg-snippet-body-end
    }

    public void getBucket() {
        //.cssg-snippet-body-start:[get-bucket]
        // Bucket的命名格式为 BucketName-APPID ，此处填写的存储桶名称必须为此格式
        String bucketName = "bucket-cssg-test-java-1253653367";
        ListObjectsRequest listObjectsRequest = new ListObjectsRequest();
        // 设置bucket名称
        listObjectsRequest.setBucketName(bucketName);
        // prefix表示列出的object的key以prefix开始
        listObjectsRequest.setPrefix("images/");
        // deliter表示分隔符, 设置为/表示列出当前目录下的object, 设置为空表示列出所有的object
        listObjectsRequest.setDelimiter("/");
        // 设置最大遍历出多少个对象, 一次listobject最大支持1000
        listObjectsRequest.setMaxKeys(1000);
        ObjectListing objectListing = null;
        do {
            try {
                objectListing = cosClient.listObjects(listObjectsRequest);
            } catch (CosServiceException e) {
                e.printStackTrace();
                return;
            } catch (CosClientException e) {
                e.printStackTrace();
                return;
            }
            // common prefix表示表示被delimiter截断的路径, 如delimter设置为/, common prefix则表示所有子目录的路径
            List<String> commonPrefixs = objectListing.getCommonPrefixes();
        
            // object summary表示所有列出的object列表
            List<COSObjectSummary> cosObjectSummaries = objectListing.getObjectSummaries();
            for (COSObjectSummary cosObjectSummary : cosObjectSummaries) {
                // 文件的路径key
                String key = cosObjectSummary.getKey();
                // 文件的etag
                String etag = cosObjectSummary.getETag();
                // 文件的长度
                long fileSize = cosObjectSummary.getSize();
                // 文件的存储类型
                String storageClasses = cosObjectSummary.getStorageClass();
            }
        
            String nextMarker = objectListing.getNextMarker();
            listObjectsRequest.setMarker(nextMarker);
        } while (objectListing.isTruncated());
        //.cssg-snippet-body-end
    }

    public void headBucket() {
        //.cssg-snippet-body-start:[head-bucket]
        // bucket的命名规则为 BucketName-APPID ，此处填写的存储桶名称必须为此格式
        String bucketName = "bucket-cssg-test-java-1253653367";
        boolean bucketExistFlag = cosClient.doesBucketExist(bucketName);
        //.cssg-snippet-body-end
    }

    public void putBucketAcl() {
        //.cssg-snippet-body-start:[put-bucket-acl]
        // bucket的命名规则为 BucketName-APPID ，此处填写的存储桶名称必须为此格式
        String bucketName = "bucket-cssg-test-java-1253653367";
        // 设置自定义 ACL
        AccessControlList acl = new AccessControlList();
        Owner owner = new Owner();
        owner.setId("qcs::cam::uin/1278687956:uin/1278687956");
        acl.setOwner(owner);
        String id = "qcs::cam::uin/2779643970:uin/2779643970";
        UinGrantee uinGrantee = new UinGrantee("qcs::cam::uin/2779643970:uin/2779643970");
        uinGrantee.setIdentifier(id);
        acl.grantPermission(uinGrantee, Permission.FullControl);
        cosClient.setBucketAcl(bucketName, acl);
        
        // 设置预定义 ACL
        // 设置私有读写（默认新建的 bucket 都是私有读写）
        cosClient.setBucketAcl(bucketName, CannedAccessControlList.Private);
        // 设置公有读私有写
        cosClient.setBucketAcl(bucketName, CannedAccessControlList.PublicRead);
        // 设置公有读写
        cosClient.setBucketAcl(bucketName, CannedAccessControlList.PublicReadWrite);
        //.cssg-snippet-body-end
    }

    public void getBucketAcl() {
        //.cssg-snippet-body-start:[get-bucket-acl]
        // bucket的命名规则为 BucketName-APPID ，此处填写的存储桶名称必须为此格式
        String bucketName = "bucket-cssg-test-java-1253653367";
        AccessControlList acl = cosClient.getBucketAcl(bucketName);
        //.cssg-snippet-body-end
    }

    public void putBucketCors() {
        //.cssg-snippet-body-start:[put-bucket-cors]
        // bucket的命名格式为 BucketName-APPID ，此处填写的存储桶名称必须为此格式
        String bucketName = "bucket-cssg-test-java-1253653367";
        BucketCrossOriginConfiguration bucketCORS = new BucketCrossOriginConfiguration();
        List<CORSRule> corsRules = new ArrayList<CORSRule>();
        CORSRule corsRule = new CORSRule();
        // 规则名称
        corsRule.setId("set-bucket-cors-test");  
        // 允许的 HTTP 方法
        corsRule.setAllowedMethods(CORSRule.AllowedMethods.PUT, CORSRule.AllowedMethods.GET, CORSRule.AllowedMethods.HEAD);
        corsRule.setAllowedHeaders("x-cos-grant-full-control");
        corsRule.setAllowedOrigins("http://mail.qq.com",         "http://www.qq.com", "http://video.qq.com");
        corsRule.setExposedHeaders("x-cos-request-id");
        corsRule.setMaxAgeSeconds(60);
        corsRules.add(corsRule);
        bucketCORS.setRules(corsRules);
        cosClient.setBucketCrossOriginConfiguration(bucketName, bucketCORS);
        //.cssg-snippet-body-end
    }

    public void getBucketCors() {
        //.cssg-snippet-body-start:[get-bucket-cors]
        // bucket的命名格式为 BucketName-APPID ，此处填写的存储桶名称必须为此格式
        String bucketName = "bucket-cssg-test-java-1253653367";
        BucketCrossOriginConfiguration corsGet = cosClient.getBucketCrossOriginConfiguration(bucketName);
        List<CORSRule> corsRules = corsGet.getRules();
        for (CORSRule rule : corsRules) {
            List<CORSRule.AllowedMethods> allowedMethods = rule.getAllowedMethods();
            List<String> allowedHeaders = rule.getAllowedHeaders();
            List<String> allowedOrigins = rule.getAllowedOrigins();
            List<String> exposedHeaders = rule.getExposedHeaders();
            int maxAgeSeconds = rule.getMaxAgeSeconds();
        }
        //.cssg-snippet-body-end
    }

    public void deleteBucketCors() {
        //.cssg-snippet-body-start:[delete-bucket-cors]
        //存储桶的命名格式为 BucketName-APPID
        String bucketName = "bucket-cssg-test-java-1253653367";
        cosClient.deleteBucketCrossOriginConfiguration(bucketName);
        //.cssg-snippet-body-end
    }

    public void putBucketLifecycle() {
        //.cssg-snippet-body-start:[put-bucket-lifecycle]
        List<BucketLifecycleConfiguration.Rule> rules = new ArrayList<BucketLifecycleConfiguration.Rule>();
        // 规则1  30天后删除路径以 hongkong_movie/ 为开始的文件
        BucketLifecycleConfiguration.Rule deletePrefixRule = new BucketLifecycleConfiguration.Rule();
        deletePrefixRule.setId("delete prefix xxxy after 30 days");
        deletePrefixRule.setFilter(new LifecycleFilter(new LifecyclePrefixPredicate("hongkong_movie/")));
        // 文件上传或者变更后, 30天后删除
        deletePrefixRule.setExpirationInDays(30);
        // 设置规则为生效状态
        deletePrefixRule.setStatus(BucketLifecycleConfiguration.ENABLED);
        
        // 规则2  20天后沉降到低频，一年后删除
        BucketLifecycleConfiguration.Rule standardIaRule = new BucketLifecycleConfiguration.Rule();
        standardIaRule.setId("standard_ia transition");
        standardIaRule.setFilter(new LifecycleFilter(new LifecyclePrefixPredicate("standard_ia/")));
        List<BucketLifecycleConfiguration.Transition> standardIaTransitions = new ArrayList<BucketLifecycleConfiguration.Transition>();
        BucketLifecycleConfiguration.Transition standardTransition = new BucketLifecycleConfiguration.Transition();
        standardTransition.setDays(20);
        standardTransition.setStorageClass(StorageClass.Standard_IA.toString());
        standardIaTransitions.add(standardTransition);
        standardIaRule.setTransitions(standardIaTransitions);
        standardIaRule.setStatus(BucketLifecycleConfiguration.ENABLED);
        standardIaRule.setExpirationInDays(365);
          
        // 将两条规则添加到策略集合中
        rules.add(deletePrefixRule);
        rules.add(standardIaRule);
        
        // 生成 bucketLifecycleConfiguration
        BucketLifecycleConfiguration bucketLifecycleConfiguration =
                new BucketLifecycleConfiguration();
        bucketLifecycleConfiguration.setRules(rules);
        
        // 存储桶的命名格式为 BucketName-APPID
        String bucketName = "bucket-cssg-test-java-1253653367";
        SetBucketLifecycleConfigurationRequest setBucketLifecycleConfigurationRequest =
        new SetBucketLifecycleConfigurationRequest(bucketName, bucketLifecycleConfiguration);
        
        // 设置生命周期
        cosClient.setBucketLifecycleConfiguration(setBucketLifecycleConfigurationRequest);
        //.cssg-snippet-body-end
    }

    public void getBucketLifecycle() {
        //.cssg-snippet-body-start:[get-bucket-lifecycle]
        // 存储桶的命名格式为 BucketName-APPID ，此处填写的存储桶名称必须为此格式
        String bucketName = "bucket-cssg-test-java-1253653367";
        BucketLifecycleConfiguration queryLifeCycleRet =
                cosClient.getBucketLifecycleConfiguration(bucketName);
        List<BucketLifecycleConfiguration.Rule> ruleLists = queryLifeCycleRet.getRules();
        //.cssg-snippet-body-end
    }

    public void deleteBucketLifecycle() {
        //.cssg-snippet-body-start:[delete-bucket-lifecycle]
        //存储桶的命名格式为 BucketName-APPID
        String bucketName = "bucket-cssg-test-java-1253653367";
        cosClient.deleteBucketLifecycleConfiguration(bucketName);
        //.cssg-snippet-body-end
    }

    public void putBucketVersioning() {
        //.cssg-snippet-body-start:[put-bucket-versioning]
        String bucketName = "bucket-cssg-test-java-1253653367";
        // 开启版本控制
        cosClient.setBucketVersioningConfiguration(
        new SetBucketVersioningConfigurationRequest(bucketName,
        new BucketVersioningConfiguration(BucketVersioningConfiguration.ENABLED)));
        //.cssg-snippet-body-end
    }

    public void getBucketVersioning() {
        //.cssg-snippet-body-start:[get-bucket-versioning]
        String bucketName = "bucket-cssg-test-java-1253653367";
        // 获取版本控制
        BucketVersioningConfiguration bvc =
             cosClient.getBucketVersioningConfiguration(bucketName);
        // 获取版本控制
        BucketVersioningConfiguration bvc2 = cosClient.getBucketVersioningConfiguration(
           new GetBucketVersioningConfigurationRequest(bucketName));
        //.cssg-snippet-body-end
    }

    public void putBucketReplication() {
        //.cssg-snippet-body-start:[put-bucket-replication]
        // 源存储桶名称，需包含 appid
        String bucketName = "bucket-cssg-test-java-1253653367";
        
        BucketReplicationConfiguration bucketReplicationConfiguration = new BucketReplicationConfiguration();
        // 设置发起者身份, 格式为： qcs::cam::uin/<OwnerUin>:uin/<SubUin>
        bucketReplicationConfiguration.setRoleName("qcs::cam::uin/1278687956:uin/1278687956");
        
        // 设置目标存储桶和存储类型，QCS 的格式为：qcs::cos:[region]::[bucketname-AppId]
        ReplicationDestinationConfig replicationDestinationConfig = new ReplicationDestinationConfig();
        replicationDestinationConfig.setBucketQCS("qcs::cos:ap-beijing::bucket-cssg-assist-1253653367");
        replicationDestinationConfig.setStorageClass(StorageClass.Standard);
        
        // 设置规则状态和前缀
        ReplicationRule replicationRule = new ReplicationRule();
        replicationRule.setStatus(ReplicationRuleStatus.Enabled);
        replicationRule.setPrefix("");
        replicationRule.setDestinationConfig(replicationDestinationConfig);
        // 添加规则
        String ruleId = "replication-to-beijing";
        bucketReplicationConfiguration.addRule(ruleId, replicationRule);

        SetBucketReplicationConfigurationRequest setBucketReplicationConfigurationRequest =
            new SetBucketReplicationConfigurationRequest(bucketName, bucketReplicationConfiguration);
        cosClient.setBucketReplicationConfiguration(setBucketReplicationConfigurationRequest);

        //.cssg-snippet-body-end
    }

    public void getBucketReplication() {
        //.cssg-snippet-body-start:[get-bucket-replication]
        String bucketName = "bucket-cssg-test-java-1253653367";
        
        // 获取存储桶跨地域复制配置方法1
        BucketReplicationConfiguration brcfRet = cosClient.getBucketReplicationConfiguration(bucketName);

        // 获取存储桶跨地域复制配置方法2
        BucketReplicationConfiguration brcfRet2 = cosClient.getBucketReplicationConfiguration(
         new GetBucketReplicationConfigurationRequest(bucketName));
        //.cssg-snippet-body-end
    }

    public void deleteBucketReplication() {
        //.cssg-snippet-body-start:[delete-bucket-replication]
        String bucketName = "bucket-cssg-test-java-1253653367";
        
        // 删除存储桶跨地域复制配置方法1
        cosClient.deleteBucketReplicationConfiguration(bucketName);
        
        // 删除存储桶跨地域复制配置方法2
        cosClient.deleteBucketReplicationConfiguration(new DeleteBucketReplicationConfigurationRequest(bucketName));
        //.cssg-snippet-body-end
    }


    @Before
    public void setup() {
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
        putBucket();
    }

    @After
    public void teardown() {
        deleteBucket();
    }

    @Test
    public void testBucketACL() {
        getBucket();
        headBucket();
        putBucketAcl();
        getBucketAcl();
    }

    @Test
    public void testBucketCORS() {
        putBucketCors();
        getBucketCors();
        deleteBucketCors();
    }

    @Test
    public void testBucketLifecycle() {
        putBucketLifecycle();
        getBucketLifecycle();
        deleteBucketLifecycle();
    }

    @Test
    public void testBucketReplicationAndVersioning() {
        putBucketVersioning();
        getBucketVersioning();
        putBucketReplication();
        getBucketReplication();
        deleteBucketReplication();
    }

}