


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
      let exception = XCTestExpectation.init(description: "PutBucket");
      let putBucketReq = QCloudPutBucketRequest.init();
      putBucketReq.bucket = "bucket-cssg-test-swift-1253653367";
      putBucketReq.finishBlock = {(result,error) in
          exception.fulfill();
          if error != nil {
              print(error!);
          } else {
              print(result!);
          }}
      QCloudCOSXMLService.defaultCOSXML().putBucket(putBucketReq);
      
      self.wait(for: [exception], timeout: 100);
    }


    func GetBucket() {
      let exception = XCTestExpectation.init(description: "GetBucket");
      let getBucketReq = QCloudGetBucketRequest.init();
      getBucketReq.bucket = "bucket-cssg-test-swift-1253653367";
      getBucketReq.maxKeys = 1000;
      getBucketReq.setFinish { (result, error) in
          XCTAssertNil(error);
          exception.fulfill();
          if error != nil{
              print(error!);
          }else{
              print( result!.commonPrefixes);
          }}
      QCloudCOSXMLService.defaultCOSXML().getBucket(getBucketReq);
      
      self.wait(for: [exception], timeout: 100);
    }


    func HeadBucket() {
      let exception = XCTestExpectation.init(description: "HeadBucket");
      let headBucketReq = QCloudHeadBucketRequest.init();
      headBucketReq.bucket = "bucket-cssg-test-swift-1253653367";
      headBucketReq.finishBlock = {(result,error) in
          XCTAssertNil(error);
          exception.fulfill();
          if error != nil{
              print(error!);
          }else{
              print( result!);
          }}
      QCloudCOSXMLService.defaultCOSXML().headBucket(headBucketReq);
      
      self.wait(for: [exception], timeout: 100);
    }


    func PutBucketAcl() {
      let exception = XCTestExpectation.init(description: "PutBucketAcl");
      let putBucketACLReq = QCloudPutBucketACLRequest.init();
      putBucketACLReq.bucket = "bucket-cssg-test-swift-1253653367";
      let appTD = "1131975903";//授予全新的账号 ID
      let ownerIdentifier = "qcs::cam::uin/\(appTD):uin/\(appTD)";
      let grantString = "id=\"\(ownerIdentifier)\"";
      putBucketACLReq.grantWrite = grantString;
      putBucketACLReq.finishBlock = {(result,error) in
          XCTAssertNil(error);
          exception.fulfill();
          if error != nil{
              print(error!);
          }else{
              print(result!);
          }}
      QCloudCOSXMLService.defaultCOSXML().putBucketACL(putBucketACLReq);
      
      self.wait(for: [exception], timeout: 100);
    }


    func GetBucketAcl() {
      let exception = XCTestExpectation.init(description: "GetBucketAcl");
      let getBucketACLReq = QCloudGetBucketACLRequest.init();
      getBucketACLReq.bucket = "bucket-cssg-test-swift-1253653367";
      getBucketACLReq.setFinish { (result, error) in
          XCTAssertNil(error);
          exception.fulfill();
          if error != nil{
              print(error!);
          }else{
              print(result!);
          }}
      QCloudCOSXMLService.defaultCOSXML().getBucketACL(getBucketACLReq)
      
      self.wait(for: [exception], timeout: 100);
    }


    func DeleteBucket() {
      let exception = XCTestExpectation.init(description: "DeleteBucket");
      let deleteBucketReq = QCloudDeleteBucketRequest.init();
      deleteBucketReq.bucket = "bucket-cssg-test-swift-1253653367";
      deleteBucketReq.finishBlock = {(result,error) in
          exception.fulfill();
          if error != nil{
              print(error!);
          }else{
              print(result!);
          }}
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
      self.DeleteBucket();
    }

    func testBucketACL() {
      self.GetBucket();
      self.HeadBucket();
      self.PutBucketAcl();
      self.GetBucketAcl();
    }
}
