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
        resolve(data)
        console.log(err || data);
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
        console.log(err || data);
        cos.deleteObject({
          Bucket: 'bucket-cssg-test-nodejs-1253653367', /* 必须 */
          Region: 'ap-guangzhou',    /* 必须 */
          Key: 'a/'       /* 必须 */
      }, function(err, data) {
          console.log(err || data);
          if (!err) {
            cos.deleteBucket({
              Bucket: 'bucket-cssg-test-nodejs-1253653367', /* 必须 */
              Region: 'ap-guangzhou'     /* 必须 */
            }, function(err, data) {
                resolve(data)
                console.log(err || data);
            });
          }
      });
    });
    
  })
}

module.exports = {
  setup,
  cleanUp
}