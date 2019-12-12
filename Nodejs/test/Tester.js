const assert = require('assert')

function initCOS () {
  var COS = require('cos-nodejs-sdk-v5');
  var cos = new COS({
      SecretId: process.env["COS_KEY"],
      SecretKey: process.env["COS_SECRET"]
  });
  
  return cos
}
var cos = initCOS()

function setup() {
  return new Promise((resolve, reject) => {
    cos.putBucket({
        Bucket: 'bucket-cssg-test-nodejs-1253653367',
        Region: 'ap-guangzhou'
    }, function(err, data) {
        assert.ifError(err)
        resolve(data)
    });
    
  })
}

function cleanUp() {
  return new Promise((resolve, reject) => {
    cos.deleteObject({
        Bucket: 'bucket-cssg-test-nodejs-1253653367', /* 必须 */
        Region: 'ap-guangzhou',    /* 必须 */
        Key: '2.jpg'       /* 必须 */
    }, function(err, data) {
        assert.ifError(err)
        cos.deleteObject({
          Bucket: 'bucket-cssg-test-nodejs-1253653367', /* 必须 */
          Region: 'ap-guangzhou',    /* 必须 */
          Key: 'a/'       /* 必须 */
      }, function(err, data) {
          assert.ifError(err)
          if (!err) {
            cos.deleteBucket({
              Bucket: 'bucket-cssg-test-nodejs-1253653367', /* 必须 */
              Region: 'ap-guangzhou'     /* 必须 */
            }, function(err, data) {
                assert.ifError(err)
                resolve(data)
            });
          }
      });
    });
    
  })
}

describe("setup", function() {
  it("createBucket", function() {
    return setup()
  })
})

require('../src/InitServiceTest')
require('../src/ServiceTest')
require('../src/BucketTest')
require('../src/ObjectTest')

describe("cleanUp", function() {
  it("cleanObjectAndBucket", function() {
    return cleanUp()
  })
})