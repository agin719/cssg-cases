


import XCTest
import QCloudCOSXML


class BucketReplicationTest: XCTestCase,QCloudSignatureProvider{


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


    func PutBucketVersioning() {
      let exception = XCTestExpectation.init(description: "putBucketVersioning exception");
      let putBucketVersioning = QCloudPutBucketVersioningRequest.init();
      putBucketVersioning.bucket = "bucket-cssg-swift-temp-1253653367";
      
      let config = QCloudBucketVersioningConfiguration.init();
      config.status = .enabled;
      
      putBucketVersioning.configuration = config;
      
      putBucketVersioning.finishBlock = {(result,error) in
          XCTAssertNil(error);
          XCTAssertNotNil(result);
          if error != nil{
              print(error!);
          }else{
              print(result!);
          }
          exception.fulfill();
      }
      QCloudCOSXMLService.defaultCOSXML().putBucketVersioning(putBucketVersioning);
      self.wait(for: [exception], timeout: 100);
    }


    func PutBucketReplication() {
      let exception = XCTestExpectation.init(description: "putBucketReplication exception");
      let putBucketReplication = QCloudPutBucketReplicationRequest.init();
      putBucketReplication.bucket = "bucket-cssg-swift-temp-1253653367";
      
      let config = QCloudBucketReplicationConfiguation.init();
      config.role = "qcs::cam::uin/1278687956:uin/1278687956";
      
      let rule = QCloudBucketReplicationRule.init();
      rule.identifier = "swift";
      rule.status = .enabled;
      
      let destination = QCloudBucketReplicationDestination.init();
      let destinationBucket = "bucket-cssg-assist-1253653367";
      let region = "ap-beijing";
      destination.bucket = "qcs::cos:\(region)::\(destinationBucket)";
      rule.destination = destination;
      rule.prefix = "a";
      
      config.rule = [rule];
      
      putBucketReplication.configuation = config;
      
      putBucketReplication.finishBlock = {(result,error) in
          XCTAssertNil(error);
          XCTAssertNotNil(result);
              if error != nil{
                  print(error!);
              }else{
                  print(result!);
              }
              exception.fulfill();
      }
      QCloudCOSXMLService.defaultCOSXML().putBucketRelication(putBucketReplication);
      self.wait(for: [exception], timeout: 100);
    }


    func GetBucketReplication() {
      let exception = XCTestExpectation.init(description: "getBucketReplication exception");
      let getBucketReplication = QCloudGetBucketReplicationRequest.init();
      getBucketReplication.bucket = "bucket-cssg-swift-temp-1253653367";
      getBucketReplication.setFinish { (config, error) in
          XCTAssertNil(error);
          XCTAssertNotNil(config);
          if error != nil{
              print(error!);
          }else{
              print(config!);
          }
          exception .fulfill();
      }
      QCloudCOSXMLService.defaultCOSXML().getBucketReplication(getBucketReplication);
      self.wait(for: [exception], timeout: 100);
    }


    func DeleteBucketReplication() {
      let exception = XCTestExpectation.init(description: "deleteBucketReplication exception");
      let deleteBucketReplication = QCloudDeleteBucketReplicationRequest.init();
      deleteBucketReplication.bucket = "bucket-cssg-swift-temp-1253653367";
      deleteBucketReplication.finishBlock = {(result,error) in
          XCTAssertNil(error);
          XCTAssertNotNil(result);
          if error != nil{
              print(error!);
          }else{
              print(result!);
          }
          exception.fulfill();
      }
      QCloudCOSXMLService.defaultCOSXML().deleteBucketReplication(deleteBucketReplication);
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

    func testBucketReplication() {
      self.PutBucketVersioning();
      self.PutBucketReplication();
      self.GetBucketReplication();
      self.DeleteBucketReplication();
    }
}
