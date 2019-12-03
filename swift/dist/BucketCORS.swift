


import XCTest
import QCloudCOSXML


class BucketCORSTest: XCTestCase,QCloudSignatureProvider{


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


    func PutBucketCors() {
      let exception = XCTestExpectation.init(description: "putBucketCors exception");
      let putBucketCorsReq = QCloudPutBucketCORSRequest.init();
      
      let corsConfig = QCloudCORSConfiguration.init();
      
      let rule = QCloudCORSRule.init();
      rule.identifier = "swift-sdk";
      rule.allowedHeader = ["origin","host","accept","content-type","authorization"];
      rule.exposeHeader = "Etag";
      rule.allowedMethod = ["GET","PUT","POST", "DELETE", "HEAD"];
      rule.maxAgeSeconds = 3600;
      rule.allowedOrigin = "*";
      
      corsConfig.rules = [rule];
      
      putBucketCorsReq.corsConfiguration = corsConfig;
      putBucketCorsReq.bucket = "bucket-cssg-swift-temp-1253653367";
      putBucketCorsReq.finishBlock = {(result,error) in
          XCTAssertNil(error);
          XCTAssertNotNil(result);
          if error != nil{
              print(error!);
          }else{
              print(result!);
          }
          exception .fulfill();
      }
      
      QCloudCOSXMLService.defaultCOSXML().putBucketCORS(putBucketCorsReq);
      self.wait(for: [exception], timeout: 100);
    }


    func GetBucketCors() {
      let exception = XCTestExpectation.init(description: "getBucketCors exception");
      let  getBucketCorsRes = QCloudGetBucketCORSRequest.init();
      getBucketCorsRes.bucket = "bucket-cssg-swift-temp-1253653367";
      getBucketCorsRes.setFinish { (corsConfig, error) in
          XCTAssertNil(error);
          XCTAssertNotNil(corsConfig);
          if error != nil{
              print(error!);
          }else{
              print(corsConfig!);
          }
          exception .fulfill();
      }
      QCloudCOSXMLService.defaultCOSXML().getBucketCORS(getBucketCorsRes);
      self.wait(for: [exception], timeout: 100);
    }


    func OptionObject() {
      let exception = XCTestExpectation.init(description: "optionsObject exception");
      let optionsObject = QCloudOptionsObjectRequest.init();
      optionsObject.object = "object4swift";
      optionsObject.origin = "http://www.qcloud.com";
      optionsObject.accessControlRequestMethod = "GET";
      optionsObject.accessControlRequestHeaders = "origin";
      optionsObject.bucket = "bucket-cssg-swift-temp-1253653367";
      optionsObject.finishBlock = {(result,error) in
          XCTAssertNil(error);
          XCTAssertNotNil(result);
          if error != nil{
              print(error!);
          }else{
              print(result!);
          }
          exception .fulfill();
      }
      QCloudCOSXMLService.defaultCOSXML().optionsObject(optionsObject);
      self.wait(for: [exception], timeout: 100);
    }


    func DeleteBucketCors() {
      let exception = XCTestExpectation.init(description: "deleteBucketCors exception");
      let deleteBucketCorsRequest = QCloudDeleteBucketCORSRequest.init();
      deleteBucketCorsRequest.bucket = "bucket-cssg-swift-temp-1253653367";
      deleteBucketCorsRequest.finishBlock = {(result,error) in
          XCTAssertNil(error);
          XCTAssertNotNil(result);
          if error != nil{
              print(error!);
          }else{
              print(result!);
          }
          exception .fulfill();
      }
      QCloudCOSXMLService.defaultCOSXML().deleteBucketCORS(deleteBucketCorsRequest);
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

    func testBucketCORS() {
      self.PutBucketCors();
      self.GetBucketCors();
      self.OptionObject();
      self.DeleteBucketCors();
    }
}
