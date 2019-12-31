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

public class {{name}}Test {

    private COSClient cosClient;
    private String bucketName = "bucket-cssg-test-java-1253653367";

    {{#isObjectTest}}
    private String uploadId;
    private String localFilePath;
    private List<PartETag> partETags;
    {{/isObjectTest}}

    {{#methods}}
    public void {{name}}() throws InterruptedException{{#isObjectTest}}, IOException, NoSuchAlgorithmException{{/isObjectTest}} {
        {{{snippet}}}
    }

    {{/methods}}

    @Before
    public void setup() throws InterruptedException{{#isObjectTest}}, IOException, NoSuchAlgorithmException{{/isObjectTest}}{
        {{{initSnippet}}}
        {{#setup}}
        {{name}}();
        {{/setup}}
        {{#isObjectTest}}
        localFilePath = "test.txt";
        FileUtil.buildTestFile(localFilePath, 5 * 1024 * 1024);
        {{/isObjectTest}}
    }

    @After
    public void teardown() throws InterruptedException{{#isObjectTest}}, IOException, NoSuchAlgorithmException{{/isObjectTest}}{
        {{#isObjectTest}}
        new File(localFilePath).delete();
        cosClient.deleteObject(bucketName, "project/folder1/picture.jpg");
        cosClient.deleteObject(bucketName, "project/folder2/text.txt");
        cosClient.deleteObject(bucketName, "project/folder2/music.mp3");
        cosClient.deleteObject(bucketName, "project/video.mp4");
        cosClient.deleteObject(bucketName, "picture.jpg");
        {{/isObjectTest}}
        {{#teardown}}
        {{name}}();
        {{/teardown}}
    }

    {{#cases}}
    @Test
    public void {{name}}() throws InterruptedException{{#isObjectTest}}, IOException, NoSuchAlgorithmException{{/isObjectTest}} {
        {{#steps}}
        {{name}}();
        {{/steps}}
    }

    {{/cases}}
}