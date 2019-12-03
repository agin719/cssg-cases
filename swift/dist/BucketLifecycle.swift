


import XCTest
import QCloudCOSXML


class BucketLifecycleTest: XCTestCase,QCloudSignatureProvider{


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


    func PutBucketLifecycle() {
      let exception = XCTestExpectation.init(description: "putBucketLifecycle exception");
      let putBucketLifecycleReq = QCloudPutBucketLifecycleRequest.init();
      putBucketLifecycleReq.bucket = "bucket-cssg-swift-temp-1253653367";
      
      let config = QCloudLifecycleConfiguration.init();
      
      let rule = QCloudLifecycleRule.init();
      rule.identifier = "swift";
      rule.status = .enabled;
      
      let fileter = QCloudLifecycleRuleFilter.init();
      fileter.prefix = "0";
      
      rule.filter = fileter;
      
      let transition = QCloudLifecycleTransition.init();
      transition.days = 100;
      transition.storageClass = .standardIA;
      
      rule.transition = transition;
      
      putBucketLifecycleReq.lifeCycle = config;
      putBucketLifecycleReq.lifeCycle.rules = [rule];
      
      putBucketLifecycleReq.finishBlock = {(result,error) in
          XCTAssertNil(error);
          XCTAssertNotNil(result);
          if error != nil{
              print(error!);
          }else{
              print(result!);
          }
          exception .fulfill();
      }
      QCloudCOSXMLService.defaultCOSXML().putBucketLifecycle(putBucketLifecycleReq);
      self.wait(for: [exception], timeout: 100);
    }


    func GetBucketLifecycle() {
      let exception = XCTestExpectation.init(description: "getBucketLifeCycle exception");
      let getBucketLifeCycle = QCloudGetBucketLifecycleRequest.init();
      getBucketLifeCycle.bucket = "bucket-cssg-swift-temp-1253653367";
      getBucketLifeCycle.setFinish { (config, error) in
          XCTAssertNil(error);
          XCTAssertNotNil(config);
          if error != nil{
              print(error!);
          }else{
              print(config!);
          }
          exception .fulfill();
      };
      QCloudCOSXMLService.defaultCOSXML().getBucketLifecycle(getBucketLifeCycle);
      self.wait(for: [exception], timeout: 100);
    }


    func DeleteBucketLifecycle() {
      let exception = XCTestExpectation.init(description: "deleteBucketLifeCycle exception");
      let deleteBucketLifeCycle = QCloudDeleteBucketLifeCycleRequest.init();
      deleteBucketLifeCycle.bucket = "bucket-cssg-swift-temp-1253653367";
      deleteBucketLifeCycle.finishBlock = { (result, error) in
          XCTAssertNil(error);
          XCTAssertNotNil(result);
          if error != nil{
              print(error!);
          }else{
              print(result!);
          }
          exception.fulfill();
      };
      QCloudCOSXMLService.defaultCOSXML().deleteBucketLifeCycle(deleteBucketLifeCycle);
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

    func testBucketLifecycle() {
      self.PutBucketLifecycle();
      self.GetBucketLifecycle();
      self.DeleteBucketLifecycle();
    }
}
