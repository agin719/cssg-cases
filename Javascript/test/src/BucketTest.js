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

function getBucket(assert) {
  return new Promise((resolve, reject) => {
    //.cssg-snippet-body-start:[get-bucket]
    cos.getBucket({
        Bucket: 'bucket-cssg-test-js-1253653367', /* 必须 */
        Region: 'ap-guangzhou',     /* 存储桶所在地域，必须字段 */
        Prefix: 'a/',           /* 非必须 */
    }, function(err, data) {
        assert.notOk(err)
        resolve(data)
        console.log(err || data.Contents);
    });
    //.cssg-snippet-body-end
  })
}

function getBucketPrefix(assert) {
  return new Promise((resolve, reject) => {
    //.cssg-snippet-body-start:[get-bucket-prefix]
    cos.getBucket({
        Bucket: 'bucket-cssg-test-js-1253653367', /* 必须 */
        Region: 'ap-guangzhou',     /* 存储桶所在地域，必须字段 */
        Prefix: 'a/',              /* 非必须 */
        Delimiter: '/',            /* 非必须 */
    }, function(err, data) {
        assert.notOk(err)
        resolve(data)
        console.log(err || data.CommonPrefixes);
    });
    //.cssg-snippet-body-end
  })
}

function headBucket(assert) {
  return new Promise((resolve, reject) => {
    //.cssg-snippet-body-start:[head-bucket]
    cos.headBucket({
        Bucket: 'bucket-cssg-test-js-1253653367',
        Region: 'ap-guangzhou',     /* 存储桶所在地域，必须字段 */
    }, function(err, data) {
        assert.notOk(err)
        resolve(data)
        if (err) {
            console.log(err.error);
        }
    });
    //.cssg-snippet-body-end
  })
}

function putBucketAcl(assert) {
  return new Promise((resolve, reject) => {
    //.cssg-snippet-body-start:[put-bucket-acl]
    cos.putBucketAcl({
        Bucket: 'bucket-cssg-test-js-1253653367', /* 必须 */
        Region: 'ap-guangzhou',     /* 存储桶所在地域，必须字段 */
        ACL: 'public-read'
    }, function(err, data) {
        assert.notOk(err)
        resolve(data)
        console.log(err || data);
    });
    //.cssg-snippet-body-end
  })
}

function putBucketAclUser(assert) {
  return new Promise((resolve, reject) => {
    //.cssg-snippet-body-start:[put-bucket-acl-user]
    cos.putBucketAcl({
        Bucket: 'bucket-cssg-test-js-1253653367', /* 必须 */
        Region: 'ap-guangzhou',     /* 存储桶所在地域，必须字段 */
        GrantFullControl: 'id="qcs::cam::uin/1278687956:uin/1278687956",id="qcs::cam::uin/100000000011:uin/100000000011"' // 1278687956是 uin
    }, function(err, data) {
        assert.notOk(err)
        resolve(data)
        console.log(err || data);
    });
    //.cssg-snippet-body-end
  })
}

function putBucketAclAcp(assert) {
  return new Promise((resolve, reject) => {
    //.cssg-snippet-body-start:[put-bucket-acl-acp]
    cos.putBucketAcl({
        Bucket: 'bucket-cssg-test-js-1253653367', /* 必须 */
        Region: 'ap-guangzhou',     /* 存储桶所在地域，必须字段 */
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
        assert.notOk(err)
        resolve(data)
        console.log(err || data);
    });
    //.cssg-snippet-body-end
  })
}

function getBucketAcl(assert) {
  return new Promise((resolve, reject) => {
    //.cssg-snippet-body-start:[get-bucket-acl]
    cos.getBucketAcl({
        Bucket: 'bucket-cssg-test-js-1253653367', /* 必须 */
        Region: 'ap-guangzhou',     /* 存储桶所在地域，必须字段 */
    }, function(err, data) {
        assert.notOk(err)
        resolve(data)
        console.log(err || data);
    });
    //.cssg-snippet-body-end
  })
}

function putBucketPolicy(assert) {
  return new Promise((resolve, reject) => {
    //.cssg-snippet-body-start:[put-bucket-policy]
    cos.putBucketPolicy({
        Bucket: 'bucket-cssg-test-js-1253653367', /* 必须 */
        Region: 'ap-guangzhou',     /* 存储桶所在地域，必须字段 */
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
                "Resource": ["qcs::cos:ap-guangzhou:uid/1253653367:bucket-cssg-test-js-1253653367/*"],
            }]
        },
    }, function(err, data) {
        assert.notOk(err)
        resolve(data)
        console.log(err || data);
    });
    //.cssg-snippet-body-end
  })
}

function getBucketPolicy(assert) {
  return new Promise((resolve, reject) => {
    //.cssg-snippet-body-start:[get-bucket-policy]
    cos.getBucketPolicy({
        Bucket: 'bucket-cssg-test-js-1253653367', /* 必须 */
        Region: 'ap-guangzhou',     /* 存储桶所在地域，必须字段 */
    }, function(err, data) {
        assert.notOk(err)
        resolve(data)
        console.log(err || data);
    });
    //.cssg-snippet-body-end
  })
}

function deleteBucketPolicy(assert) {
  return new Promise((resolve, reject) => {
    //.cssg-snippet-body-start:[delete-bucket-policy]
    cos.deleteBucketPolicy({
        Bucket: 'bucket-cssg-test-js-1253653367', /* 必须 */
        Region: 'ap-guangzhou',     /* 存储桶所在地域，必须字段 */
    }, function(err, data) {
        assert.notOk(err)
        resolve(data)
        console.log(err || data);
    });
    //.cssg-snippet-body-end
  })
}

function putBucketCors(assert) {
  return new Promise((resolve, reject) => {
    //.cssg-snippet-body-start:[put-bucket-cors]
    cos.putBucketCors({
        Bucket: 'bucket-cssg-test-js-1253653367', /* 必须 */
        Region: 'ap-guangzhou',     /* 存储桶所在地域，必须字段 */
        CORSRules: [{
            "AllowedOrigin": ["*"],
            "AllowedMethod": ["GET", "POST", "PUT", "DELETE", "HEAD"],
            "AllowedHeader": ["*"],
            "ExposeHeader": ["ETag", "x-cos-acl", "x-cos-version-id", "x-cos-delete-marker", "x-cos-server-side-encryption"],
            "MaxAgeSeconds": "5"
        }]
    }, function(err, data) {
        assert.notOk(err)
        resolve(data)
        console.log(err || data);
    });
    //.cssg-snippet-body-end
  })
}

function getBucketCors(assert) {
  return new Promise((resolve, reject) => {
    //.cssg-snippet-body-start:[get-bucket-cors]
    cos.getBucketCors({
        Bucket: 'bucket-cssg-test-js-1253653367', /* 必须 */
        Region: 'ap-guangzhou',     /* 存储桶所在地域，必须字段 */
    }, function(err, data) {
        assert.notOk(err)
        resolve(data)
        console.log(err || data);
    });
    //.cssg-snippet-body-end
  })
}

function optionObject(assert) {
  return new Promise((resolve, reject) => {
    //.cssg-snippet-body-start:[option-object]
    cos.optionsObject({
        Bucket: 'bucket-cssg-test-js-1253653367', /* 必须 */
        Region: 'ap-guangzhou',     /* 存储桶所在地域，必须字段 */
        Key: 'object4js',              /* 必须 */
        Origin: 'https://www.qq.com',      /* 必须 */
        AccessControlRequestMethod: 'PUT', /* 必须 */
        AccessControlRequestHeaders: 'origin,accept,content-type' /* 非必须 */
    }, function(err, data) {
        assert.notOk(err)
        resolve(data)
        console.log(err || data);
    });
    //.cssg-snippet-body-end
  })
}

function deleteBucketCors(assert) {
  return new Promise((resolve, reject) => {
    //.cssg-snippet-body-start:[delete-bucket-cors]
    cos.deleteBucketCors({
        Bucket: 'bucket-cssg-test-js-1253653367', /* 必须 */
        Region: 'ap-guangzhou',     /* 存储桶所在地域，必须字段 */
    }, function(err, data) {
        assert.notOk(err)
        resolve(data)
        console.log(err || data);
    });
    //.cssg-snippet-body-end
  })
}

function putBucketLifecycle(assert) {
  return new Promise((resolve, reject) => {
    //.cssg-snippet-body-start:[put-bucket-lifecycle]
    cos.putBucketLifecycle({
        Bucket: 'bucket-cssg-test-js-1253653367', /* 必须 */
        Region: 'ap-guangzhou',     /* 存储桶所在地域，必须字段 */
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
        assert.notOk(err)
        resolve(data)
        console.log(err || data);
    });
    //.cssg-snippet-body-end
  })
}

function putBucketLifecycleArchive(assert) {
  return new Promise((resolve, reject) => {
    //.cssg-snippet-body-start:[put-bucket-lifecycle-archive]
    cos.putBucketLifecycle({
        Bucket: 'bucket-cssg-test-js-1253653367', /* 必须 */
        Region: 'ap-guangzhou',     /* 存储桶所在地域，必须字段 */
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
        assert.notOk(err)
        resolve(data)
        console.log(err || data);
    });
    //.cssg-snippet-body-end
  })
}

function putBucketLifecycleExpired(assert) {
  return new Promise((resolve, reject) => {
    //.cssg-snippet-body-start:[put-bucket-lifecycle-expired]
    cos.putBucketLifecycle({
        Bucket: 'bucket-cssg-test-js-1253653367', /* 必须 */
        Region: 'ap-guangzhou',     /* 存储桶所在地域，必须字段 */
        Rules: [{
            "ID": "3",
            "Status": "Enabled",
            "Filter": {},
            "Expiration": {
                "Days": "180"
            }
        }],
    }, function(err, data) {
        assert.notOk(err)
        resolve(data)
        console.log(err || data);
    });
    //.cssg-snippet-body-end
  })
}

function putBucketLifecycleCleanAbort(assert) {
  return new Promise((resolve, reject) => {
    //.cssg-snippet-body-start:[put-bucket-lifecycle-cleanAbort]
    cos.putBucketLifecycle({
        Bucket: 'bucket-cssg-test-js-1253653367', /* 必须 */
        Region: 'ap-guangzhou',     /* 存储桶所在地域，必须字段 */
        Rules: [{
            "ID": "4",
            "Status": "Enabled",
            "Filter": {},
            "AbortIncompleteMultipartUpload": {
                "DaysAfterInitiation": "30"
            }
        }],
    }, function(err, data) {
        assert.notOk(err)
        resolve(data)
        console.log(err || data);
    });
    //.cssg-snippet-body-end
  })
}

function putBucketLifecycleHistoryArchive(assert) {
  return new Promise((resolve, reject) => {
    //.cssg-snippet-body-start:[put-bucket-lifecycle-historyArchive]
    cos.putBucketLifecycle({
        Bucket: 'bucket-cssg-test-js-1253653367', /* 必须 */
        Region: 'ap-guangzhou',     /* 存储桶所在地域，必须字段 */
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
        assert.notOk(err)
        resolve(data)
        console.log(err || data);
    });
    //.cssg-snippet-body-end
  })
}

function getBucketLifecycle(assert) {
  return new Promise((resolve, reject) => {
    //.cssg-snippet-body-start:[get-bucket-lifecycle]
    cos.getBucketLifecycle({
        Bucket: 'bucket-cssg-test-js-1253653367', /* 必须 */
        Region: 'ap-guangzhou',     /* 存储桶所在地域，必须字段 */
    }, function(err, data) {
        assert.notOk(err)
        resolve(data)
        console.log(err || data);
    });
    //.cssg-snippet-body-end
  })
}

function deleteBucketLifecycle(assert) {
  return new Promise((resolve, reject) => {
    //.cssg-snippet-body-start:[delete-bucket-lifecycle]
    cos.deleteBucketLifecycle({
        Bucket: 'bucket-cssg-test-js-1253653367', /* 必须 */
        Region: 'ap-guangzhou',     /* 存储桶所在地域，必须字段 */
    }, function(err, data) {
        assert.notOk(err)
        resolve(data)
        console.log(err || data);
    });
    //.cssg-snippet-body-end
  })
}

function putBucketVersioning(assert) {
  return new Promise((resolve, reject) => {
    //.cssg-snippet-body-start:[put-bucket-versioning]
    cos.putBucketVersioning({
        Bucket: 'bucket-cssg-test-js-1253653367',  /* 必须 */
        Region: 'ap-guangzhou',     /* 存储桶所在地域，必须字段 */
        VersioningConfiguration: {
            Status: "Enabled"
        }
    }, function (err, data) {
        assert.notOk(err)
        resolve(data)
        console.log(err || data);
    });
    //.cssg-snippet-body-end
  })
}

function getBucketVersioning(assert) {
  return new Promise((resolve, reject) => {
    //.cssg-snippet-body-start:[get-bucket-versioning]
    cos.getBucketVersioning({
        Bucket: 'bucket-cssg-test-js-1253653367',  /* 必须 */
        Region: 'ap-guangzhou',     /* 存储桶所在地域，必须字段 */
    }, function (err, data) {
        assert.notOk(err)
        resolve(data)
        console.log(err || data);
    });
    //.cssg-snippet-body-end
  })
}

function putBucketReplication(assert) {
  return new Promise((resolve, reject) => {
    //.cssg-snippet-body-start:[put-bucket-replication]
    cos.putBucketReplication({
        Bucket: 'bucket-cssg-test-js-1253653367',  /* 必须 */
        Region: 'ap-guangzhou',     /* 存储桶所在地域，必须字段 */
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
        assert.notOk(err)
        resolve(data)
        console.log(err || data);
    });
    //.cssg-snippet-body-end
  })
}

function getBucketReplication(assert) {
  return new Promise((resolve, reject) => {
    //.cssg-snippet-body-start:[get-bucket-replication]
    cos.getBucketReplication({
        Bucket: 'bucket-cssg-test-js-1253653367', /* 必须 */
        Region: 'ap-guangzhou',     /* 存储桶所在地域，必须字段 */
    }, function(err, data) {
        assert.notOk(err)
        resolve(data)
        console.log(err || data);
    });
    //.cssg-snippet-body-end
  })
}

function deleteBucketReplication(assert) {
  return new Promise((resolve, reject) => {
    //.cssg-snippet-body-start:[delete-bucket-replication]
    cos.deleteBucketReplication({
        Bucket: 'bucket-cssg-test-js-1253653367', /* 必须 */
        Region: 'ap-guangzhou',     /* 存储桶所在地域，必须字段 */
    }, function(err, data) {
        assert.notOk(err)
        resolve(data)
        console.log(err || data);
    });
    //.cssg-snippet-body-end
  })
}

function putBucketTagging(assert) {
  return new Promise((resolve, reject) => {
    //.cssg-snippet-body-start:[put-bucket-tagging]
    cos.putBucketTagging({
        Bucket: 'bucket-cssg-test-js-1253653367', /* 必须 */
        Region: 'ap-guangzhou',     /* 存储桶所在地域，必须字段 */
        Tagging: {
            "Tags": [
                {"Key": "k1", "Value": "v1"},
                {"Key": "k2", "Value": "v2"}
            ]
        }
    }, function(err, data) {
        assert.notOk(err)
        resolve(data)
        console.log(err || data);
    });
    //.cssg-snippet-body-end
  })
}

function getBucketTagging(assert) {
  return new Promise((resolve, reject) => {
    //.cssg-snippet-body-start:[get-bucket-tagging]
    cos.getBucketTagging({
        Bucket: 'bucket-cssg-test-js-1253653367', /* 必须 */
        Region: 'ap-guangzhou',     /* 存储桶所在地域，必须字段 */
    }, function(err, data) {
        assert.notOk(err)
        resolve(data)
        console.log(err || data);
    });
    //.cssg-snippet-body-end
  })
}

function deleteBucketTagging(assert) {
  return new Promise((resolve, reject) => {
    //.cssg-snippet-body-start:[delete-bucket-tagging]
    cos.deleteBucketTagging({
        Bucket: 'bucket-cssg-test-js-1253653367', /* 必须 */
        Region: 'ap-guangzhou',     /* 存储桶所在地域，必须字段 */
    }, function(err, data) {
        assert.notOk(err)
        resolve(data)
        console.log(err || data);
    });
    //.cssg-snippet-body-end
  })
}



test("testBucketACL", async function(assert) {
  await getBucket(assert)
  sleepfor(100)
  await getBucketPrefix(assert)
  sleepfor(100)
  await headBucket(assert)
  sleepfor(100)
  await putBucketAcl(assert)
  sleepfor(100)
  await putBucketAclUser(assert)
  sleepfor(100)
  await putBucketAclAcp(assert)
  sleepfor(100)
  await getBucketAcl(assert)
  sleepfor(100)
})
test("testBucketPolicy", async function(assert) {
  await putBucketPolicy(assert)
  sleepfor(100)
  await getBucketPolicy(assert)
  sleepfor(100)
  await deleteBucketPolicy(assert)
  sleepfor(100)
})
test("testBucketCORS", async function(assert) {
  await getBucketCors(assert)
  sleepfor(100)
})
test("testBucketLifecycle", async function(assert) {
  await putBucketLifecycle(assert)
  sleepfor(100)
  await putBucketLifecycleArchive(assert)
  sleepfor(100)
  await putBucketLifecycleExpired(assert)
  sleepfor(100)
  await putBucketLifecycleCleanAbort(assert)
  sleepfor(100)
  await putBucketLifecycleHistoryArchive(assert)
  sleepfor(100)
  await getBucketLifecycle(assert)
  sleepfor(100)
  await deleteBucketLifecycle(assert)
  sleepfor(100)
})
test("testBucketReplicationAndVersioning", async function(assert) {
  await putBucketVersioning(assert)
  sleepfor(100)
  await getBucketVersioning(assert)
  sleepfor(100)
  await putBucketReplication(assert)
  sleepfor(100)
  await getBucketReplication(assert)
  sleepfor(100)
  await deleteBucketReplication(assert)
  sleepfor(100)
})
test("testBucketTagging", async function(assert) {
  await putBucketTagging(assert)
  sleepfor(100)
  await getBucketTagging(assert)
  sleepfor(100)
  await deleteBucketTagging(assert)
  sleepfor(100)
})

test("CleanBucket", async function(assert) {
  await suspendBucketVersioning(assert)
})
