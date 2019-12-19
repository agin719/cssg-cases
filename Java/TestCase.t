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

public class {{name}}Test {

    private COSClient cosClient;

    {{#isObjectTest}}
    String uploadId;
    String eTag;
    {{/isObjectTest}}

    {{#methods}}
    public void {{name}}() {
        {{{snippet}}}
    }

    {{/methods}}

    @Before
    public void setup() {
        {{{initSnippet}}}
        {{#setup}}
        {{name}}();
        {{/setup}}
    }

    @After
    public void teardown() {
        {{#teardown}}
        {{name}}();
        {{/teardown}}
    }

    {{#cases}}
    @Test
    public void {{name}}() {
        {{#steps}}
        {{name}}();
        {{/steps}}
    }

    {{/cases}}
}