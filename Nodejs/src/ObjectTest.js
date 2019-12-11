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
    var COS = require('cos-nodejs-sdk-v5');    var cos = new COS({        SecretId: process.env["COS_KEY"],        SecretKey: process.env["COS_SECRET"]    });    
    return cos
}
var cos = initCOS()
var uploadId
var eTag
var tempFilePath = createFileSync(path.join(process.cwd(), "temp-file-to-upload"), 2048)

function putBucket() {
  return new Promise((resolve, reject) => {
    cos.putBucket({        Bucket: 'bucket-cssg-test-nodejs-1253653367',        Region: 'ap-guangzhou'    }, function(err, data) {        resolve(data)        console.log(err || data);    });    
  })
}

function deleteObject() {
  return new Promise((resolve, reject) => {
    cos.deleteObject({        Bucket: 'bucket-cssg-test-nodejs-1253653367', /* 必须 */        Region: 'ap-guangzhou',    /* 必须 */        Key: 'object4nodejs'       /* 必须 */    }, function(err, data) {        assert.ifError(err)        resolve(data)        console.log(err || data);    });    
  })
}

function deleteBucket() {
  return new Promise((resolve, reject) => {
    cos.deleteBucket({        Bucket: 'bucket-cssg-test-nodejs-1253653367', /* 必须 */        Region: 'ap-guangzhou'     /* 必须 */    }, function(err, data) {        resolve(data)        console.log(err || data);    });    
  })
}

function putObject() {
  return new Promise((resolve, reject) => {
    cos.putObject({        Bucket: 'bucket-cssg-test-nodejs-1253653367', /* 必须 */        Region: 'ap-guangzhou',    /* 必须 */        Key: 'object4nodejs',              /* 必须 */        StorageClass: 'STANDARD',        Body: fs.createReadStream('./object4nodejs'), // 上传文件对象        onProgress: function(progressData) {            console.log(JSON.stringify(progressData));        }    }, function(err, data) {        assert.ifError(err)        resolve(data)        console.log(err || data);    });    
  })
}

function putObjectAcl() {
  return new Promise((resolve, reject) => {
    cos.putObjectAcl({        Bucket: 'bucket-cssg-test-nodejs-1253653367', /* 必须 */        Region: 'ap-guangzhou',    /* 必须 */        Key: 'object4nodejs',              /* 必须 */        ACL: 'public-read',        /* 非必须 */    }, function(err, data) {        assert.ifError(err)        resolve(data)        console.log(err || data);    });    
  })
}

function putObjectAclUser() {
  return new Promise((resolve, reject) => {
    cos.putObjectAcl({        Bucket: 'bucket-cssg-test-nodejs-1253653367', /* 必须 */        Region: 'ap-guangzhou',    /* 必须 */        Key: 'object4nodejs',              /* 必须 */        GrantFullControl: 'id="1278687956"' // 1278687956是主账号 uin    }, function(err, data) {        assert.ifError(err)        resolve(data)        console.log(err || data);    });    
  })
}

function putObjectAclAcp() {
  return new Promise((resolve, reject) => {
    cos.putObjectAcl({        Bucket: 'bucket-cssg-test-nodejs-1253653367', /* 必须 */        Region: 'ap-guangzhou',    /* 必须 */        Key: 'object4nodejs',              /* 必须 */        AccessControlPolicy: {            "Owner": { // AccessControlPolicy 里必须有 owner                "ID": 'qcs::cam::uin/1278687956:uin/1278687956' // 1278687956 是 Bucket 所属用户的 QQ 号            },            "Grants": [{                "Grantee": {                    "ID": "qcs::cam::uin/100000000011:uin/100000000011", // 100000000011 是 QQ 号                },                "Permission": "WRITE"            }]        }    }, function(err, data) {        assert.ifError(err)        resolve(data)        console.log(err || data);    });    
  })
}

function getObjectAcl() {
  return new Promise((resolve, reject) => {
    cos.getObjectAcl({        Bucket: 'bucket-cssg-test-nodejs-1253653367', /* 必须 */        Region: 'ap-guangzhou',    /* 必须 */        Key: 'object4nodejs',              /* 必须 */    }, function(err, data) {        assert.ifError(err)        resolve(data)        console.log(err || data);    });    
  })
}

function getPresignDownloadUrl() {
    var url = cos.getObjectUrl({        Bucket: 'bucket-cssg-test-nodejs-1253653367',        Region: 'ap-guangzhou',        Key: '1.jpg',        Sign: false    });    
    assert.ok(url)
}

function getPresignDownloadUrlSigned() {
    var url = cos.getObjectUrl({        Bucket: 'bucket-cssg-test-nodejs-1253653367',        Region: 'ap-guangzhou',        Key: '1.jpg'    });    
    assert.ok(url)
}

function getPresignDownloadUrlCallback() {
  return new Promise((resolve, reject) => {
    cos.getObjectUrl({        Bucket: 'bucket-cssg-test-nodejs-1253653367',        Region: 'ap-guangzhou',        Key: '1.jpg',        Sign: false    }, function (err, data) {        assert.ifError(err)        resolve(data)        console.log(err || data.Url);    });    
  })
}

function getPresignDownloadUrlExpiration() {
  return new Promise((resolve, reject) => {
    cos.getObjectUrl({        Bucket: 'bucket-cssg-test-nodejs-1253653367',        Region: 'ap-guangzhou',        Key: '1.jpg',        Sign: true,        Expires: 3600, // 单位秒    }, function (err, data) {        assert.ifError(err)        resolve(data)        console.log(err || data.Url);    });    
  })
}

function getPresignDownloadUrlThenFetch() {
  return new Promise((resolve, reject) => {
    var request = require('request');    var fs = require('fs');    cos.getObjectUrl({        Bucket: 'bucket-cssg-test-nodejs-1253653367',        Region: 'ap-guangzhou',        Key: '1.jpg',        Sign: true    }, function (err, data) {        assert.ifError(err)        resolve(data)        if (!err) return console.log(err);        console.log(data.Url);        var req = request(data.Url, function (err, response, body) {            console.log(err || body);        });        var writeStream = fs.createWriteStream(__dirname + '/1.jpg');        req.pipe(writeStream);    });    
  })
}

function getPresignUploadUrl() {
  return new Promise((resolve, reject) => {
    var request = require('request');    var fs = require('fs');    cos.getObjectUrl({        Bucket: 'bucket-cssg-test-nodejs-1253653367',        Region: 'ap-guangzhou',        Method: 'PUT',        Key: '1.jpg',        Sign: true    }, function (err, data) {        assert.ifError(err)        resolve(data)        if (!err) return console.log(err);        console.log(data.Url);        var readStream = fs.createReadStream(__dirname + '/1.jpg');        var req = request({            method: 'PUT',            url: data.Url,        }, function (err, response, body) {            console.log(err || body);        });        readStream.pipe(req);    });    
  })
}

function deleteMultiObject() {
  return new Promise((resolve, reject) => {
    cos.deleteMultipleObject({        Bucket: 'bucket-cssg-test-nodejs-1253653367', /* 必须 */        Region: 'ap-guangzhou',    /* 必须 */        Objects: [            {Key: 'object4nodejs'},            {Key: 'object4nodejs2'},        ]    }, function(err, data) {        assert.ifError(err)        resolve(data)        console.log(err || data);    });    
  })
}

function restoreObject() {
  return new Promise((resolve, reject) => {
    cos.restoreObject({        Bucket: 'bucket-cssg-test-nodejs-1253653367', /* 必须 */        Region: 'ap-guangzhou',    /* 必须 */        Key: 'object4nodejs',        RestoreRequest: {            Days: 1,            CASJobParameters: {                Tier: 'Expedited'            }        },    }, function(err, data) {        resolve(data)        console.log(err || data);    });    
  })
}

function initMultiUpload() {
  return new Promise((resolve, reject) => {
    cos.multipartInit({        Bucket: 'bucket-cssg-test-nodejs-1253653367', /* 必须 */        Region: 'ap-guangzhou',    /* 必须 */        Key: 'object4nodejs',              /* 必须 */    }, function(err, data) {        assert.ifError(err)        resolve(data)        console.log(err || data);        if (data) {          uploadId = data.UploadId;        }    });    
  })
}

function listMultiUpload() {
  return new Promise((resolve, reject) => {
    cos.multipartList({        Bucket: 'bucket-cssg-test-nodejs-1253653367', /* 必须 */        Region: 'ap-guangzhou',    /* 必须 */        Prefix: 'object4nodejs',                        /* 非必须 */    }, function(err, data) {        assert.ifError(err)        resolve(data)        console.log(err || data);    });    
  })
}

function uploadPart() {
  return new Promise((resolve, reject) => {
    const filePath = tempFilePath // 本地文件路径    cos.multipartUpload({        Bucket: 'bucket-cssg-test-nodejs-1253653367', /* 必须 */        Region: 'ap-guangzhou',    /* 必须 */        Key: 'object4nodejs',       /* 必须 */        ContentLength: '1024',        UploadId: uploadId,        PartNumber: '1',        Body: fs.createReadStream(filePath)    }, function(err, data) {        assert.ifError(err)        resolve(data)        console.log(err || data);        if (data) {          eTag = data.ETag;        }    });    
  })
}

function listParts() {
  return new Promise((resolve, reject) => {
    cos.multipartListPart({        Bucket: 'bucket-cssg-test-nodejs-1253653367', /* 必须 */        Region: 'ap-guangzhou',    /* 必须 */        Key: 'object4nodejs',              /* 必须 */        UploadId: uploadId,                      /* 必须 */    }, function(err, data) {        assert.ifError(err)        resolve(data)        console.log(err || data);    });    
  })
}

function completeMultiUpload() {
  return new Promise((resolve, reject) => {
    cos.multipartComplete({        Bucket: 'bucket-cssg-test-nodejs-1253653367', /* 必须 */        Region: 'ap-guangzhou',    /* 必须 */        Key: 'object4nodejs',              /* 必须 */        UploadId: uploadId, /* 必须 */        Parts: [            {PartNumber: '1', ETag: eTag},        ]    }, function(err, data) {        assert.ifError(err)        resolve(data)        console.log(err || data);    });    
  })
}

function abortMultiUpload() {
  return new Promise((resolve, reject) => {
    cos.multipartAbort({        Bucket: 'bucket-cssg-test-nodejs-1253653367', /* 必须 */        Region: 'ap-guangzhou',    /* 必须 */        Key: 'object4nodejs',                           /* 必须 */        UploadId: uploadId                       /* 必须 */    }, function(err, data) {        assert.ifError(err)        resolve(data)        console.log(err || data);    });    
  })
}

function transferUploadObject() {
  return new Promise((resolve, reject) => {
    const filePath = tempFilePath // 本地文件路径    cos.sliceUploadFile({        Bucket: 'bucket-cssg-test-nodejs-1253653367', /* 必须 */        Region: 'ap-guangzhou',    /* 必须 */        Key: 'object4nodejs',              /* 必须 */        FilePath: filePath,                /* 必须 */        onTaskReady: function(taskId) {                   /* 非必须 */            console.log(taskId);        },        onHashProgress: function (progressData) {       /* 非必须 */            console.log(JSON.stringify(progressData));        },        onProgress: function (progressData) {           /* 非必须 */            console.log(JSON.stringify(progressData));        }    }, function(err, data) {        assert.ifError(err)        resolve(data)        console.log(err || data);    });    
  })
}

function transferCopyObject() {
  return new Promise((resolve, reject) => {
    cos.sliceCopyFile({        Bucket: 'bucket-cssg-test-nodejs-1253653367',                               /* 必须 */        Region: 'ap-guangzhou',                                  /* 必须 */        Key: 'object4nodejs',                                            /* 必须 */        CopySource: 'bucket-cssg-source-1253653367.cos.ap-guangzhou.myqcloud.com/sourceObject', /* 必须 */        onProgress:function (progressData) {                     /* 非必须 */            console.log(JSON.stringify(progressData));        }    },function (err,data) {        assert.ifError(err)        resolve(data)        console.log(err || data);    });    
  })
}

function batchUploadObjects() {
  return new Promise((resolve, reject) => {
    const filePath1 = tempFilePath // 本地文件路径    const filePath2 = tempFilePath // 本地文件路径    cos.uploadFiles({        files: [{            Bucket: 'bucket-cssg-test-nodejs-1253653367',            Region: 'ap-guangzhou',            Key: 'object4nodejs',            FilePath: filePath1,        }, {            Bucket: 'bucket-cssg-test-nodejs-1253653367',            Region: 'ap-guangzhou',            Key: '2.jpg',            FilePath: filePath2,        }],        SliceSize: 1024 * 1024,        onProgress: function (info) {            var percent = parseInt(info.percent * 10000) / 100;            var speed = parseInt(info.speed / 1024 / 1024 * 100) / 100;            console.log('进度：' + percent + '%; 速度：' + speed + 'Mb/s;');        },        onFileFinish: function (err, data, options) {            console.log(options.Key + '上传' + (err ? '失败' : '完成'));        },    }, function (err, data) {        assert.ifError(err)        resolve(data)        console.log(err || data);    });    
  })
}

function copyObject() {
  return new Promise((resolve, reject) => {
    cos.putObjectCopy({        Bucket: 'bucket-cssg-test-nodejs-1253653367',                               /* 必须 */        Region: 'ap-guangzhou',                                  /* 必须 */        Key: 'object4nodejs',                                            /* 必须 */        CopySource: 'bucket-cssg-source-1253653367.cos.ap-guangzhou.myqcloud.com/sourceObject', /* 必须 */    }, function(err, data) {        assert.ifError(err)        resolve(data)        console.log(err || data);    });    
  })
}

function uploadPartCopy() {
  return new Promise((resolve, reject) => {
    cos.uploadPartCopy({        Bucket: 'bucket-cssg-test-nodejs-1253653367', /* 必须 */        Region: 'ap-guangzhou',    /* 必须 */        Key: 'object4nodejs',       /* 必须 */        CopySource: 'bucket-cssg-source-1253653367.cos.ap-guangzhou.myqcloud.com/sourceObject', /* 必须 */        UploadId: uploadId, /* 必须 */        PartNumber: '1', /* 必须 */    }, function(err, data) {        assert.ifError(err)        resolve(data)        console.log(err || data);        if (data) {          eTag = data.ETag;        }    });    
  })
}

function putObjectBuffer() {
  return new Promise((resolve, reject) => {
    cos.putObject({        Bucket: 'bucket-cssg-test-nodejs-1253653367', /* 必须 */        Region: 'ap-guangzhou',    /* 必须 */        Key: 'object4nodejs',              /* 必须 */        Body: Buffer.from('hello!'), /* 必须 */    }, function(err, data) {        assert.ifError(err)        resolve(data)        console.log(err || data);    });    
  })
}

function putObjectString() {
  return new Promise((resolve, reject) => {
    cos.putObject({        Bucket: 'bucket-cssg-test-nodejs-1253653367', /* 必须 */        Region: 'ap-guangzhou',    /* 必须 */        Key: 'object4nodejs',              /* 必须 */        Body: 'hello!',    }, function(err, data) {        assert.ifError(err)        resolve(data)        console.log(err || data);    });    
  })
}

function putObjectFolder() {
  return new Promise((resolve, reject) => {
    cos.putObject({        Bucket: 'bucket-cssg-test-nodejs-1253653367', /* 必须 */        Region: 'ap-guangzhou',    /* 必须 */        Key: 'a/',              /* 必须 */        Body: '',    }, function(err, data) {        assert.ifError(err)        resolve(data)        console.log(err || data);    });    
  })
}

function headObject() {
  return new Promise((resolve, reject) => {
    cos.headObject({        Bucket: 'bucket-cssg-test-nodejs-1253653367', /* 必须 */        Region: 'ap-guangzhou',    /* 必须 */        Key: 'object4nodejs',               /* 必须 */    }, function(err, data) {        assert.ifError(err)        resolve(data)        console.log(err || data);    });    
  })
}

function getObject() {
  return new Promise((resolve, reject) => {
    cos.getObject({        Bucket: 'bucket-cssg-test-nodejs-1253653367', /* 必须 */        Region: 'ap-guangzhou',    /* 必须 */        Key: 'object4nodejs',              /* 必须 */    }, function(err, data) {        assert.ifError(err)        resolve(data)        console.log(err || data.Body);    });    
  })
}

function getObjectRange() {
  return new Promise((resolve, reject) => {
    cos.getObject({        Bucket: 'bucket-cssg-test-nodejs-1253653367', /* 必须 */        Region: 'ap-guangzhou',    /* 必须 */        Key: 'object4nodejs',              /* 必须 */        Range: 'bytes=1-3',        /* 非必须 */    }, function(err, data) {        assert.ifError(err)        resolve(data)        console.log(err || data.Body);    });    
  })
}

function getObjectPath() {
  return new Promise((resolve, reject) => {
    cos.getObject({        Bucket: 'bucket-cssg-test-nodejs-1253653367', /* 必须 */        Region: 'ap-guangzhou',    /* 必须 */        Key: 'object4nodejs',              /* 必须 */        Output: './object4nodejs',    }, function(err, data) {        assert.ifError(err)        resolve(data)        console.log(err || data);    });    
  })
}

function getObjectStream() {
  return new Promise((resolve, reject) => {
    cos.getObject({        Bucket: 'bucket-cssg-test-nodejs-1253653367', /* 必须 */        Region: 'ap-guangzhou',    /* 必须 */        Key: 'object4nodejs',              /* 必须 */        Output: fs.createWriteStream('./object4nodejs'),    }, function(err, data) {        assert.ifError(err)        resolve(data)        console.log(err || data);    });    
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

