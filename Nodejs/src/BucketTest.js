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

function getBucket() {
  return new Promise((resolve, reject) => {
    //.cssg-snippet-body-start:[get-bucket]
    cos.getBucket({
        Bucket: 'bucket-cssg-test-nodejs-1253653367', /* 必须 */
        Region: 'ap-guangzhou',     /* 必须 */
        Prefix: 'a/',           /* 非必须 */
    }, function(err, data) {
        assert.ifError(err)
        resolve(data)
        console.log(err || data.Contents);
    });
    //.cssg-snippet-body-end
  })
}

function getBucketPrefix() {
  return new Promise((resolve, reject) => {
    //.cssg-snippet-body-start:[get-bucket-prefix]
    cos.getBucket({
        Bucket: 'bucket-cssg-test-nodejs-1253653367', /* 必须 */
        Region: 'ap-guangzhou',    /* 必须 */
        Prefix: 'a/',              /* 非必须 */
        Delimiter: '/',            /* 非必须 */
    }, function(err, data) {
        assert.ifError(err)
        resolve(data)
        console.log(err || data.CommonPrefixes);
    });
    //.cssg-snippet-body-end
  })
}

function headBucket() {
  return new Promise((resolve, reject) => {
    //.cssg-snippet-body-start:[head-bucket]
    cos.headBucket({
        Bucket: 'bucket-cssg-test-nodejs-1253653367',
        Region: 'ap-guangzhou',
    }, function(err, data) {
        assert.ifError(err)
        resolve(data)
        if (err) {
            console.log(err.error);
        }
    });
    //.cssg-snippet-body-end
  })
}

function putBucketAcl() {
  return new Promise((resolve, reject) => {
    //.cssg-snippet-body-start:[put-bucket-acl]
    cos.putBucketAcl({
        Bucket: 'bucket-cssg-test-nodejs-1253653367', /* 必须 */
        Region: 'ap-guangzhou',    /* 必须 */
        ACL: 'public-read'
    }, function(err, data) {
        assert.ifError(err)
        resolve(data)
        console.log(err || data);
    });
    //.cssg-snippet-body-end
  })
}

function putBucketAclUser() {
  return new Promise((resolve, reject) => {
    //.cssg-snippet-body-start:[put-bucket-acl-user]
    cos.putBucketAcl({
        Bucket: 'bucket-cssg-test-nodejs-1253653367', /* 必须 */
        Region: 'ap-guangzhou',    /* 必须 */
        GrantFullControl: 'id="qcs::cam::uin/1278687956:uin/1278687956",id="qcs::cam::uin/100000000011:uin/100000000011"' // 1278687956是 uin
    }, function(err, data) {
        assert.ifError(err)
        resolve(data)
        console.log(err || data);
    });
    //.cssg-snippet-body-end
  })
}

function putBucketAclAcp() {
  return new Promise((resolve, reject) => {
    //.cssg-snippet-body-start:[put-bucket-acl-acp]
    cos.putBucketAcl({
        Bucket: 'bucket-cssg-test-nodejs-1253653367', /* 必须 */
        Region: 'ap-guangzhou',    /* 必须 */
        AccessControlPolicy: {
            "Owner": { // AccessControlPolicy 里必须有 owner
                "ID": 'qcs::cam::uin/1278687956:uin/1278687956' // 1278687956 是 Bucket 所属用户的 Uin
            },
            "Grants": [{
                "Grantee": {
                    "ID": "qcs::cam::uin/100000000011:uin/100000000011", // 100000000011 是 Uin
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

function getBucketAcl() {
  return new Promise((resolve, reject) => {
    //.cssg-snippet-body-start:[get-bucket-acl]
    cos.getBucketAcl({
        Bucket: 'bucket-cssg-test-nodejs-1253653367', /* 必须 */
        Region: 'ap-guangzhou'     /* 必须 */
    }, function(err, data) {
        assert.ifError(err)
        resolve(data)
        console.log(err || data);
    });
    //.cssg-snippet-body-end
  })
}

function putBucketPolicy() {
  return new Promise((resolve, reject) => {
    //.cssg-snippet-body-start:[put-bucket-policy]
    cos.putBucketPolicy({
        Bucket: 'bucket-cssg-test-nodejs-1253653367', /* 必须 */
        Region: 'ap-guangzhou',    /* 必须 */
        Policy: {
            "version": "2.0",
            "Statement": [{
                "Effect": "allow",
                "Principal": {
                    "qcs": ["qcs::cam::uin/1278687956:uin/1278687956"]
                },
                "Action": [
                    "name/cos:PutObject",
                    "name/cos:InitiateMultipartUpload",
                    "name/cos:ListMultipartUploads",
                    "name/cos:ListParts",
                    "name/cos:UploadPart",
                    "name/cos:CompleteMultipartUpload"
                ],
                "Resource": ["qcs::cos:ap-guangzhou:uid/1253653367:bucket-cssg-test-nodejs-1253653367/*"],
            }]
        },
    }, function(err, data) {
        assert.ifError(err)
        resolve(data)
        console.log(err || data);
    });
    //.cssg-snippet-body-end
  })
}

function getBucketPolicy() {
  return new Promise((resolve, reject) => {
    //.cssg-snippet-body-start:[get-bucket-policy]
    cos.getBucketPolicy({
        Bucket: 'bucket-cssg-test-nodejs-1253653367', /* 必须 */
        Region: 'ap-guangzhou',    /* 必须 */
    }, function(err, data) {
        assert.ifError(err)
        resolve(data)
        console.log(err || data);
    });
    //.cssg-snippet-body-end
  })
}

function deleteBucketPolicy() {
  return new Promise((resolve, reject) => {
    //.cssg-snippet-body-start:[delete-bucket-policy]
    cos.deleteBucketPolicy({
        Bucket: 'bucket-cssg-test-nodejs-1253653367', /* 必须 */
        Region: 'ap-guangzhou',    /* 必须 */
    }, function(err, data) {
        assert.ifError(err)
        resolve(data)
        console.log(err || data);
    });
    //.cssg-snippet-body-end
  })
}

function putBucketCors() {
  return new Promise((resolve, reject) => {
    //.cssg-snippet-body-start:[put-bucket-cors]
    cos.putBucketCors({
        Bucket: 'bucket-cssg-test-nodejs-1253653367', /* 必须 */
        Region: 'ap-guangzhou',    /* 必须 */
        CORSRules: [{
            "AllowedOrigin": ["*"],
            "AllowedMethod": ["GET", "POST", "PUT", "DELETE", "HEAD"],
            "AllowedHeader": ["*"],
            "ExposeHeader": ["ETag", "x-cos-acl", "x-cos-version-id", "x-cos-delete-marker", "x-cos-server-side-encryption"],
            "MaxAgeSeconds": "5"
        }]
    }, function(err, data) {
        assert.ifError(err)
        resolve(data)
        console.log(err || data);
    });
    //.cssg-snippet-body-end
  })
}

function getBucketCors() {
  return new Promise((resolve, reject) => {
    //.cssg-snippet-body-start:[get-bucket-cors]
    cos.getBucketCors({
        Bucket: 'bucket-cssg-test-nodejs-1253653367', /* 必须 */
        Region: 'ap-guangzhou',    /* 必须 */
    }, function(err, data) {
        assert.ifError(err)
        resolve(data)
        console.log(err || data);
    });
    //.cssg-snippet-body-end
  })
}

function optionObject() {
  return new Promise((resolve, reject) => {
    //.cssg-snippet-body-start:[option-object]
    cos.optionsObject({
        Bucket: 'bucket-cssg-test-nodejs-1253653367', /* 必须 */
        Region: 'ap-guangzhou',    /* 必须 */
        Key: 'object4nodejs',              /* 必须 */
        Origin: 'https://www.qq.com',      /* 必须 */
        AccessControlRequestMethod: 'PUT', /* 必须 */
        AccessControlRequestHeaders: 'origin,accept,content-type' /* 非必须 */
    }, function(err, data) {
        assert.ifError(err)
        resolve(data)
        console.log(err || data);
    });
    //.cssg-snippet-body-end
  })
}

function deleteBucketCors() {
  return new Promise((resolve, reject) => {
    //.cssg-snippet-body-start:[delete-bucket-cors]
    cos.deleteBucketCors({
        Bucket: 'bucket-cssg-test-nodejs-1253653367', /* 必须 */
        Region: 'ap-guangzhou',    /* 必须 */
    }, function(err, data) {
        assert.ifError(err)
        resolve(data)
        console.log(err || data);
    });
    //.cssg-snippet-body-end
  })
}

function putBucketLifecycle() {
  return new Promise((resolve, reject) => {
    //.cssg-snippet-body-start:[put-bucket-lifecycle]
    cos.putBucketLifecycle({
        Bucket: 'bucket-cssg-test-nodejs-1253653367', /* 必须 */
        Region: 'ap-guangzhou',    /* 必须 */
        Rules: [{
            "ID": "1",
            "Status": "Enabled",
            "Filter": {},
            "Transition": {
                "Days": "30",
                "StorageClass": "STANDARD_IA"
            }
        }],
    }, function(err, data) {
        assert.ifError(err)
        resolve(data)
        console.log(err || data);
    });
    //.cssg-snippet-body-end
  })
}

function putBucketLifecycleArchive() {
  return new Promise((resolve, reject) => {
    //.cssg-snippet-body-start:[put-bucket-lifecycle-archive]
    cos.putBucketLifecycle({
        Bucket: 'bucket-cssg-test-nodejs-1253653367', /* 必须 */
        Region: 'ap-guangzhou',    /* 必须 */
        Rules: [{
            "ID": "2",
            "Filter": {
                "Prefix": "dir/",
            },
            "Status": "Enabled",
            "Transition": {
                "Days": "90",
                "StorageClass": "ARCHIVE"
            }
        }],
    }, function(err, data) {
        assert.ifError(err)
        resolve(data)
        console.log(err || data);
    });
    //.cssg-snippet-body-end
  })
}

function putBucketLifecycleExpired() {
  return new Promise((resolve, reject) => {
    //.cssg-snippet-body-start:[put-bucket-lifecycle-expired]
    cos.putBucketLifecycle({
        Bucket: 'bucket-cssg-test-nodejs-1253653367', /* 必须 */
        Region: 'ap-guangzhou',    /* 必须 */
        Rules: [{
            "ID": "3",
            "Status": "Enabled",
            "Filter": {},
            "Expiration": {
                "Days": "180"
            }
        }],
    }, function(err, data) {
        assert.ifError(err)
        resolve(data)
        console.log(err || data);
    });
    //.cssg-snippet-body-end
  })
}

function putBucketLifecycleCleanAbort() {
  return new Promise((resolve, reject) => {
    //.cssg-snippet-body-start:[put-bucket-lifecycle-cleanAbort]
    cos.putBucketLifecycle({
        Bucket: 'bucket-cssg-test-nodejs-1253653367', /* 必须 */
        Region: 'ap-guangzhou',    /* 必须 */
        Rules: [{
            "ID": "4",
            "Status": "Enabled",
            "Filter": {},
            "AbortIncompleteMultipartUpload": {
                "DaysAfterInitiation": "30"
            }
        }],
    }, function(err, data) {
        assert.ifError(err)
        resolve(data)
        console.log(err || data);
    });
    //.cssg-snippet-body-end
  })
}

function putBucketLifecycleHistoryArchive() {
  return new Promise((resolve, reject) => {
    //.cssg-snippet-body-start:[put-bucket-lifecycle-historyArchive]
    cos.putBucketLifecycle({
        Bucket: 'bucket-cssg-test-nodejs-1253653367', /* 必须 */
        Region: 'ap-guangzhou',    /* 必须 */
        Rules: [{
            "ID": "5",
            "Status": "Enabled",
            "Filter": {},
            "NoncurrentVersionTransition": {
                "NoncurrentDays": "30",
                "StorageClass": 'ARCHIVE'
            }
        }],
    }, function(err, data) {
        assert.ifError(err)
        resolve(data)
        console.log(err || data);
    });
    //.cssg-snippet-body-end
  })
}

function getBucketLifecycle() {
  return new Promise((resolve, reject) => {
    //.cssg-snippet-body-start:[get-bucket-lifecycle]
    cos.getBucketLifecycle({
        Bucket: 'bucket-cssg-test-nodejs-1253653367', /* 必须 */
        Region: 'ap-guangzhou',    /* 必须 */
    }, function(err, data) {
        assert.ifError(err)
        resolve(data)
        console.log(err || data);
    });
    //.cssg-snippet-body-end
  })
}

function deleteBucketLifecycle() {
  return new Promise((resolve, reject) => {
    //.cssg-snippet-body-start:[delete-bucket-lifecycle]
    cos.deleteBucketLifecycle({
        Bucket: 'bucket-cssg-test-nodejs-1253653367', /* 必须 */
        Region: 'ap-guangzhou',    /* 必须 */
    }, function(err, data) {
        assert.ifError(err)
        resolve(data)
        console.log(err || data);
    });
    //.cssg-snippet-body-end
  })
}

function putBucketVersioning() {
  return new Promise((resolve, reject) => {
    //.cssg-snippet-body-start:[put-bucket-versioning]
    cos.putBucketVersioning({
        Bucket: 'bucket-cssg-test-nodejs-1253653367',  /* 必须 */
        Region: 'ap-guangzhou',     /* 必须 */
        VersioningConfiguration: {
            Status: "Enabled"
        }
    }, function (err, data) {
        assert.ifError(err)
        resolve(data)
        console.log(err || data);
    });
    //.cssg-snippet-body-end
  })
}

function getBucketVersioning() {
  return new Promise((resolve, reject) => {
    //.cssg-snippet-body-start:[get-bucket-versioning]
    cos.getBucketVersioning({
        Bucket: 'bucket-cssg-test-nodejs-1253653367',  /* 必须 */
        Region: 'ap-guangzhou',     /* 必须 */
    }, function (err, data) {
        assert.ifError(err)
        resolve(data)
        console.log(err || data);
    });
    //.cssg-snippet-body-end
  })
}

function putBucketReplication() {
  return new Promise((resolve, reject) => {
    //.cssg-snippet-body-start:[put-bucket-replication]
    cos.putBucketReplication({
        Bucket: 'bucket-cssg-test-nodejs-1253653367',  /* 必须 */
        Region: 'ap-guangzhou',     /* 必须 */
        ReplicationConfiguration: { /* 必须 */
            Role: "qcs::cam::uin/1278687956:uin/1278687956",
            Rules: [{
                ID: "1",
                Status: "Enabled",
                Prefix: "sync/",
                Destination: {
                    Bucket: "qcs::cos:ap-beijing::bucket-cssg-assist-1253653367",
                    StorageClass: "Standard",
                }
            }]
        }
    }, function (err, data) {
        assert.ifError(err)
        resolve(data)
        console.log(err || data);
    });
    //.cssg-snippet-body-end
  })
}

function getBucketReplication() {
  return new Promise((resolve, reject) => {
    //.cssg-snippet-body-start:[get-bucket-replication]
    cos.getBucketReplication({
        Bucket: 'bucket-cssg-test-nodejs-1253653367', /* 必须 */
        Region: 'ap-guangzhou',    /* 必须 */
    }, function(err, data) {
        assert.ifError(err)
        resolve(data)
        console.log(err || data);
    });
    //.cssg-snippet-body-end
  })
}

function deleteBucketReplication() {
  return new Promise((resolve, reject) => {
    //.cssg-snippet-body-start:[delete-bucket-replication]
    cos.deleteBucketReplication({
        Bucket: 'bucket-cssg-test-nodejs-1253653367', /* 必须 */
        Region: 'ap-guangzhou',    /* 必须 */
    }, function(err, data) {
        assert.ifError(err)
        resolve(data)
        console.log(err || data);
    });
    //.cssg-snippet-body-end
  })
}

function putBucketTagging() {
  return new Promise((resolve, reject) => {
    //.cssg-snippet-body-start:[put-bucket-tagging]
    cos.putBucketTagging({
        Bucket: 'bucket-cssg-test-nodejs-1253653367', /* 必须 */
        Region: 'ap-guangzhou',    /* 必须 */
        Tagging: {
            "Tags": [
                {"Key": "k1", "Value": "v1"},
                {"Key": "k2", "Value": "v2"}
            ]
        }
    }, function(err, data) {
        assert.ifError(err)
        resolve(data)
        console.log(err || data);
    });
    //.cssg-snippet-body-end
  })
}

function getBucketTagging() {
  return new Promise((resolve, reject) => {
    //.cssg-snippet-body-start:[get-bucket-tagging]
    cos.getBucketTagging({
        Bucket: 'bucket-cssg-test-nodejs-1253653367', /* 必须 */
        Region: 'ap-guangzhou',    /* 必须 */
    }, function(err, data) {
        assert.ifError(err)
        resolve(data)
        console.log(err || data);
    });
    //.cssg-snippet-body-end
  })
}

function deleteBucketTagging() {
  return new Promise((resolve, reject) => {
    //.cssg-snippet-body-start:[delete-bucket-tagging]
    cos.deleteBucketTagging({
        Bucket: 'bucket-cssg-test-nodejs-1253653367', /* 必须 */
        Region: 'ap-guangzhou',    /* 必须 */
    }, function(err, data) {
        assert.ifError(err)
        resolve(data)
        console.log(err || data);
    });
    //.cssg-snippet-body-end
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
