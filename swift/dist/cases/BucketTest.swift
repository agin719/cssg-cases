


import XCTest
import QCloudCOSXML

class BucketTest: XCTestCase,QCloudSignatureProvider{


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


    func putBucket() {
      let exception = XCTestExpectation.init(description: "putBucket");
      //.cssg-snippet-body-start:[put-bucket]
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
      //.cssg-snippet-body-end
      self.wait(for: [exception], timeout: 100);
    }


    func deleteBucket() {
      let exception = XCTestExpectation.init(description: "deleteBucket");
      //.cssg-snippet-body-start:[delete-bucket]
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
      //.cssg-snippet-body-end
      self.wait(for: [exception], timeout: 100);
    }


    func getBucket() {
      let exception = XCTestExpectation.init(description: "getBucket");
      //.cssg-snippet-body-start:[get-bucket]
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
      //.cssg-snippet-body-end
      self.wait(for: [exception], timeout: 100);
    }


    func headBucket() {
      let exception = XCTestExpectation.init(description: "headBucket");
      //.cssg-snippet-body-start:[head-bucket]
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
      //.cssg-snippet-body-end
      self.wait(for: [exception], timeout: 100);
    }


    func putBucketAcl() {
      let exception = XCTestExpectation.init(description: "putBucketAcl");
      //.cssg-snippet-body-start:[put-bucket-acl]
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
      //.cssg-snippet-body-end
      self.wait(for: [exception], timeout: 100);
    }


    func getBucketAcl() {
      let exception = XCTestExpectation.init(description: "getBucketAcl");
      //.cssg-snippet-body-start:[get-bucket-acl]
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
      //.cssg-snippet-body-end
      self.wait(for: [exception], timeout: 100);
    }


    func putBucketCors() {
      let exception = XCTestExpectation.init(description: "putBucketCors");
      //.cssg-snippet-body-start:[put-bucket-cors]
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
      putBucketCorsReq.bucket = "bucket-cssg-test-swift-1253653367";
      putBucketCorsReq.finishBlock = {(result,error) in
          XCTAssertNil(error);
          exception.fulfill();
          if error != nil{
              print(error!);
          }else{
              print(result!);
          }}
      
      QCloudCOSXMLService.defaultCOSXML().putBucketCORS(putBucketCorsReq);
      //.cssg-snippet-body-end
      self.wait(for: [exception], timeout: 100);
    }


    func getBucketCors() {
      let exception = XCTestExpectation.init(description: "getBucketCors");
      //.cssg-snippet-body-start:[get-bucket-cors]
      let  getBucketCorsRes = QCloudGetBucketCORSRequest.init();
      getBucketCorsRes.bucket = "bucket-cssg-test-swift-1253653367";
      getBucketCorsRes.setFinish { (corsConfig, error) in
          XCTAssertNil(error);
          exception.fulfill();
          if error != nil{
              print(error!);
          }else{
              print(corsConfig!);
          }}
      QCloudCOSXMLService.defaultCOSXML().getBucketCORS(getBucketCorsRes);
      //.cssg-snippet-body-end
      self.wait(for: [exception], timeout: 100);
    }


    func optionObject() {
      let exception = XCTestExpectation.init(description: "optionObject");
      //.cssg-snippet-body-start:[option-object]
      let optionsObject = QCloudOptionsObjectRequest.init();
      optionsObject.object = "object4swift";
      optionsObject.origin = "http://www.qcloud.com";
      optionsObject.accessControlRequestMethod = "GET";
      optionsObject.accessControlRequestHeaders = "origin";
      optionsObject.bucket = "bucket-cssg-test-swift-1253653367";
      optionsObject.finishBlock = {(result,error) in
          XCTAssertNil(error);
          exception.fulfill();
          if error != nil{
              print(error!);
          }else{
              print(result!);
          }}
      QCloudCOSXMLService.defaultCOSXML().optionsObject(optionsObject);
      //.cssg-snippet-body-end
      self.wait(for: [exception], timeout: 100);
    }


    func deleteBucketCors() {
      let exception = XCTestExpectation.init(description: "deleteBucketCors");
      //.cssg-snippet-body-start:[delete-bucket-cors]
      let deleteBucketCorsRequest = QCloudDeleteBucketCORSRequest.init();
      deleteBucketCorsRequest.bucket = "bucket-cssg-test-swift-1253653367";
      deleteBucketCorsRequest.finishBlock = {(result,error) in
          XCTAssertNil(error);
          exception.fulfill();
          if error != nil{
              print(error!);
          }else{
              print(result!);
          }}
      QCloudCOSXMLService.defaultCOSXML().deleteBucketCORS(deleteBucketCorsRequest);
      //.cssg-snippet-body-end
      self.wait(for: [exception], timeout: 100);
    }


    func putBucketLifecycle() {
      let exception = XCTestExpectation.init(description: "putBucketLifecycle");
      //.cssg-snippet-body-start:[put-bucket-lifecycle]
      let putBucketLifecycleReq = QCloudPutBucketLifecycleRequest.init();
      putBucketLifecycleReq.bucket = "bucket-cssg-test-swift-1253653367";
      
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
          exception.fulfill();
          if error != nil{
              print(error!);
          }else{
              print(result!);
          }}
      QCloudCOSXMLService.defaultCOSXML().putBucketLifecycle(putBucketLifecycleReq);
      //.cssg-snippet-body-end
      self.wait(for: [exception], timeout: 100);
    }


    func getBucketLifecycle() {
      let exception = XCTestExpectation.init(description: "getBucketLifecycle");
      //.cssg-snippet-body-start:[get-bucket-lifecycle]
      let getBucketLifeCycle = QCloudGetBucketLifecycleRequest.init();
      getBucketLifeCycle.bucket = "bucket-cssg-test-swift-1253653367";
      getBucketLifeCycle.setFinish { (config, error) in
          XCTAssertNil(error);
          exception.fulfill();
          if error != nil{
              print(error!);
          }else{
              print(config!);
          }};
      QCloudCOSXMLService.defaultCOSXML().getBucketLifecycle(getBucketLifeCycle);
      //.cssg-snippet-body-end
      self.wait(for: [exception], timeout: 100);
    }


    func deleteBucketLifecycle() {
      let exception = XCTestExpectation.init(description: "deleteBucketLifecycle");
      //.cssg-snippet-body-start:[delete-bucket-lifecycle]
      let deleteBucketLifeCycle = QCloudDeleteBucketLifeCycleRequest.init();
      deleteBucketLifeCycle.bucket = "bucket-cssg-test-swift-1253653367";
      deleteBucketLifeCycle.finishBlock = { (result, error) in
          XCTAssertNil(error);
          exception.fulfill();
          if error != nil{
              print(error!);
          }else{
              print(result!);
          }};
      QCloudCOSXMLService.defaultCOSXML().deleteBucketLifeCycle(deleteBucketLifeCycle);
      //.cssg-snippet-body-end
      self.wait(for: [exception], timeout: 100);
    }


    func putBucketVersioning() {
      let exception = XCTestExpectation.init(description: "putBucketVersioning");
      //.cssg-snippet-body-start:[put-bucket-versioning]
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
      //.cssg-snippet-body-end
      self.wait(for: [exception], timeout: 100);
    }


    func getBucketVersioning() {
      let exception = XCTestExpectation.init(description: "getBucketVersioning");
      //.cssg-snippet-body-start:[get-bucket-versioning]
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
      //.cssg-snippet-body-end
      self.wait(for: [exception], timeout: 100);
    }


    func putBucketReplication() {
      let exception = XCTestExpectation.init(description: "putBucketReplication");
      //.cssg-snippet-body-start:[put-bucket-replication]
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
      //.cssg-snippet-body-end
      self.wait(for: [exception], timeout: 100);
    }


    func getBucketReplication() {
      let exception = XCTestExpectation.init(description: "getBucketReplication");
      //.cssg-snippet-body-start:[get-bucket-replication]
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
      //.cssg-snippet-body-end
      self.wait(for: [exception], timeout: 100);
    }


    func deleteBucketReplication() {
      let exception = XCTestExpectation.init(description: "deleteBucketReplication");
      //.cssg-snippet-body-start:[delete-bucket-replication]
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
      //.cssg-snippet-body-end
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

      self.putBucket();
    }

    override func tearDown() {
      self.deleteBucket();
    }

    func testtestBucketACL() {
      self.getBucket();
      self.headBucket();
      self.putBucketAcl();
      self.getBucketAcl();
    }
    func testtestBucketCORS() {
      self.putBucketCors();
      self.getBucketCors();
      self.optionObject();
      self.deleteBucketCors();
    }
    func testtestBucketLifecycle() {
      self.putBucketLifecycle();
      self.getBucketLifecycle();
      self.deleteBucketLifecycle();
    }
    func testtestBucketReplicationAndVersioning() {
      self.putBucketVersioning();
      self.getBucketVersioning();
      self.putBucketReplication();
      self.getBucketReplication();
      self.deleteBucketReplication();
    }
}
