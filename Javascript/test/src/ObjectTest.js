function deleteObject(assert) {
  return new Promise((resolve, reject) => {
    //.cssg-snippet-body-start:[delete-object]
    cos.deleteObject({
        Bucket: 'bucket-cssg-test-js-1253653367', /* 必须 */
        Region: 'ap-guangzhou',     /* 存储桶所在地域，必须字段 */
        Key: 'object4js'        /* 必须 */
    }, function(err, data) {
        assert.notOk(err)
        resolve(data)
        console.log(err || data);
    });
    //.cssg-snippet-body-end
  })
}

function deleteBucket(assert) {
  return new Promise((resolve, reject) => {
    //.cssg-snippet-body-start:[delete-bucket]
    cos.deleteBucket({
        Bucket: 'bucket-cssg-test-js-1253653367', /* 必须 */
        Region: 'ap-guangzhou',     /* 存储桶所在地域，必须字段 */
    }, function(err, data) {
        resolve(data)
        console.log(err || data);
    });
    //.cssg-snippet-body-end
  })
}

function putObject(assert) {
  return new Promise((resolve, reject) => {
    //.cssg-snippet-body-start:[put-object]
    cos.putObject({
        Bucket: 'bucket-cssg-test-js-1253653367', /* 必须 */
        Region: 'ap-guangzhou',     /* 存储桶所在地域，必须字段 */
        Key: 'object4js',              /* 必须 */
        StorageClass: 'STANDARD',
        Body: fileObject, // 上传文件对象
        onProgress: function(progressData) {
            console.log(JSON.stringify(progressData));
        }
    }, function(err, data) {
        assert.notOk(err)
        resolve(data)
        console.log(err || data);
    });
    //.cssg-snippet-body-end
  })
}

function putObjectAcl(assert) {
  return new Promise((resolve, reject) => {
    //.cssg-snippet-body-start:[put-object-acl]
    cos.putObjectAcl({
        Bucket: 'bucket-cssg-test-js-1253653367', /* 必须 */
        Region: 'ap-guangzhou',     /* 存储桶所在地域，必须字段 */
        Key: 'object4js',              /* 必须 */
        ACL: 'public-read',        /* 非必须 */
    }, function(err, data) {
        assert.notOk(err)
        resolve(data)
        console.log(err || data);
    });
    //.cssg-snippet-body-end
  })
}

function putObjectAclUser(assert) {
  return new Promise((resolve, reject) => {
    //.cssg-snippet-body-start:[put-object-acl-user]
    cos.putObjectAcl({
        Bucket: 'bucket-cssg-test-js-1253653367', /* 必须 */
        Region: 'ap-guangzhou',     /* 存储桶所在地域，必须字段 */
        Key: 'object4js',              /* 必须 */
        GrantFullControl: 'id="1278687956"' // 1278687956是主账号 uin
    }, function(err, data) {
        assert.notOk(err)
        resolve(data)
        console.log(err || data);
    });
    //.cssg-snippet-body-end
  })
}

function putObjectAclAcp(assert) {
  return new Promise((resolve, reject) => {
    //.cssg-snippet-body-start:[put-object-acl-acp]
    cos.putObjectAcl({
        Bucket: 'bucket-cssg-test-js-1253653367', /* 必须 */
        Region: 'ap-guangzhou',     /* 存储桶所在地域，必须字段 */
        Key: 'object4js',              /* 必须 */
        AccessControlPolicy: {
            "Owner": { // AccessControlPolicy 里必须有 owner
                "ID": 'qcs::cam::uin/1278687956:uin/1278687956' // 1278687956 是 Bucket 所属用户的 QQ 号
            },
            "Grants": [{
                "Grantee": {
                    "ID": "qcs::cam::uin/100000000011:uin/100000000011", // 100000000011 是 QQ 号
                },
                "Permission": "WRITE"
            }]
        }
    }, function(err, data) {
        assert.notOk(err)
        resolve(data)
        console.log(err || data);
    });
    //.cssg-snippet-body-end
  })
}

function getObjectAcl(assert) {
  return new Promise((resolve, reject) => {
    //.cssg-snippet-body-start:[get-object-acl]
    cos.getObjectAcl({
        Bucket: 'bucket-cssg-test-js-1253653367', /* 必须 */
        Region: 'ap-guangzhou',     /* 存储桶所在地域，必须字段 */
        Key: 'object4js',              /* 必须 */
    }, function(err, data) {
        assert.notOk(err)
        resolve(data)
        console.log(err || data);
    });
    //.cssg-snippet-body-end
  })
}

function getPresignDownloadUrl(assert) {
    //.cssg-snippet-body-start:[get-presign-download-url]
    var url = cos.getObjectUrl({
        Bucket: 'bucket-cssg-test-js-1253653367',
        Region: 'ap-guangzhou',     /* 存储桶所在地域，必须字段 */
        Key: 'object4js',
        Sign: false
    });
    //.cssg-snippet-body-end
    assert.ok(url)
}

function getPresignDownloadUrlSigned(assert) {
    //.cssg-snippet-body-start:[get-presign-download-url-signed]
    var url = cos.getObjectUrl({
        Bucket: 'bucket-cssg-test-js-1253653367',
        Region: 'ap-guangzhou',     /* 存储桶所在地域，必须字段 */
        Key: 'object4js'
    });
    //.cssg-snippet-body-end
    assert.ok(url)
}

function getPresignDownloadUrlCallback(assert) {
  return new Promise((resolve, reject) => {
    //.cssg-snippet-body-start:[get-presign-download-url-callback]
    cos.getObjectUrl({
        Bucket: 'bucket-cssg-test-js-1253653367',
        Region: 'ap-guangzhou',     /* 存储桶所在地域，必须字段 */
        Key: 'object4js',
        Sign: false
    }, function (err, data) {
        assert.notOk(err)
        resolve(data)
        console.log(err || data.Url);
    });
    //.cssg-snippet-body-end
  })
}

function getPresignDownloadUrlExpiration(assert) {
  return new Promise((resolve, reject) => {
    //.cssg-snippet-body-start:[get-presign-download-url-expiration]
    cos.getObjectUrl({
        Bucket: 'bucket-cssg-test-js-1253653367',
        Region: 'ap-guangzhou',     /* 存储桶所在地域，必须字段 */
        Key: 'object4js',
        Sign: true,
        Expires: 3600, // 单位秒
    }, function (err, data) {
        assert.notOk(err)
        resolve(data)
        console.log(err || data.Url);
    });
    //.cssg-snippet-body-end
  })
}

function getPresignDownloadUrlThenFetch(assert) {
  return new Promise((resolve, reject) => {
    //.cssg-snippet-body-start:[get-presign-download-url-then-fetch]
    cos.getObjectUrl({
        Bucket: 'bucket-cssg-test-js-1253653367',
        Region: 'ap-guangzhou',     /* 存储桶所在地域，必须字段 */
        Key: 'object4js',
        Sign: true
    }, function (err, data) {
        assert.notOk(err)
        resolve(data)
        if (err) return console.log(err);
        var downloadUrl = data.Url + (data.Url.indexOf('?') > -1 ? '&' : '?') + 'response-content-disposition=attachment'; // 补充强制下载的参数
        window.open(downloadUrl); // 这里是新窗口打开 url，如果需要在当前窗口打开，可以使用隐藏的 iframe 下载，或使用 a 标签 download 属性协助下载
    });
    //.cssg-snippet-body-end
  })
}

function getPresignUploadUrl(assert) {
  return new Promise((resolve, reject) => {
    //.cssg-snippet-body-start:[get-presign-upload-url]
    cos.getObjectUrl({
        Bucket: 'bucket-cssg-test-js-1253653367',
        Region: 'ap-guangzhou',     /* 存储桶所在地域，必须字段 */
        Method: 'PUT',
        Key: 'object4js',
        Sign: true
    }, function (err, data) {
        assert.notOk(err)
        resolve(data)
        if (err) return console.log(err);
    
        console.log(data.Url);
        var xhr = new XMLHttpRequest();
        xhr.open('PUT', data.Url, true);
        xhr.onload = function (e) {
            console.log(xhr.responseText);
        };
        xhr.onerror = function (e) {
            console.log('获取签名出错');
        };
        xhr.send();
    });
    //.cssg-snippet-body-end
  })
}

function deleteMultiObject(assert) {
  return new Promise((resolve, reject) => {
    //.cssg-snippet-body-start:[delete-multi-object]
    cos.deleteMultipleObject({
        Bucket: 'bucket-cssg-test-js-1253653367', /* 必须 */
        Region: 'ap-guangzhou',     /* 存储桶所在地域，必须字段 */
        Objects: [
            {Key: 'object4js'},
            {Key: 'object4js2'},
        ]
    }, function(err, data) {
        assert.notOk(err)
        resolve(data)
        console.log(err || data);
    });
    //.cssg-snippet-body-end
  })
}

function restoreObject(assert) {
  return new Promise((resolve, reject) => {
    //.cssg-snippet-body-start:[restore-object]
    cos.restoreObject({
        Bucket: 'bucket-cssg-test-js-1253653367', /* 必须 */
        Region: 'ap-guangzhou',     /* 存储桶所在地域，必须字段 */
        Key: 'object4js',
        RestoreRequest: {
            Days: 1,
            CASJobParameters: {
                Tier: 'Expedited'
            }
        },
    }, function(err, data) {
        resolve(data)
        console.log(err || data);
    });
    //.cssg-snippet-body-end
  })
}

function initMultiUpload(assert) {
  return new Promise((resolve, reject) => {
    //.cssg-snippet-body-start:[init-multi-upload]
    cos.multipartInit({
        Bucket: 'bucket-cssg-test-js-1253653367', /* 必须 */
        Region: 'ap-guangzhou',     /* 存储桶所在地域，必须字段 */
        Key: 'object4js',              /* 必须 */
        UploadId: uploadId,
        Body: fileObject
    }, function(err, data) {
        assert.notOk(err)
        resolve(data)
        console.log(err || data);
        if (data) {
          uploadId = data.UploadId;
        }
    });
    //.cssg-snippet-body-end
  })
}

function listMultiUpload(assert) {
  return new Promise((resolve, reject) => {
    //.cssg-snippet-body-start:[list-multi-upload]
    cos.multipartList({
        Bucket: 'bucket-cssg-test-js-1253653367', /* 必须 */
        Region: 'ap-guangzhou',     /* 存储桶所在地域，必须字段 */
        Prefix: 'object4js',                        /* 非必须 */
    }, function(err, data) {
        assert.notOk(err)
        resolve(data)
        console.log(err || data);
    });
    //.cssg-snippet-body-end
  })
}

function uploadPart(assert) {
  return new Promise((resolve, reject) => {
    //.cssg-snippet-body-start:[upload-part]
    cos.multipartUpload({
        Bucket: 'bucket-cssg-test-js-1253653367', /* 必须 */
        Region: 'ap-guangzhou',     /* 存储桶所在地域，必须字段 */
        Key: 'object4js',       /* 必须 */
        UploadId: uploadId,
        PartNumber: '1',
        Body: fileObject
    }, function(err, data) {
        assert.notOk(err)
        resolve(data)
        console.log(err || data);
        if (data) {
          eTag = data.ETag;
        }
    });
    //.cssg-snippet-body-end
  })
}

function listParts(assert) {
  return new Promise((resolve, reject) => {
    //.cssg-snippet-body-start:[list-parts]
    cos.multipartListPart({
        Bucket: 'bucket-cssg-test-js-1253653367', /* 必须 */
        Region: 'ap-guangzhou',     /* 存储桶所在地域，必须字段 */
        Key: 'object4js',              /* 必须 */
        UploadId: uploadId,    /* 必须 */
    }, function(err, data) {
        assert.notOk(err)
        resolve(data)
        console.log(err || data);
    });
    //.cssg-snippet-body-end
  })
}

function completeMultiUpload(assert) {
  return new Promise((resolve, reject) => {
    //.cssg-snippet-body-start:[complete-multi-upload]
    cos.multipartComplete({
        Bucket: 'bucket-cssg-test-js-1253653367', /* 必须 */
        Region: 'ap-guangzhou',     /* 存储桶所在地域，必须字段 */
        Key: 'object4js',              /* 必须 */
        UploadId: uploadId, /* 必须 */
        Parts: [
            {PartNumber: '1', ETag: eTag},
        ]
    }, function(err, data) {
        assert.notOk(err)
        resolve(data)
        console.log(err || data);
    });
    //.cssg-snippet-body-end
  })
}

function abortMultiUpload(assert) {
  return new Promise((resolve, reject) => {
    //.cssg-snippet-body-start:[abort-multi-upload]
    cos.multipartAbort({
        Bucket: 'bucket-cssg-test-js-1253653367', /* 必须 */
        Region: 'ap-guangzhou',     /* 存储桶所在地域，必须字段 */
        Key: 'object4js',                           /* 必须 */
        UploadId: uploadId    /* 必须 */
    }, function(err, data) {
        assert.notOk(err)
        resolve(data)
        console.log(err || data);
    });
    //.cssg-snippet-body-end
  })
}

function transferUploadObject(assert) {
  return new Promise((resolve, reject) => {
    //.cssg-snippet-body-start:[transfer-upload-object]
    cos.sliceUploadFile({
        Bucket: 'bucket-cssg-test-js-1253653367', /* 必须 */
        Region: 'ap-guangzhou',     /* 存储桶所在地域，必须字段 */
        Key: 'object4js',              /* 必须 */
        Body: fileObject,                /* 必须 */
        onTaskReady: function(taskId) {                   /* 非必须 */
            console.log(taskId);
        },
        onHashProgress: function (progressData) {       /* 非必须 */
            console.log(JSON.stringify(progressData));
        },
        onProgress: function (progressData) {           /* 非必须 */
            console.log(JSON.stringify(progressData));
        }
    }, function(err, data) {
        assert.notOk(err)
        resolve(data)
        console.log(err || data);
    });
    //.cssg-snippet-body-end
  })
}

function transferCopyObject(assert) {
  return new Promise((resolve, reject) => {
    //.cssg-snippet-body-start:[transfer-copy-object]
    cos.sliceCopyFile({
        Bucket: 'bucket-cssg-test-js-1253653367',                               /* 必须 */
        Region: 'ap-guangzhou',     /* 存储桶所在地域，必须字段 */
        Key: 'object4js',                                            /* 必须 */
        CopySource: 'bucket-cssg-source-1253653367.cos.ap-guangzhou.myqcloud.com/sourceObject', /* 必须 */
        onProgress:function (progressData) {                     /* 非必须 */
            console.log(JSON.stringify(progressData));
        }
    },function (err,data) {
        assert.notOk(err)
        resolve(data)
        console.log(err || data);
    });
    //.cssg-snippet-body-end
  })
}

function batchUploadObjects(assert) {
  return new Promise((resolve, reject) => {
    //.cssg-snippet-body-start:[batch-upload-objects]
    cos.uploadFiles({
        files: [{
            Bucket: 'bucket-cssg-test-js-1253653367', // Bucket 格式：BucketName-APPID
            Region: 'ap-guangzhou',     /* 存储桶所在地域，必须字段 */
            Key: 'object4js',
            Body: fileObject,
        }, {
            Bucket: 'bucket-cssg-test-js-1253653367', // Bucket 格式：BucketName-APPID
            Region: 'ap-guangzhou',     /* 存储桶所在地域，必须字段 */
            Key: 'object4js2',
            Body: fileObject,
        }],
        SliceSize: 1024 * 1024,
        onProgress: function (info) {
            var percent = parseInt(info.percent * 10000) / 100;
            var speed = parseInt(info.speed / 1024 / 1024 * 100) / 100;
            console.log('进度：' + percent + '%; 速度：' + speed + 'Mb/s;');
        },
        onFileFinish: function (err, data, options) {
            console.log(options.Key + '上传' + (err ? '失败' : '完成'));
        },
    }, function (err, data) {
        assert.notOk(err)
        resolve(data)
        console.log(err || data);
    });
    //.cssg-snippet-body-end
  })
}

function copyObject(assert) {
  return new Promise((resolve, reject) => {
    //.cssg-snippet-body-start:[copy-object]
    cos.putObjectCopy({
        Bucket: 'bucket-cssg-test-js-1253653367',                               /* 必须 */
        Region: 'ap-guangzhou',     /* 存储桶所在地域，必须字段 */
        Key: 'object4js',                                            /* 必须 */
        CopySource: 'bucket-cssg-source-1253653367.cos.ap-guangzhou.myqcloud.com/sourceObject', /* 必须 */
    }, function(err, data) {
        assert.notOk(err)
        resolve(data)
        console.log(err || data);
    });
    //.cssg-snippet-body-end
  })
}

function uploadPartCopy(assert) {
  return new Promise((resolve, reject) => {
    //.cssg-snippet-body-start:[upload-part-copy]
    cos.uploadPartCopy({
        Bucket: 'bucket-cssg-test-js-1253653367', /* 必须 */
        Region: 'ap-guangzhou',     /* 存储桶所在地域，必须字段 */
        Key: 'object4js',       /* 必须 */
        CopySource: 'bucket-cssg-source-1253653367.cos.ap-guangzhou.myqcloud.com/sourceObject', /* 必须 */
        UploadId: uploadId, /* 必须 */
        PartNumber: '1', /* 必须 */
    }, function(err, data) {
        assert.notOk(err)
        resolve(data)
        console.log(err || data);
        if (data) {
          eTag = data.ETag;
        }
    });
    //.cssg-snippet-body-end
  })
}

function putObjectString(assert) {
  return new Promise((resolve, reject) => {
    //.cssg-snippet-body-start:[put-object-string]
    cos.putObject({
        Bucket: 'bucket-cssg-test-js-1253653367', /* 必须 */
        Region: 'ap-guangzhou',     /* 存储桶所在地域，必须字段 */
        Key: 'object4js',              /* 必须 */
        Body: 'hello!',
    }, function(err, data) {
        assert.notOk(err)
        resolve(data)
        console.log(err || data);
    });
    //.cssg-snippet-body-end
  })
}

function putObjectFolder(assert) {
  return new Promise((resolve, reject) => {
    //.cssg-snippet-body-start:[put-object-folder]
    cos.putObject({
        Bucket: 'bucket-cssg-test-js-1253653367', /* 必须 */
        Region: 'ap-guangzhou',     /* 存储桶所在地域，必须字段 */
        Key: 'a/',              /* 必须 */
        Body: '',
    }, function(err, data) {
        assert.notOk(err)
        resolve(data)
        console.log(err || data);
    });
    //.cssg-snippet-body-end
  })
}

function headObject(assert) {
  return new Promise((resolve, reject) => {
    //.cssg-snippet-body-start:[head-object]
    cos.headObject({
        Bucket: 'bucket-cssg-test-js-1253653367', /* 必须 */
        Region: 'ap-guangzhou',     /* 存储桶所在地域，必须字段 */
        Key: 'object4js',               /* 必须 */
    }, function(err, data) {
        assert.notOk(err)
        resolve(data)
        console.log(err || data);
    });
    //.cssg-snippet-body-end
  })
}

function getObject(assert) {
  return new Promise((resolve, reject) => {
    //.cssg-snippet-body-start:[get-object]
    cos.getObject({
        Bucket: 'bucket-cssg-test-js-1253653367', /* 必须 */
        Region: 'ap-guangzhou',     /* 存储桶所在地域，必须字段 */
        Key: 'object4js',              /* 必须 */
    }, function(err, data) {
        assert.notOk(err)
        resolve(data)
        console.log(err || data.Body);
    });
    //.cssg-snippet-body-end
  })
}

function getObjectRange(assert) {
  return new Promise((resolve, reject) => {
    //.cssg-snippet-body-start:[get-object-range]
    cos.getObject({
        Bucket: 'bucket-cssg-test-js-1253653367', /* 必须 */
        Region: 'ap-guangzhou',     /* 存储桶所在地域，必须字段 */
        Key: 'object4js',              /* 必须 */
        Range: 'bytes=1-3',        /* 非必须 */
    }, function(err, data) {
        assert.notOk(err)
        resolve(data)
        console.log(err || data.Body);
    });
    //.cssg-snippet-body-end
  })
}



test("testObjectMetadata", async function(assert) {
  await putObject(assert)
  await putObjectAcl(assert)
  await putObjectAclUser(assert)
  await putObjectAclAcp(assert)
  await getObjectAcl(assert)
  await getPresignDownloadUrl(assert)
  await getPresignDownloadUrlSigned(assert)
  await getPresignDownloadUrlCallback(assert)
  await getPresignDownloadUrlExpiration(assert)
  await getPresignDownloadUrlThenFetch(assert)
  await getPresignUploadUrl(assert)
  await deleteMultiObject(assert)
})
test("testObjectMultiUpload", async function(assert) {
  await initMultiUpload(assert)
  await listMultiUpload(assert)
  await uploadPart(assert)
  await listParts(assert)
  await completeMultiUpload(assert)
})
test("testObjectAbortMultiUpload", async function(assert) {
  await initMultiUpload(assert)
  await uploadPart(assert)
  await abortMultiUpload(assert)
})
test("testObjectTransfer", async function(assert) {
  await transferUploadObject(assert)
  await transferCopyObject(assert)
  await batchUploadObjects(assert)
})
test("testObjectCopy", async function(assert) {
  await copyObject(assert)
  await initMultiUpload(assert)
  await uploadPartCopy(assert)
  await completeMultiUpload(assert)
})
test("testObjectPutget", async function(assert) {
  await putObject(assert)
  await putObjectString(assert)
  await putObjectFolder(assert)
  await headObject(assert)
  await getObject(assert)
  await getObjectRange(assert)
  await deleteObject(assert)
})

test("CleanObjects", async function(assert) {
  await cleanupObjects(assert)
})
