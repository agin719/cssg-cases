


import XCTest
import QCloudCOSXML

class BucketReplicationAndVersioningTest: XCTestCase,QCloudSignatureProvider{


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


    func PutBucketVersioning() {
      let exception = XCTestExpectation.init(description: "PutBucketVersioning");
      let putBucketVersioning = QCloudPutBucketVersioningRequest.init();
      putBucketVersioning.bucket = "bucket-cssg-test-swift-1253653367";
      
      let config = QCloudBucketVersioningConfiguration.init();
      config.status = .enabled;
      
      putBucketVersioning.configuration = config;
      
      putBucketVersioning.finishBlock = {(result,error) in
          XCTAssertNil(error);
          exception.fulfill();
          if error != nil{
              print(error!);
          }else{
              print(result!);
          }}
      QCloudCOSXMLService.defaultCOSXML().putBucketVersioning(putBucketVersioning);
      
      self.wait(for: [exception], timeout: 100);
    }


    func GetBucketVersioning() {
      let exception = XCTestExpectation.init(description: "GetBucketVersioning");
      let getBucketVersioning = QCloudGetBucketVersioningRequest.init();
      getBucketVersioning.bucket = "bucket-cssg-test-swift-1253653367";
      getBucketVersioning.setFinish { (config, error) in
          XCTAssertNil(error);
          exception.fulfill();
          if error != nil{
              print(error!);
          }else{
              print(config!);
          }}
      QCloudCOSXMLService.defaultCOSXML().getBucketVersioning(getBucketVersioning);
      
      self.wait(for: [exception], timeout: 100);
    }


    func PutBucketReplication() {
      let exception = XCTestExpectation.init(description: "PutBucketReplication");
      let putBucketReplication = QCloudPutBucketReplicationRequest.init();
      putBucketReplication.bucket = "bucket-cssg-test-swift-1253653367";
      
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
          exception.fulfill();
              if error != nil{
                  print(error!);
              }else{
                  print(result!);
              }}
      QCloudCOSXMLService.defaultCOSXML().putBucketRelication(putBucketReplication);
      
      self.wait(for: [exception], timeout: 100);
    }


    func GetBucketReplication() {
      let exception = XCTestExpectation.init(description: "GetBucketReplication");
      let getBucketReplication = QCloudGetBucketReplicationRequest.init();
      getBucketReplication.bucket = "bucket-cssg-test-swift-1253653367";
      getBucketReplication.setFinish { (config, error) in
          XCTAssertNil(error);
          exception.fulfill();
          if error != nil{
              print(error!);
          }else{
              print(config!);
          }}
      QCloudCOSXMLService.defaultCOSXML().getBucketReplication(getBucketReplication);
      
      self.wait(for: [exception], timeout: 100);
    }


    func DeleteBucketReplication() {
      let exception = XCTestExpectation.init(description: "DeleteBucketReplication");
      let deleteBucketReplication = QCloudDeleteBucketReplicationRequest.init();
      deleteBucketReplication.bucket = "bucket-cssg-test-swift-1253653367";
      deleteBucketReplication.finishBlock = {(result,error) in
          XCTAssertNil(error);
          exception.fulfill();
          if error != nil{
              print(error!);
          }else{
              print(result!);
          }}
      QCloudCOSXMLService.defaultCOSXML().deleteBucketReplication(deleteBucketReplication);
      
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

    func testBucketReplicationAndVersioning() {
      self.PutBucketVersioning();
      self.GetBucketVersioning();
      self.PutBucketReplication();
      self.GetBucketReplication();
      self.DeleteBucketReplication();
    }
}
