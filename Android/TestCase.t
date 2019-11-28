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
public class {{name}} {

    private static Context context;

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

    @BeforeClass public static void setUp() {
        context = InstrumentationRegistry.getInstrumentation().getTargetContext();
        {{{setupBlock}}}
    }

    @AfterClass public static void tearDown() {
        {{{teardownBlock}}}
    }

    {{#steps}}
    public void {{name}}()
    {
        {{{snippet}}}
    }
    {{/steps}}

    @Test public void test{{name}}() {
      {{^isDemo}}
      {{#steps}}
      {{name}}();
      {{/steps}}
      {{/isDemo}}
    }
}
