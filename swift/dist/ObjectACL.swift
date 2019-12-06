


import XCTest
import QCloudCOSXML


class ObjectACLTest: XCTestCase,QCloudSignatureProvider{


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


    func PutObject() {
      let exception = XCTestExpectation.init(description: "putObject exception");
      let putObject = QCloudPutObjectRequest<AnyObject>.init();
      putObject.bucket = "bucket-cssg-test-1253653367";
      let dataBody:NSData? = "wrwrwrwrwrw".data(using: .utf8) as NSData?;
      putObject.body =  dataBody!;
      putObject.object = "object4swift";
      putObject.finishBlock = {(result,error) in
          XCTAssertNil(error);
          XCTAssertNotNil(result);
          if error != nil{
              print(error!);
          }else{
              print(result!);
          }
          exception .fulfill();
      }
      QCloudCOSXMLService.defaultCOSXML().putObject(putObject);
      self.wait(for: [exception], timeout: 100);
    }


    func PutObjectAcl() {
      let exception = XCTestExpectation.init(description: "putObjectACl exception");
      let putObjectACl = QCloudPutObjectACLRequest.init();
      putObjectACl.bucket = "bucket-cssg-test-1253653367";
      putObjectACl.object = "object4swift";
      let grantString = "id=\"1253653367\"";
      putObjectACl.grantFullControl = grantString;
      putObjectACl.finishBlock = {(result,error)in
          XCTAssertNil(error);
          XCTAssertNotNil(result);
          if error != nil{
              print(error!)
          }else{
              //可以从 outputObject 中获取 response 中 etag 或者自定义头部等信息
              print(result!);
          }
          exception .fulfill();
      }
      QCloudCOSXMLService.defaultCOSXML().putObjectACL(putObjectACl);
      self.wait(for: [exception], timeout: 100);
    }


    func GetObjectAcl() {
      let exception = XCTestExpectation.init(description: "getObjectACL exception");
      let getObjectACL = QCloudGetObjectACLRequest.init();
      getObjectACL.bucket = "bucket-cssg-test-1253653367";
      getObjectACL.object = "object4swift";
      getObjectACL.setFinish { (result, error) in
          XCTAssertNil(error);
          XCTAssertNotNil(result);
          if error != nil{
              print(error!)
          }else{
              //可以从 result 的 accessControlList 中获取对象的 ACL
              print(result!.accessControlList);
          }
          exception .fulfill();
      }
      QCloudCOSXMLService.defaultCOSXML().getObjectACL(getObjectACL);
      self.wait(for: [exception], timeout: 100);
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

    func testObjectACL() {
      self.PutObject();
      self.PutObjectAcl();
      self.GetObjectAcl();
    }
}
