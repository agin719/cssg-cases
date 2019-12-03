


import XCTest
import QCloudCOSXML


class BucketACLTest: XCTestCase,QCloudSignatureProvider{


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


    func PutBucket() {
      let exception = XCTestExpectation.init(description: "putBucket exception");
      let putBucketReq = QCloudPutBucketRequest.init();
      putBucketReq.bucket = "bucket-cssg-swift-temp-1253653367";
      putBucketReq.finishBlock = {(result,error) in
          XCTAssertNil(error);
          XCTAssertNotNil(result);
          if error != nil {
              print(error!);
          } else {
              print(result!);
          }
          exception .fulfill();
      }
      QCloudCOSXMLService.defaultCOSXML().putBucket(putBucketReq);
      self.wait(for: [exception], timeout: 100);
    }


    func HeadBucket() {
      let exception = XCTestExpectation.init(description: "headBucket exception");
      let headBucketReq = QCloudHeadBucketRequest.init();
      headBucketReq.bucket = "bucket-cssg-swift-temp-1253653367";
      headBucketReq.finishBlock = {(result,error) in
          XCTAssertNil(error);
          XCTAssertNotNil(result);
          if error != nil{
              print(error!);
          }else{
              print( result!);
          }
          exception .fulfill();
      }
      QCloudCOSXMLService.defaultCOSXML().headBucket(headBucketReq);
      self.wait(for: [exception], timeout: 100);
    }


    func PutBucketAcl() {
      let exception = XCTestExpectation.init(description: "putBucketACL exception");
      let putBucketACLReq = QCloudPutBucketACLRequest.init();
      putBucketACLReq.bucket = "bucket-cssg-swift-temp-1253653367";
      let appTD = "1131975903";//授予全新的账号ID
      let ownerIdentifier = "qcs::cam::uin/\(appTD):uin/\(appTD)";
      let grantString = "id=\"\(ownerIdentifier)\"";
      putBucketACLReq.grantWrite = grantString;
      putBucketACLReq.finishBlock = {(result,error) in
          XCTAssertNil(error);
          XCTAssertNotNil(result);
          if error != nil{
              print(error!);
          }else{
              print(result!);
          }
          exception .fulfill();
      }
      QCloudCOSXMLService.defaultCOSXML().putBucketACL(putBucketACLReq);
      self.wait(for: [exception], timeout: 100);
    }


    func GetBucketAcl() {
      let exception = XCTestExpectation.init(description: "getBucketACL exception");
      let getBucketACLReq = QCloudGetBucketACLRequest.init();
      getBucketACLReq.bucket = "bucket-cssg-swift-temp-1253653367";
      getBucketACLReq.setFinish { (result, error) in
          XCTAssertNil(error);
          XCTAssertNotNil(result);
          if error != nil{
              print(error!);
          }else{
              print(result!);
          }
          exception .fulfill();
      }
      QCloudCOSXMLService.defaultCOSXML().getBucketACL(getBucketACLReq)
      self.wait(for: [exception], timeout: 100);
    }


    func DeleteBucket() {
      let exception = XCTestExpectation.init(description: "deleteBucket exception");
      let deleteBucketReq = QCloudDeleteBucketRequest.init();
      deleteBucketReq.bucket = "bucket-cssg-swift-temp-1253653367";
      deleteBucketReq.finishBlock = {(result,error) in
          XCTAssertNil(error);
          XCTAssertNotNil(result);
          if error != nil{
              print(error!);
          }else{
              print(result!);
          }
          exception .fulfill();
      }
      QCloudCOSXMLService.defaultCOSXML().deleteBucket(deleteBucketReq);
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

          self.PutBucket();
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        self.DeleteBucket();
    }

    func testBucketACL() {
      self.HeadBucket();
      self.PutBucketAcl();
      self.GetBucketAcl();
    }
}
