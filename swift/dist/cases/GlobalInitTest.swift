


import XCTest
import QCloudCOSXML

class globalInitTest : NSObject,QCloudSignatureProvider {
    var credentialFenceQueue:QCloudCredentailFenceQueue?;

      //.cssg-snippet-body-start:[global-init]
      //AppDelegate.m
      //第一步：注册默认的 COS 服务
      
      func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
          let config = QCloudServiceConfiguration.init();
          config.signatureProvider = self;
          config.appID = "appId";
          let endpoint = QCloudCOSXMLEndPoint.init();
          endpoint.regionName = "region";
          endpoint.useHTTPS = true;
          config.endpoint = endpoint;
          QCloudCOSXMLService.registerDefaultCOSXML(with: config);
          QCloudCOSTransferMangerService.registerDefaultCOSTransferManger(with: config);
          return true;
      }
      
      
      //第二步：实现 QCloudSignatureProvider 协议
      //实现签名的过程，我们推荐在服务器端实现签名的过程，详情请参考接下来的 “生成签名” 这一章。
      //.cssg-snippet-body-end

    func signature(with fileds: QCloudSignatureFields!, 
    request: QCloudBizHTTPRequest!, 
    urlRequest urlRequst: NSMutableURLRequest!, 
    compelete continueBlock: QCloudHTTPAuthentationContinueBlock!) {    
    }
}
