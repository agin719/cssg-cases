


import XCTest
import QCloudCOSXML

class globalInitFenceQueueTest : NSObject,QCloudSignatureProvider {
    var credentialFenceQueue:QCloudCredentailFenceQueue?;

      //.cssg-snippet-body-start:[global-init-fence-queue]
      //AppDelegate.m
      
      // 这里定义一个成员变量 @property (nonatomic) QCloudCredentailFenceQueue* credentialFenceQueue;
      
      func fenceQueue(_ queue: QCloudCredentailFenceQueue!, requestCreatorWithContinue continueBlock: QCloudCredentailFenceQueueContinue!) {
          let cre = QCloudCredential.init();
          //在这里可以同步过程从服务器获取临时签名需要的 secretID，secretKey，expiretionDate 和 token 参数
          cre.secretID = SecretStorage.shared.secretID as String?;
          cre.secretKey = SecretStorage.shared.secretKey as String?;
          cre.token = "COS_TOKEN";
          /*强烈建议返回服务器时间作为签名的开始时间，用来避免由于用户手机本地时间偏差过大导致的签名不正确 */
          cre.startDate = DateFormatter().date(from: "startTime"); // 单位是秒
          cre.experationDate = DateFormatter().date(from: "expiredTime");
          let auth = QCloudAuthentationV5Creator.init(credential: cre);
          continueBlock(auth,nil);
      }
      
      func signature(with fileds: QCloudSignatureFields!, request: QCloudBizHTTPRequest!, urlRequest urlRequst: NSMutableURLRequest!, compelete continueBlock: QCloudHTTPAuthentationContinueBlock!) {
          self.credentialFenceQueue?.performAction({ (creator, error) in
              if error != nil {
                  continueBlock(nil,error!);
              }else{
                  let signature = creator?.signature(forData: urlRequst);
                  continueBlock(signature,nil);
              }
          })
      }
      //.cssg-snippet-body-end

}
class globalInitSignatureTest : NSObject,QCloudSignatureProvider {
    var credentialFenceQueue:QCloudCredentailFenceQueue?;

      //.cssg-snippet-body-start:[global-init-signature]
      
      func signature(with fileds: QCloudSignatureFields!, request: QCloudBizHTTPRequest!, urlRequest urlRequst: NSMutableURLRequest!, compelete continueBlock: QCloudHTTPAuthentationContinueBlock!) {
          let cre = QCloudCredential.init();
          cre.secretID = SecretStorage.shared.secretID as String?;
          cre.secretKey = SecretStorage.shared.secretKey as String?;
          let auth = QCloudAuthentationV5Creator.init(credential: cre);
          let signature = auth?.signature(forData: urlRequst)
          continueBlock(signature,nil);
      }
      //.cssg-snippet-body-end

}
class globalInitSignatureStsTest : NSObject,QCloudSignatureProvider {
    var credentialFenceQueue:QCloudCredentailFenceQueue?;

      //.cssg-snippet-body-start:[global-init-signature-sts]
      
      func signature(with fileds: QCloudSignatureFields!, request: QCloudBizHTTPRequest!, urlRequest urlRequst: NSMutableURLRequest!, compelete continueBlock: QCloudHTTPAuthentationContinueBlock!) {
          let cre = QCloudCredential.init();
          cre.secretID = SecretStorage.shared.secretID as String?;
          cre.secretKey = SecretStorage.shared.secretKey as String?;
          cre.token = "COS_TOKEN";
          /*强烈建议返回服务器时间作为签名的开始时间，用来避免由于用户手机本地时间偏差过大导致的签名不正确 */
          cre.startDate = DateFormatter().date(from: "startTime"); // 单位是秒
          cre.experationDate = DateFormatter().date(from: "expiredTime");
          let auth = QCloudAuthentationV5Creator.init(credential: cre);
          let signature = auth?.signature(forData: urlRequst)
          continueBlock(signature,nil);
      }
      //.cssg-snippet-body-end

}
