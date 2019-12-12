function globalInit(assert) {
  return new Promise((resolve, reject) => {
    var cos = new COS({
        SecretId: 'COS_SECRETID',
        SecretKey: 'COS_SECRETKEY',
    });
    
  })
}

function globalInitSts(assert) {
  return new Promise((resolve, reject) => {
    var COS = require('cos-js-sdk-v5');
    var cos = new COS({
        // 必选参数
        getAuthorization: function (options, callback) {
            // 服务端 JS 和 PHP 例子：https://github.com/tencentyun/cos-js-sdk-v5/blob/master/server/
            // 服务端其他语言参考 COS STS SDK ：https://github.com/tencentyun/qcloud-cos-sts-sdk
            // STS 详细文档指引看：https://cloud.tencent.com/document/product/436/14048
            $.get('http://example.com/server/sts.php', {
                // 可从 options 取需要的参数
            }, function (data) {
                callback({
                    TmpSecretId: data.TmpSecretId,
                    TmpSecretKey: data.TmpSecretKey,
                    XCosSecurityToken: data.XCosSecurityToken,
                    ExpiredTime: data.ExpiredTime, // SDK 在 ExpiredTime 时间前，不会再次调用 getAuthorization
                });
            });
        }
    });
    
  })
}

function globalInitSignature(assert) {
  return new Promise((resolve, reject) => {
    var cos = new COS({
        // 必选参数
        getAuthorization: function (options, callback) {
            // 服务端获取签名，请参考对应语言的 COS SDK：https://cloud.tencent.com/document/product/436/6474
            // 注意：这种有安全风险，后端需要通过 method、pathname 严格控制好权限，例如不允许 put / 等
            $.get('http://example.com/server/auth.php', {
                method: options.Method,
                pathname: '/' + options.Key,
            }, function (data) {
                callback({
                    Authorization: data.authorization,
                    // XCosSecurityToken: data.sessionToken, // 如果使用临时密钥，需要把 sessionToken 传给 XCosSecurityToken
                });
            });
        },
        // 可选参数
        FileParallelLimit: 3,    // 控制文件上传并发数
        ChunkParallelLimit: 3,   // 控制单个文件下分片上传并发数
        ProgressInterval: 1000,  // 控制上传的 onProgress 回调的间隔
    });
    
  })
}

function globalInitStsScope(assert) {
  return new Promise((resolve, reject) => {
    var COS = require('cos-js-sdk-v5');
    var cos = new COS({
        // 必选参数
        getAuthorization: function (options, callback) {
            // 服务端例子：https://github.com/tencentyun/qcloud-cos-sts-sdk/blob/master/scope.md
            $.ajax({
                method: 'POST',
                url: ' http://example.com/server/sts-scope.php',
                data: JSON.stringify(options.Scope),
                beforeSend: function () {
                    xhr.setRequestHeader('Content-Type', 'application/json');
                },
                dataType: 'json',
                success: function (data) {
                    var credentials = data.credentials;
                    callback({
                        TmpSecretId: credentials.tmpSecretId,
                        TmpSecretKey: credentials.tmpSecretKey,
                        XCosSecurityToken: credentials.sessionToken, // 需要提供把 sessionToken 传给
                        ExpiredTime: data.expiredTime,
                        ScopeLimit: true, // 细粒度控制权限需要设为 true，会限制密钥只在相同请求时重复使用
                    });
                }
            });
        }
    });
    
  })
}


