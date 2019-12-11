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

function getService() {
  return new Promise((resolve, reject) => {
    cos.getService(function (err, data) {        assert.ifError(err)        resolve(data)        console.log(data && data.Buckets);    });    
  })
}

function getRegionalService() {
  return new Promise((resolve, reject) => {
    cos.getService({        Region: 'ap-guangzhou',    }, function(err, data) {        assert.ifError(err)        resolve(data)        console.log(err || data);    });    
  })
}

function getAuthorization() {
    var COS = require('cos-nodejs-sdk-v5');    var Authorization = COS.getAuthorization({        SecretId: process.env["COS_KEY"],        SecretKey: process.env["COS_SECRET"],        Method: 'get',        Key: 'a.jpg',        Expires: 60,        Query: {},        Headers: {}    });    
    assert.ok(Authorization)
}



describe("testGetService", function() {
  it("getService", function() {
    return getService()
  })
  it("getRegionalService", function() {
    return getRegionalService()
  })
  it("getAuthorization", function() {
    return getAuthorization()
  })
})

