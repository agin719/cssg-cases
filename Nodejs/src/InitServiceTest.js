const assert = require('assert')
const fs = require('fs')
const path = require('path')

var createFileSync = function (filePath, size) {
  if (!fs.existsSync(filePath) || fs.statSync(filePath).size !== size) {
      fs.writeFileSync(filePath, Buffer.from(Array(size).fill(0)));
  }
  return filePath;
};


function globalInitSts() {
  return new Promise((resolve, reject) => {
    //.cssg-snippet-body-start:[global-init-sts]
    var request = require('request');
    var COS = require('cos-nodejs-sdk-v5');
    var cos = new COS({
        getAuthorization: function (options, callback) {
            // 异步获取临时密钥
            request({
                url: '../server/sts.php',
                data: {
                    // 可从 options 取需要的参数
                }
            }, function (err, response, body) {
                try {
                    var data = JSON.parse(body);
                    var credentials = data.credentials;
                } catch(e) {}
                callback({
                        TmpSecretId: credentials.tmpSecretId,        // 临时密钥的 tmpSecretId
                        TmpSecretKey: credentials.tmpSecretKey,      // 临时密钥的 tmpSecretKey
                        XCosSecurityToken: credentials.sessionToken, // 临时密钥的 sessionToken
                        ExpiredTime: data.expiredTime,               // 临时密钥失效时间戳，是申请临时密钥时，时间戳加 durationSeconds
                });
            });
        }
    });
    //.cssg-snippet-body-end
  })
}


