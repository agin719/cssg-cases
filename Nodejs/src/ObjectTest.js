const assert = require('assert')
const fs = require('fs')
const path = require('path')

var createFileSync = function (filePath, size) {
  if (!fs.existsSync(filePath) || fs.statSync(filePath).size !== size) {
      fs.writeFileSync(filePath, Buffer.from(Array(size).fill(0)));
  }
  return filePath;
};

function initCOS () {
    //.cssg-snippet-body-start:[global-init]
    var COS = require('cos-nodejs-sdk-v5');
    var cos = new COS({
        SecretId: process.env["COS_KEY"],
        SecretKey: process.env["COS_SECRET"]
    });
    //.cssg-snippet-body-end
    return cos
}
var cos = initCOS()
var uploadId
var eTag
var tempFilePath = createFileSync(path.join(process.cwd(), "temp-file-to-upload"), 2048)

function putBucket() {
  return new Promise((resolve, reject) => {
    //.cssg-snippet-body-start:[put-bucket]
    cos.putBucket({
        Bucket: 'bucket-cssg-test-nodejs-1253653367',
        Region: 'ap-guangzhou'
    }, function(err, data) {
        resolve(data)
        console.log(err || data);
    });
    //.cssg-snippet-body-end
  })
}

function deleteObject() {
  return new Promise((resolve, reject) => {
    //.cssg-snippet-body-start:[delete-object]
    cos.deleteObject({
        Bucket: 'bucket-cssg-test-nodejs-1253653367', /* 必须 */
        Region: 'ap-guangzhou',    /* 必须 */
        Key: 'object4nodejs'       /* 必须 */
    }, function(err, data) {
        assert.ifError(err)
        resolve(data)
        console.log(err || data);
    });
    //.cssg-snippet-body-end
  })
}

function deleteBucket() {
  return new Promise((resolve, reject) => {
    //.cssg-snippet-body-start:[delete-bucket]
    cos.deleteBucket({
        Bucket: 'bucket-cssg-test-nodejs-1253653367', /* 必须 */
        Region: 'ap-guangzhou'     /* 必须 */
    }, function(err, data) {
        resolve(data)
        console.log(err || data);
    });
    //.cssg-snippet-body-end
  })
}

function putObject() {
  return new Promise((resolve, reject) => {
    //.cssg-snippet-body-start:[put-object]
    cos.putObject({
        Bucket: 'bucket-cssg-test-nodejs-1253653367', /* 必须 */
        Region: 'ap-guangzhou',    /* 必须 */
        Key: 'object4nodejs',              /* 必须 */
        StorageClass: 'STANDARD',
        Body: fs.createReadStream('./object4nodejs'), // 上传文件对象
        onProgress: function(progressData) {
            console.log(JSON.stringify(progressData));
        }
    }, function(err, data) {
        assert.ifError(err)
        resolve(data)
        console.log(err || data);
    });
    //.cssg-snippet-body-end
  })
}

function putObjectAcl() {
  return new Promise((resolve, reject) => {
    //.cssg-snippet-body-start:[put-object-acl]
    cos.putObjectAcl({
        Bucket: 'bucket-cssg-test-nodejs-1253653367', /* 必须 */
        Region: 'ap-guangzhou',    /* 必须 */
        Key: 'object4nodejs',              /* 必须 */
        ACL: 'public-read',        /* 非必须 */
    }, function(err, data) {
        assert.ifError(err)
        resolve(data)
        console.log(err || data);
    });
    //.cssg-snippet-body-end
  })
}

function putObjectAclUser() {
  return new Promise((resolve, reject) => {
    //.cssg-snippet-body-start:[put-object-acl-user]
    cos.putObjectAcl({
        Bucket: 'bucket-cssg-test-nodejs-1253653367', /* 必须 */
        Region: 'ap-guangzhou',    /* 必须 */
        Key: 'object4nodejs',              /* 必须 */
        GrantFullControl: 'id="1278687956"' // 1278687956是主账号 uin
    }, function(err, data) {
        assert.ifError(err)
        resolve(data)
        console.log(err || data);
    });
    //.cssg-snippet-body-end
  })
}

function putObjectAclAcp() {
  return new Promise((resolve, reject) => {
    //.cssg-snippet-body-start:[put-object-acl-acp]
    cos.putObjectAcl({
        Bucket: 'bucket-cssg-test-nodejs-1253653367', /* 必须 */
        Region: 'ap-guangzhou',    /* 必须 */
        Key: 'object4nodejs',              /* 必须 */
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
        assert.ifError(err)
        resolve(data)
        console.log(err || data);
    });
    //.cssg-snippet-body-end
  })
}

function getObjectAcl() {
  return new Promise((resolve, reject) => {
    //.cssg-snippet-body-start:[get-object-acl]
    cos.getObjectAcl({
        Bucket: 'bucket-cssg-test-nodejs-1253653367', /* 必须 */
        Region: 'ap-guangzhou',    /* 必须 */
        Key: 'object4nodejs',              /* 必须 */
    }, function(err, data) {
        assert.ifError(err)
        resolve(data)
        console.log(err || data);
    });
    //.cssg-snippet-body-end
  })
}

function getPresignDownloadUrl() {
    //.cssg-snippet-body-start:[get-presign-download-url]
    var url = cos.getObjectUrl({
        Bucket: 'bucket-cssg-test-nodejs-1253653367',
        Region: 'ap-guangzhou',
        Key: '1.jpg',
        Sign: false
    });
    //.cssg-snippet-body-end
    assert.ok(url)
}

function getPresignDownloadUrlSigned() {
    //.cssg-snippet-body-start:[get-presign-download-url-signed]
    var url = cos.getObjectUrl({
        Bucket: 'bucket-cssg-test-nodejs-1253653367',
        Region: 'ap-guangzhou',
        Key: '1.jpg'
    });
    //.cssg-snippet-body-end
    assert.ok(url)
}

function getPresignDownloadUrlCallback() {
  return new Promise((resolve, reject) => {
    //.cssg-snippet-body-start:[get-presign-download-url-callback]
    cos.getObjectUrl({
        Bucket: 'bucket-cssg-test-nodejs-1253653367',
        Region: 'ap-guangzhou',
        Key: '1.jpg',
        Sign: false
    }, function (err, data) {
        assert.ifError(err)
        resolve(data)
        console.log(err || data.Url);
    });
    //.cssg-snippet-body-end
  })
}

function getPresignDownloadUrlExpiration() {
  return new Promise((resolve, reject) => {
    //.cssg-snippet-body-start:[get-presign-download-url-expiration]
    cos.getObjectUrl({
        Bucket: 'bucket-cssg-test-nodejs-1253653367',
        Region: 'ap-guangzhou',
        Key: '1.jpg',
        Sign: true,
        Expires: 3600, // 单位秒
    }, function (err, data) {
        assert.ifError(err)
        resolve(data)
        console.log(err || data.Url);
    });
    //.cssg-snippet-body-end
  })
}

function getPresignDownloadUrlThenFetch() {
  return new Promise((resolve, reject) => {
    //.cssg-snippet-body-start:[get-presign-download-url-then-fetch]
    var request = require('request');
    var fs = require('fs');
    cos.getObjectUrl({
        Bucket: 'bucket-cssg-test-nodejs-1253653367',
        Region: 'ap-guangzhou',
        Key: '1.jpg',
        Sign: true
    }, function (err, data) {
        assert.ifError(err)
        resolve(data)
        if (!err) return console.log(err);
        console.log(data.Url);
        var req = request(data.Url, function (err, response, body) {
            console.log(err || body);
        });
        var writeStream = fs.createWriteStream(__dirname + '/1.jpg');
        req.pipe(writeStream);
    });
    //.cssg-snippet-body-end
  })
}

function getPresignUploadUrl() {
  return new Promise((resolve, reject) => {
    //.cssg-snippet-body-start:[get-presign-upload-url]
    var request = require('request');
    var fs = require('fs');
    cos.getObjectUrl({
        Bucket: 'bucket-cssg-test-nodejs-1253653367',
        Region: 'ap-guangzhou',
        Method: 'PUT',
        Key: '1.jpg',
        Sign: true
    }, function (err, data) {
        assert.ifError(err)
        resolve(data)
        if (!err) return console.log(err);
        console.log(data.Url);
        var readStream = fs.createReadStream(__dirname + '/1.jpg');
        var req = request({
            method: 'PUT',
            url: data.Url,
        }, function (err, response, body) {
            console.log(err || body);
        });
        readStream.pipe(req);
    });
    //.cssg-snippet-body-end
  })
}

function deleteMultiObject() {
  return new Promise((resolve, reject) => {
    //.cssg-snippet-body-start:[delete-multi-object]
    cos.deleteMultipleObject({
        Bucket: 'bucket-cssg-test-nodejs-1253653367', /* 必须 */
        Region: 'ap-guangzhou',    /* 必须 */
        Objects: [
            {Key: 'object4nodejs'},
            {Key: 'object4nodejs2'},
        ]
    }, function(err, data) {
        assert.ifError(err)
        resolve(data)
        console.log(err || data);
    });
    //.cssg-snippet-body-end
  })
}

function restoreObject() {
  return new Promise((resolve, reject) => {
    //.cssg-snippet-body-start:[restore-object]
    cos.restoreObject({
        Bucket: 'bucket-cssg-test-nodejs-1253653367', /* 必须 */
        Region: 'ap-guangzhou',    /* 必须 */
        Key: 'object4nodejs',
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

function initMultiUpload() {
  return new Promise((resolve, reject) => {
    //.cssg-snippet-body-start:[init-multi-upload]
    cos.multipartInit({
        Bucket: 'bucket-cssg-test-nodejs-1253653367', /* 必须 */
        Region: 'ap-guangzhou',    /* 必须 */
        Key: 'object4nodejs',              /* 必须 */
    }, function(err, data) {
        assert.ifError(err)
        resolve(data)
        console.log(err || data);
        if (data) {
          uploadId = data.UploadId;
        }
    });
    //.cssg-snippet-body-end
  })
}

function listMultiUpload() {
  return new Promise((resolve, reject) => {
    //.cssg-snippet-body-start:[list-multi-upload]
    cos.multipartList({
        Bucket: 'bucket-cssg-test-nodejs-1253653367', /* 必须 */
        Region: 'ap-guangzhou',    /* 必须 */
        Prefix: 'object4nodejs',                        /* 非必须 */
    }, function(err, data) {
        assert.ifError(err)
        resolve(data)
        console.log(err || data);
    });
    //.cssg-snippet-body-end
  })
}

function uploadPart() {
  return new Promise((resolve, reject) => {
    //.cssg-snippet-body-start:[upload-part]
    const filePath = tempFilePath // 本地文件路径
    cos.multipartUpload({
        Bucket: 'bucket-cssg-test-nodejs-1253653367', /* 必须 */
        Region: 'ap-guangzhou',    /* 必须 */
        Key: 'object4nodejs',       /* 必须 */
        ContentLength: '1024',
        UploadId: uploadId,
        PartNumber: '1',
        Body: fs.createReadStream(filePath)
    }, function(err, data) {
        assert.ifError(err)
        resolve(data)
        console.log(err || data);
        if (data) {
          eTag = data.ETag;
        }
    });
    //.cssg-snippet-body-end
  })
}

function listParts() {
  return new Promise((resolve, reject) => {
    //.cssg-snippet-body-start:[list-parts]
    cos.multipartListPart({
        Bucket: 'bucket-cssg-test-nodejs-1253653367', /* 必须 */
        Region: 'ap-guangzhou',    /* 必须 */
        Key: 'object4nodejs',              /* 必须 */
        UploadId: uploadId,                      /* 必须 */
    }, function(err, data) {
        assert.ifError(err)
        resolve(data)
        console.log(err || data);
    });
    //.cssg-snippet-body-end
  })
}

function completeMultiUpload() {
  return new Promise((resolve, reject) => {
    //.cssg-snippet-body-start:[complete-multi-upload]
    cos.multipartComplete({
        Bucket: 'bucket-cssg-test-nodejs-1253653367', /* 必须 */
        Region: 'ap-guangzhou',    /* 必须 */
        Key: 'object4nodejs',              /* 必须 */
        UploadId: uploadId, /* 必须 */
        Parts: [
            {PartNumber: '1', ETag: eTag},
        ]
    }, function(err, data) {
        assert.ifError(err)
        resolve(data)
        console.log(err || data);
    });
    //.cssg-snippet-body-end
  })
}

function abortMultiUpload() {
  return new Promise((resolve, reject) => {
    //.cssg-snippet-body-start:[abort-multi-upload]
    cos.multipartAbort({
        Bucket: 'bucket-cssg-test-nodejs-1253653367', /* 必须 */
        Region: 'ap-guangzhou',    /* 必须 */
        Key: 'object4nodejs',                           /* 必须 */
        UploadId: uploadId                       /* 必须 */
    }, function(err, data) {
        assert.ifError(err)
        resolve(data)
        console.log(err || data);
    });
    //.cssg-snippet-body-end
  })
}

function transferUploadObject() {
  return new Promise((resolve, reject) => {
    //.cssg-snippet-body-start:[transfer-upload-object]
    const filePath = tempFilePath // 本地文件路径
    cos.sliceUploadFile({
        Bucket: 'bucket-cssg-test-nodejs-1253653367', /* 必须 */
        Region: 'ap-guangzhou',    /* 必须 */
        Key: 'object4nodejs',              /* 必须 */
        FilePath: filePath,                /* 必须 */
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
        assert.ifError(err)
        resolve(data)
        console.log(err || data);
    });
    //.cssg-snippet-body-end
  })
}

function transferCopyObject() {
  return new Promise((resolve, reject) => {
    //.cssg-snippet-body-start:[transfer-copy-object]
    cos.sliceCopyFile({
        Bucket: 'bucket-cssg-test-nodejs-1253653367',                               /* 必须 */
        Region: 'ap-guangzhou',                                  /* 必须 */
        Key: 'object4nodejs',                                            /* 必须 */
        CopySource: 'bucket-cssg-source-1253653367.cos.ap-guangzhou.myqcloud.com/sourceObject', /* 必须 */
        onProgress:function (progressData) {                     /* 非必须 */
            console.log(JSON.stringify(progressData));
        }
    },function (err,data) {
        assert.ifError(err)
        resolve(data)
        console.log(err || data);
    });
    //.cssg-snippet-body-end
  })
}

function batchUploadObjects() {
  return new Promise((resolve, reject) => {
    //.cssg-snippet-body-start:[batch-upload-objects]
    const filePath1 = tempFilePath // 本地文件路径
    const filePath2 = tempFilePath // 本地文件路径
    cos.uploadFiles({
        files: [{
            Bucket: 'bucket-cssg-test-nodejs-1253653367',
            Region: 'ap-guangzhou',
            Key: 'object4nodejs',
            FilePath: filePath1,
        }, {
            Bucket: 'bucket-cssg-test-nodejs-1253653367',
            Region: 'ap-guangzhou',
            Key: '2.jpg',
            FilePath: filePath2,
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
        assert.ifError(err)
        resolve(data)
        console.log(err || data);
    });
    //.cssg-snippet-body-end
  })
}

function copyObject() {
  return new Promise((resolve, reject) => {
    //.cssg-snippet-body-start:[copy-object]
    cos.putObjectCopy({
        Bucket: 'bucket-cssg-test-nodejs-1253653367',                               /* 必须 */
        Region: 'ap-guangzhou',                                  /* 必须 */
        Key: 'object4nodejs',                                            /* 必须 */
        CopySource: 'bucket-cssg-source-1253653367.cos.ap-guangzhou.myqcloud.com/sourceObject', /* 必须 */
    }, function(err, data) {
        assert.ifError(err)
        resolve(data)
        console.log(err || data);
    });
    //.cssg-snippet-body-end
  })
}

function uploadPartCopy() {
  return new Promise((resolve, reject) => {
    //.cssg-snippet-body-start:[upload-part-copy]
    cos.uploadPartCopy({
        Bucket: 'bucket-cssg-test-nodejs-1253653367', /* 必须 */
        Region: 'ap-guangzhou',    /* 必须 */
        Key: 'object4nodejs',       /* 必须 */
        CopySource: 'bucket-cssg-source-1253653367.cos.ap-guangzhou.myqcloud.com/sourceObject', /* 必须 */
        UploadId: uploadId, /* 必须 */
        PartNumber: '1', /* 必须 */
    }, function(err, data) {
        assert.ifError(err)
        resolve(data)
        console.log(err || data);
        if (data) {
          eTag = data.ETag;
        }
    });
    //.cssg-snippet-body-end
  })
}

function putObjectBuffer() {
  return new Promise((resolve, reject) => {
    //.cssg-snippet-body-start:[put-object-buffer]
    cos.putObject({
        Bucket: 'bucket-cssg-test-nodejs-1253653367', /* 必须 */
        Region: 'ap-guangzhou',    /* 必须 */
        Key: 'object4nodejs',              /* 必须 */
        Body: Buffer.from('hello!'), /* 必须 */
    }, function(err, data) {
        assert.ifError(err)
        resolve(data)
        console.log(err || data);
    });
    //.cssg-snippet-body-end
  })
}

function putObjectString() {
  return new Promise((resolve, reject) => {
    //.cssg-snippet-body-start:[put-object-string]
    cos.putObject({
        Bucket: 'bucket-cssg-test-nodejs-1253653367', /* 必须 */
        Region: 'ap-guangzhou',    /* 必须 */
        Key: 'object4nodejs',              /* 必须 */
        Body: 'hello!',
    }, function(err, data) {
        assert.ifError(err)
        resolve(data)
        console.log(err || data);
    });
    //.cssg-snippet-body-end
  })
}

function putObjectFolder() {
  return new Promise((resolve, reject) => {
    //.cssg-snippet-body-start:[put-object-folder]
    cos.putObject({
        Bucket: 'bucket-cssg-test-nodejs-1253653367', /* 必须 */
        Region: 'ap-guangzhou',    /* 必须 */
        Key: 'a/',              /* 必须 */
        Body: '',
    }, function(err, data) {
        assert.ifError(err)
        resolve(data)
        console.log(err || data);
    });
    //.cssg-snippet-body-end
  })
}

function headObject() {
  return new Promise((resolve, reject) => {
    //.cssg-snippet-body-start:[head-object]
    cos.headObject({
        Bucket: 'bucket-cssg-test-nodejs-1253653367', /* 必须 */
        Region: 'ap-guangzhou',    /* 必须 */
        Key: 'object4nodejs',               /* 必须 */
    }, function(err, data) {
        assert.ifError(err)
        resolve(data)
        console.log(err || data);
    });
    //.cssg-snippet-body-end
  })
}

function getObject() {
  return new Promise((resolve, reject) => {
    //.cssg-snippet-body-start:[get-object]
    cos.getObject({
        Bucket: 'bucket-cssg-test-nodejs-1253653367', /* 必须 */
        Region: 'ap-guangzhou',    /* 必须 */
        Key: 'object4nodejs',              /* 必须 */
    }, function(err, data) {
        assert.ifError(err)
        resolve(data)
        console.log(err || data.Body);
    });
    //.cssg-snippet-body-end
  })
}

function getObjectRange() {
  return new Promise((resolve, reject) => {
    //.cssg-snippet-body-start:[get-object-range]
    cos.getObject({
        Bucket: 'bucket-cssg-test-nodejs-1253653367', /* 必须 */
        Region: 'ap-guangzhou',    /* 必须 */
        Key: 'object4nodejs',              /* 必须 */
        Range: 'bytes=1-3',        /* 非必须 */
    }, function(err, data) {
        assert.ifError(err)
        resolve(data)
        console.log(err || data.Body);
    });
    //.cssg-snippet-body-end
  })
}

function getObjectPath() {
  return new Promise((resolve, reject) => {
    //.cssg-snippet-body-start:[get-object-path]
    cos.getObject({
        Bucket: 'bucket-cssg-test-nodejs-1253653367', /* 必须 */
        Region: 'ap-guangzhou',    /* 必须 */
        Key: 'object4nodejs',              /* 必须 */
        Output: './object4nodejs',
    }, function(err, data) {
        assert.ifError(err)
        resolve(data)
        console.log(err || data);
    });
    //.cssg-snippet-body-end
  })
}

function getObjectStream() {
  return new Promise((resolve, reject) => {
    //.cssg-snippet-body-start:[get-object-stream]
    cos.getObject({
        Bucket: 'bucket-cssg-test-nodejs-1253653367', /* 必须 */
        Region: 'ap-guangzhou',    /* 必须 */
        Key: 'object4nodejs',              /* 必须 */
        Output: fs.createWriteStream('./object4nodejs'),
    }, function(err, data) {
        assert.ifError(err)
        resolve(data)
        console.log(err || data);
    });
    //.cssg-snippet-body-end
  })
}



describe("testObjectMetadata", function() {
  it("putObject", function() {
    return putObject()
  })
  it("putObjectAcl", function() {
    return putObjectAcl()
  })
  it("putObjectAclUser", function() {
    return putObjectAclUser()
  })
  it("putObjectAclAcp", function() {
    return putObjectAclAcp()
  })
  it("getObjectAcl", function() {
    return getObjectAcl()
  })
  it("getPresignDownloadUrl", function() {
    return getPresignDownloadUrl()
  })
  it("getPresignDownloadUrlSigned", function() {
    return getPresignDownloadUrlSigned()
  })
  it("getPresignDownloadUrlCallback", function() {
    return getPresignDownloadUrlCallback()
  })
  it("getPresignDownloadUrlExpiration", function() {
    return getPresignDownloadUrlExpiration()
  })
  it("getPresignDownloadUrlThenFetch", function() {
    return getPresignDownloadUrlThenFetch()
  })
  it("getPresignUploadUrl", function() {
    return getPresignUploadUrl()
  })
  it("deleteMultiObject", function() {
    return deleteMultiObject()
  })
  it("restoreObject", function() {
    return restoreObject()
  })
})
describe("testObjectMultiUpload", function() {
  it("initMultiUpload", function() {
    return initMultiUpload()
  })
  it("listMultiUpload", function() {
    return listMultiUpload()
  })
  it("uploadPart", function() {
    return uploadPart()
  })
  it("listParts", function() {
    return listParts()
  })
  it("completeMultiUpload", function() {
    return completeMultiUpload()
  })
})
describe("testObjectAbortMultiUpload", function() {
  it("initMultiUpload", function() {
    return initMultiUpload()
  })
  it("uploadPart", function() {
    return uploadPart()
  })
  it("abortMultiUpload", function() {
    return abortMultiUpload()
  })
})
describe("testObjectTransfer", function() {
  it("transferUploadObject", function() {
    return transferUploadObject()
  })
  it("transferCopyObject", function() {
    return transferCopyObject()
  })
  it("batchUploadObjects", function() {
    return batchUploadObjects()
  })
})
describe("testObjectCopy", function() {
  it("copyObject", function() {
    return copyObject()
  })
  it("initMultiUpload", function() {
    return initMultiUpload()
  })
  it("uploadPartCopy", function() {
    return uploadPartCopy()
  })
  it("completeMultiUpload", function() {
    return completeMultiUpload()
  })
})
describe("testObjectPutget", function() {
  it("putObject", function() {
    return putObject()
  })
  it("putObjectBuffer", function() {
    return putObjectBuffer()
  })
  it("putObjectString", function() {
    return putObjectString()
  })
  it("putObjectFolder", function() {
    return putObjectFolder()
  })
  it("headObject", function() {
    return headObject()
  })
  it("getObject", function() {
    return getObject()
  })
  it("getObjectRange", function() {
    return getObjectRange()
  })
  it("getObjectPath", function() {
    return getObjectPath()
  })
  it("getObjectStream", function() {
    return getObjectStream()
  })
  it("deleteObject", function() {
    return deleteObject()
  })
})

