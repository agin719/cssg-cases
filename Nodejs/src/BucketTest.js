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

function putBucket() {
  return new Promise((resolve, reject) => {
    cos.putBucket({        Bucket: 'bucket-cssg-test-nodejs-1253653367',        Region: 'ap-guangzhou'    }, function(err, data) {        resolve(data)        console.log(err || data);    });    
  })
}

function deleteBucket() {
  return new Promise((resolve, reject) => {
    cos.deleteBucket({        Bucket: 'bucket-cssg-test-nodejs-1253653367', /* 必须 */        Region: 'ap-guangzhou'     /* 必须 */    }, function(err, data) {        resolve(data)        console.log(err || data);    });    
  })
}

function getBucket() {
  return new Promise((resolve, reject) => {
    cos.getBucket({        Bucket: 'bucket-cssg-test-nodejs-1253653367', /* 必须 */        Region: 'ap-guangzhou',     /* 必须 */        Prefix: 'a/',           /* 非必须 */    }, function(err, data) {        assert.ifError(err)        resolve(data)        console.log(err || data.Contents);    });    
  })
}

function getBucketPrefix() {
  return new Promise((resolve, reject) => {
    cos.getBucket({        Bucket: 'bucket-cssg-test-nodejs-1253653367', /* 必须 */        Region: 'ap-guangzhou',    /* 必须 */        Prefix: 'a/',              /* 非必须 */        Delimiter: '/',            /* 非必须 */    }, function(err, data) {        assert.ifError(err)        resolve(data)        console.log(err || data.CommonPrefixes);    });    
  })
}

function headBucket() {
  return new Promise((resolve, reject) => {
    cos.headBucket({        Bucket: 'bucket-cssg-test-nodejs-1253653367',        Region: 'ap-guangzhou',    }, function(err, data) {        assert.ifError(err)        resolve(data)        if (err) {            console.log(err.error);        }    });    
  })
}

function putBucketAcl() {
  return new Promise((resolve, reject) => {
    cos.putBucketAcl({        Bucket: 'bucket-cssg-test-nodejs-1253653367', /* 必须 */        Region: 'ap-guangzhou',    /* 必须 */        ACL: 'public-read'    }, function(err, data) {        assert.ifError(err)        resolve(data)        console.log(err || data);    });    
  })
}

function putBucketAclUser() {
  return new Promise((resolve, reject) => {
    cos.putBucketAcl({        Bucket: 'bucket-cssg-test-nodejs-1253653367', /* 必须 */        Region: 'ap-guangzhou',    /* 必须 */        GrantFullControl: 'id="qcs::cam::uin/1278687956:uin/1278687956",id="qcs::cam::uin/100000000011:uin/100000000011"' // 1278687956是 uin    }, function(err, data) {        assert.ifError(err)        resolve(data)        console.log(err || data);    });    
  })
}

function putBucketAclAcp() {
  return new Promise((resolve, reject) => {
    cos.putBucketAcl({        Bucket: 'bucket-cssg-test-nodejs-1253653367', /* 必须 */        Region: 'ap-guangzhou',    /* 必须 */        AccessControlPolicy: {            "Owner": { // AccessControlPolicy 里必须有 owner                "ID": 'qcs::cam::uin/1278687956:uin/1278687956' // 1278687956 是 Bucket 所属用户的 Uin            },            "Grants": [{                "Grantee": {                    "ID": "qcs::cam::uin/100000000011:uin/100000000011", // 100000000011 是 Uin                },                "Permission": "WRITE"            }]        }    }, function(err, data) {        assert.ifError(err)        resolve(data)        console.log(err || data);    });    
  })
}

function getBucketAcl() {
  return new Promise((resolve, reject) => {
    cos.getBucketAcl({        Bucket: 'bucket-cssg-test-nodejs-1253653367', /* 必须 */        Region: 'ap-guangzhou'     /* 必须 */    }, function(err, data) {        assert.ifError(err)        resolve(data)        console.log(err || data);    });    
  })
}

function putBucketPolicy() {
  return new Promise((resolve, reject) => {
    cos.putBucketPolicy({        Bucket: 'bucket-cssg-test-nodejs-1253653367', /* 必须 */        Region: 'ap-guangzhou',    /* 必须 */        Policy: {            "version": "2.0",            "Statement": [{                "Effect": "allow",                "Principal": {                    "qcs": ["qcs::cam::uin/1278687956:uin/1278687956"]                },                "Action": [                    "name/cos:PutObject",                    "name/cos:InitiateMultipartUpload",                    "name/cos:ListMultipartUploads",                    "name/cos:ListParts",                    "name/cos:UploadPart",                    "name/cos:CompleteMultipartUpload"                ],                "Resource": ["qcs::cos:ap-guangzhou:uid/1253653367:bucket-cssg-test-nodejs-1253653367/*"],            }]        },    }, function(err, data) {        assert.ifError(err)        resolve(data)        console.log(err || data);    });    
  })
}

function getBucketPolicy() {
  return new Promise((resolve, reject) => {
    cos.getBucketPolicy({        Bucket: 'bucket-cssg-test-nodejs-1253653367', /* 必须 */        Region: 'ap-guangzhou',    /* 必须 */    }, function(err, data) {        assert.ifError(err)        resolve(data)        console.log(err || data);    });    
  })
}

function deleteBucketPolicy() {
  return new Promise((resolve, reject) => {
    cos.deleteBucketPolicy({        Bucket: 'bucket-cssg-test-nodejs-1253653367', /* 必须 */        Region: 'ap-guangzhou',    /* 必须 */    }, function(err, data) {        assert.ifError(err)        resolve(data)        console.log(err || data);    });    
  })
}

function putBucketCors() {
  return new Promise((resolve, reject) => {
    cos.putBucketCors({        Bucket: 'bucket-cssg-test-nodejs-1253653367', /* 必须 */        Region: 'ap-guangzhou',    /* 必须 */        CORSRules: [{            "AllowedOrigin": ["*"],            "AllowedMethod": ["GET", "POST", "PUT", "DELETE", "HEAD"],            "AllowedHeader": ["*"],            "ExposeHeader": ["ETag", "x-cos-acl", "x-cos-version-id", "x-cos-delete-marker", "x-cos-server-side-encryption"],            "MaxAgeSeconds": "5"        }]    }, function(err, data) {        assert.ifError(err)        resolve(data)        console.log(err || data);    });    
  })
}

function getBucketCors() {
  return new Promise((resolve, reject) => {
    cos.getBucketCors({        Bucket: 'bucket-cssg-test-nodejs-1253653367', /* 必须 */        Region: 'ap-guangzhou',    /* 必须 */    }, function(err, data) {        assert.ifError(err)        resolve(data)        console.log(err || data);    });    
  })
}

function optionObject() {
  return new Promise((resolve, reject) => {
    cos.optionsObject({        Bucket: 'bucket-cssg-test-nodejs-1253653367', /* 必须 */        Region: 'ap-guangzhou',    /* 必须 */        Key: 'object4nodejs',              /* 必须 */        Origin: 'https://www.qq.com',      /* 必须 */        AccessControlRequestMethod: 'PUT', /* 必须 */        AccessControlRequestHeaders: 'origin,accept,content-type' /* 非必须 */    }, function(err, data) {        assert.ifError(err)        resolve(data)        console.log(err || data);    });    
  })
}

function deleteBucketCors() {
  return new Promise((resolve, reject) => {
    cos.deleteBucketCors({        Bucket: 'bucket-cssg-test-nodejs-1253653367', /* 必须 */        Region: 'ap-guangzhou',    /* 必须 */    }, function(err, data) {        assert.ifError(err)        resolve(data)        console.log(err || data);    });    
  })
}

function putBucketLifecycle() {
  return new Promise((resolve, reject) => {
    cos.putBucketLifecycle({        Bucket: 'bucket-cssg-test-nodejs-1253653367', /* 必须 */        Region: 'ap-guangzhou',    /* 必须 */        Rules: [{            "ID": "1",            "Status": "Enabled",            "Filter": {},            "Transition": {                "Days": "30",                "StorageClass": "STANDARD_IA"            }        }],    }, function(err, data) {        assert.ifError(err)        resolve(data)        console.log(err || data);    });    
  })
}

function putBucketLifecycleArchive() {
  return new Promise((resolve, reject) => {
    cos.putBucketLifecycle({        Bucket: 'bucket-cssg-test-nodejs-1253653367', /* 必须 */        Region: 'ap-guangzhou',    /* 必须 */        Rules: [{            "ID": "2",            "Filter": {                "Prefix": "dir/",            },            "Status": "Enabled",            "Transition": {                "Days": "90",                "StorageClass": "ARCHIVE"            }        }],    }, function(err, data) {        assert.ifError(err)        resolve(data)        console.log(err || data);    });    
  })
}

function putBucketLifecycleExpired() {
  return new Promise((resolve, reject) => {
    cos.putBucketLifecycle({        Bucket: 'bucket-cssg-test-nodejs-1253653367', /* 必须 */        Region: 'ap-guangzhou',    /* 必须 */        Rules: [{            "ID": "3",            "Status": "Enabled",            "Filter": {},            "Expiration": {                "Days": "180"            }        }],    }, function(err, data) {        assert.ifError(err)        resolve(data)        console.log(err || data);    });    
  })
}

function putBucketLifecycleCleanAbort() {
  return new Promise((resolve, reject) => {
    cos.putBucketLifecycle({        Bucket: 'bucket-cssg-test-nodejs-1253653367', /* 必须 */        Region: 'ap-guangzhou',    /* 必须 */        Rules: [{            "ID": "4",            "Status": "Enabled",            "Filter": {},            "AbortIncompleteMultipartUpload": {                "DaysAfterInitiation": "30"            }        }],    }, function(err, data) {        assert.ifError(err)        resolve(data)        console.log(err || data);    });    
  })
}

function putBucketLifecycleHistoryArchive() {
  return new Promise((resolve, reject) => {
    cos.putBucketLifecycle({        Bucket: 'bucket-cssg-test-nodejs-1253653367', /* 必须 */        Region: 'ap-guangzhou',    /* 必须 */        Rules: [{            "ID": "5",            "Status": "Enabled",            "Filter": {},            "NoncurrentVersionTransition": {                "NoncurrentDays": "30",                "StorageClass": 'ARCHIVE'            }        }],    }, function(err, data) {        assert.ifError(err)        resolve(data)        console.log(err || data);    });    
  })
}

function getBucketLifecycle() {
  return new Promise((resolve, reject) => {
    cos.getBucketLifecycle({        Bucket: 'bucket-cssg-test-nodejs-1253653367', /* 必须 */        Region: 'ap-guangzhou',    /* 必须 */    }, function(err, data) {        assert.ifError(err)        resolve(data)        console.log(err || data);    });    
  })
}

function deleteBucketLifecycle() {
  return new Promise((resolve, reject) => {
    cos.deleteBucketLifecycle({        Bucket: 'bucket-cssg-test-nodejs-1253653367', /* 必须 */        Region: 'ap-guangzhou',    /* 必须 */    }, function(err, data) {        assert.ifError(err)        resolve(data)        console.log(err || data);    });    
  })
}

function putBucketVersioning() {
  return new Promise((resolve, reject) => {
    cos.putBucketVersioning({        Bucket: 'bucket-cssg-test-nodejs-1253653367',  /* 必须 */        Region: 'ap-guangzhou',     /* 必须 */        VersioningConfiguration: {            Status: "Enabled"        }    }, function (err, data) {        assert.ifError(err)        resolve(data)        console.log(err || data);    });    
  })
}

function getBucketVersioning() {
  return new Promise((resolve, reject) => {
    cos.getBucketVersioning({        Bucket: 'bucket-cssg-test-nodejs-1253653367',  /* 必须 */        Region: 'ap-guangzhou',     /* 必须 */    }, function (err, data) {        assert.ifError(err)        resolve(data)        console.log(err || data);    });    
  })
}

function putBucketReplication() {
  return new Promise((resolve, reject) => {
    cos.putBucketReplication({        Bucket: 'bucket-cssg-test-nodejs-1253653367',  /* 必须 */        Region: 'ap-guangzhou',     /* 必须 */        ReplicationConfiguration: { /* 必须 */            Role: "qcs::cam::uin/1278687956:uin/1278687956",            Rules: [{                ID: "1",                Status: "Enabled",                Prefix: "sync/",                Destination: {                    Bucket: "qcs::cos:ap-beijing::bucket-cssg-assist-1253653367",                    StorageClass: "Standard",                }            }]        }    }, function (err, data) {        assert.ifError(err)        resolve(data)        console.log(err || data);    });    
  })
}

function getBucketReplication() {
  return new Promise((resolve, reject) => {
    cos.getBucketReplication({        Bucket: 'bucket-cssg-test-nodejs-1253653367', /* 必须 */        Region: 'ap-guangzhou',    /* 必须 */    }, function(err, data) {        assert.ifError(err)        resolve(data)        console.log(err || data);    });    
  })
}

function deleteBucketReplication() {
  return new Promise((resolve, reject) => {
    cos.deleteBucketReplication({        Bucket: 'bucket-cssg-test-nodejs-1253653367', /* 必须 */        Region: 'ap-guangzhou',    /* 必须 */    }, function(err, data) {        assert.ifError(err)        resolve(data)        console.log(err || data);    });    
  })
}

function putBucketTagging() {
  return new Promise((resolve, reject) => {
    cos.putBucketTagging({        Bucket: 'bucket-cssg-test-nodejs-1253653367', /* 必须 */        Region: 'ap-guangzhou',    /* 必须 */        Tagging: {            "Tags": [                {"Key": "k1", "Value": "v1"},                {"Key": "k2", "Value": "v2"}            ]        }    }, function(err, data) {        assert.ifError(err)        resolve(data)        console.log(err || data);    });    
  })
}

function getBucketTagging() {
  return new Promise((resolve, reject) => {
    cos.getBucketTagging({        Bucket: 'bucket-cssg-test-nodejs-1253653367', /* 必须 */        Region: 'ap-guangzhou',    /* 必须 */    }, function(err, data) {        assert.ifError(err)        resolve(data)        console.log(err || data);    });    
  })
}

function deleteBucketTagging() {
  return new Promise((resolve, reject) => {
    cos.deleteBucketTagging({        Bucket: 'bucket-cssg-test-nodejs-1253653367', /* 必须 */        Region: 'ap-guangzhou',    /* 必须 */    }, function(err, data) {        assert.ifError(err)        resolve(data)        console.log(err || data);    });    
  })
}



describe("testBucketACL", function() {
  it("getBucket", function() {
    return getBucket()
  })
  it("getBucketPrefix", function() {
    return getBucketPrefix()
  })
  it("headBucket", function() {
    return headBucket()
  })
  it("putBucketAcl", function() {
    return putBucketAcl()
  })
  it("putBucketAclUser", function() {
    return putBucketAclUser()
  })
  it("putBucketAclAcp", function() {
    return putBucketAclAcp()
  })
  it("getBucketAcl", function() {
    return getBucketAcl()
  })
})
describe("testBucketPolicy", function() {
  it("putBucketPolicy", function() {
    return putBucketPolicy()
  })
  it("getBucketPolicy", function() {
    return getBucketPolicy()
  })
  it("deleteBucketPolicy", function() {
    return deleteBucketPolicy()
  })
})
describe("testBucketCORS", function() {
  it("putBucketCors", function() {
    return putBucketCors()
  })
  it("getBucketCors", function() {
    return getBucketCors()
  })
  it("optionObject", function() {
    return optionObject()
  })
  it("deleteBucketCors", function() {
    return deleteBucketCors()
  })
})
describe("testBucketLifecycle", function() {
  it("putBucketLifecycle", function() {
    return putBucketLifecycle()
  })
  it("putBucketLifecycleArchive", function() {
    return putBucketLifecycleArchive()
  })
  it("putBucketLifecycleExpired", function() {
    return putBucketLifecycleExpired()
  })
  it("putBucketLifecycleCleanAbort", function() {
    return putBucketLifecycleCleanAbort()
  })
  it("putBucketLifecycleHistoryArchive", function() {
    return putBucketLifecycleHistoryArchive()
  })
  it("getBucketLifecycle", function() {
    return getBucketLifecycle()
  })
  it("deleteBucketLifecycle", function() {
    return deleteBucketLifecycle()
  })
})
describe("testBucketReplicationAndVersioning", function() {
  it("putBucketVersioning", function() {
    return putBucketVersioning()
  })
  it("getBucketVersioning", function() {
    return getBucketVersioning()
  })
  it("putBucketReplication", function() {
    return putBucketReplication()
  })
  it("getBucketReplication", function() {
    return getBucketReplication()
  })
  it("deleteBucketReplication", function() {
    return deleteBucketReplication()
  })
})
describe("testBucketTagging", function() {
  it("putBucketTagging", function() {
    return putBucketTagging()
  })
  it("getBucketTagging", function() {
    return getBucketTagging()
  })
  it("deleteBucketTagging", function() {
    return deleteBucketTagging()
  })
})

describe("CleanBucket", function() {
  it("deleteBucket", function() {
    return deleteBucket()
  })
  it("putBucket", function() {
    return putBucket()
  })
})
