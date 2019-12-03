


import XCTest
import QCloudCOSXML


class TransferCopyObjectTest: XCTestCase,QCloudSignatureProvider{


    var uploadId:String?;
    var parts:[QCloudMultipartInfo]?;
    var credentialFenceQueue:QCloudCredentailFenceQueue?;
    func signature(with fileds: QCloudSignatureFields!, request: QCloudBizHTTPRequest!, urlRequest urlRequst: NSMutableURLRequest!, compelete continueBlock: QCloudHTTPAuthentationContinueBlock!) {
    let cre = QCloudCredential.init();
    cre.secretID = SecretStorage.shared.secretID  as String?;
    cre.secretKey = SecretStorage.shared.secretKey  as String?;
    let auth = QCloudAuthentationV5Creator.init(credential: cre);
    let signature = auth?.signature(forData: urlRequst)
    continueBlock(signature,nil);
    }


    func TransferCopyObject() {
      let copyRequest =  QCloudCOSXMLCopyObjectRequest.init();
      copyRequest.bucket = "bucket-cssg-test-1253653367";//目的<BucketName-APPID>，需要是公有读或者在当前账号有权限
      copyRequest.object = "object4swift";//目的文件名称
      //文件来源<BucketName-APPID>，需要是公有读或者在当前账号有权限
      copyRequest.sourceBucket = "bucket-cssg-test-1253653367";
      copyRequest.sourceObject = "sourceObject";//源文件名称
      copyRequest.sourceAPPID = "1253653367";//源文件的appid
      copyRequest.sourceRegion = "ap-guangzhou";//来源的地域
      copyRequest.setFinish { (copyResult, error) in
          if error != nil{
              print(error!);
          }else{
              print(copyResult!);
          }
      }
      //注意如果是跨地域复制，这里使用的 transferManager 所在的 region 必须为目标桶所在的 region
      QCloudCOSTransferMangerService.defaultCOSTransferManager().copyObject(copyRequest);
    }


    override func setUp() {
      let config = QCloudServiceConfiguration.init();
      config.signatureProvider = self;
      config.appID = "1253653367";
      let endpoint = QCloudCOSXMLEndPoint.init();
      endpoint.regionName = "ap-guangzhou";
      endpoint.useHTTPS = true;
      config.endpoint = endpoint;
      QCloudCOSXMLService.registerDefaultCOSXML(with: config);
      QCloudCOSTransferMangerService.registerDefaultCOSTransferManger(with: config);

    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testTransferCopyObject() {
      self.TransferCopyObject();
    }
}
