


import XCTest
import QCloudCOSXML

class ObjectTest: XCTestCase,QCloudSignatureProvider{


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


    func PutObject() {
      let exception = XCTestExpectation.init(description: "PutObject");
      let putObject = QCloudPutObjectRequest<AnyObject>.init();
      putObject.bucket = "bucket-cssg-test-swift-1253653367";
      let dataBody:NSData? = "wrwrwrwrwrw".data(using: .utf8) as NSData?;
      putObject.body =  dataBody!;
      putObject.object = "object4swift";
      putObject.finishBlock = {(result,error) in
          XCTAssertNil(error);
          exception.fulfill();
          if error != nil{
              print(error!);
          }else{
              print(result!);
          }}
      QCloudCOSXMLService.defaultCOSXML().putObject(putObject);
      
      self.wait(for: [exception], timeout: 100);
    }


    func PutObjectAcl() {
      let exception = XCTestExpectation.init(description: "PutObjectAcl");
      let putObjectACl = QCloudPutObjectACLRequest.init();
      putObjectACl.bucket = "bucket-cssg-test-swift-1253653367";
      putObjectACl.object = "object4swift";
      let grantString = "id=\"1253653367\"";
      putObjectACl.grantFullControl = grantString;
      putObjectACl.finishBlock = {(result,error)in
          XCTAssertNil(error);
          exception.fulfill();
          if error != nil{
              print(error!)
          }else{
              //可以从 outputObject 中获取 response 中 etag 或者自定义头部等信息
              print(result!);
          }}
      QCloudCOSXMLService.defaultCOSXML().putObjectACL(putObjectACl);
      
      self.wait(for: [exception], timeout: 100);
    }


    func GetObjectAcl() {
      let exception = XCTestExpectation.init(description: "GetObjectAcl");
      let getObjectACL = QCloudGetObjectACLRequest.init();
      getObjectACL.bucket = "bucket-cssg-test-swift-1253653367";
      getObjectACL.object = "object4swift";
      getObjectACL.setFinish { (result, error) in
          XCTAssertNil(error);
          exception.fulfill();
          if error != nil{
              print(error!)
          }else{
              //可以从 result 的 accessControlList 中获取对象的 ACL
              print(result!.accessControlList);
          }}
      QCloudCOSXMLService.defaultCOSXML().getObjectACL(getObjectACL);
      
      self.wait(for: [exception], timeout: 100);
    }


    func HeadObject() {
      let exception = XCTestExpectation.init(description: "HeadObject");
      let headObject = QCloudHeadObjectRequest.init();
      headObject.bucket = "bucket-cssg-test-swift-1253653367";
      headObject.object  = "object4swift";
      headObject.finishBlock =  {(result,error) in
          XCTAssertNil(error);
          exception.fulfill();
          if error != nil{
              print(error!);
          }else{
              print(result!);
          }}
      QCloudCOSXMLService.defaultCOSXML().headObject(headObject);
      
      self.wait(for: [exception], timeout: 100);
    }


    func GetObject() {
      let exception = XCTestExpectation.init(description: "GetObject");
      let getObject = QCloudGetObjectRequest.init();
      getObject.bucket = "bucket-cssg-test-swift-1253653367";
      getObject.object = "object4swift";
      getObject.downloadingURL = URL.init(string: NSTemporaryDirectory())!.appendingPathComponent(getObject.object);
      getObject.finishBlock = {(result,error) in
          XCTAssertNil(error);
          exception.fulfill();
          if error != nil{
              print(error!);
          }else{
              print(result!);
          }};
      getObject.downProcessBlock = {(bytesDownload, totalBytesDownload,  totalBytesExpectedToDownload) in
          print("totalBytesDownload:\(totalBytesDownload) totalBytesExpectedToDownload:\(totalBytesExpectedToDownload)");
      }
      QCloudCOSXMLService.defaultCOSXML().getObject(getObject);
      
      self.wait(for: [exception], timeout: 100);
    }


    func DeleteObject() {
      let exception = XCTestExpectation.init(description: "DeleteObject");
      let deleteObject = QCloudDeleteObjectRequest.init();
      deleteObject.bucket = "bucket-cssg-test-swift-1253653367";
      deleteObject.object = "object4swift";
      deleteObject.finishBlock = {(result,error)in
          XCTAssertNil(error);
          exception.fulfill();
          if error != nil{
              print(error!);
          }else{
              print(result!);
          }}
      QCloudCOSXMLService.defaultCOSXML().deleteObject(deleteObject);
      
      self.wait(for: [exception], timeout: 100);
    }


    func DeleteMultiObject() {
      let exception = XCTestExpectation.init(description: "DeleteMultiObject");
      let mutipleDel = QCloudDeleteMultipleObjectRequest.init();
      mutipleDel.bucket = "bucket-cssg-test-swift-1253653367";
      
      let info1 = QCloudDeleteObjectInfo.init();
      info1.key = "object4swift";
      let info2 = QCloudDeleteObjectInfo.init();
      
      
      let deleteInfos = QCloudDeleteInfo.init();
      deleteInfos.objects = [info1];
      deleteInfos.quiet = false;
      mutipleDel.deleteObjects = deleteInfos;
      
      mutipleDel.setFinish { (result, error) in
          XCTAssertNil(error);
          exception.fulfill();
          if error != nil{
              print(error!);
          }else{
              print(result!);
          }}
      QCloudCOSXMLService.defaultCOSXML().deleteMultipleObject(mutipleDel);
      
      self.wait(for: [exception], timeout: 100);
    }


    func RestoreObject() {
      let exception = XCTestExpectation.init(description: "RestoreObject");
      let restore = QCloudPostObjectRestoreRequest.init();
      restore.bucket = "bucket-cssg-test-swift-1253653367";
      restore.object = "object4swift";
      restore.restoreRequest.days = 10;
      restore.restoreRequest.casJobParameters.tier = .standard;
      restore.finishBlock = {(result,error)in
          exception.fulfill();
          if error != nil{
              print(error!)
          }else{
              //可以从 outputObject 中获取 response 中 etag 或者自定义头部等信息
              print(result!);
          }}
      QCloudCOSXMLService.defaultCOSXML().postObjectRestore(restore);
      
      self.wait(for: [exception], timeout: 100);
    }


    func GetPresignDownloadUrl() {
      let exception = XCTestExpectation.init(description: "GetPresignDownloadUrl");
      let getPresign  = QCloudGetPresignedURLRequest.init();
      getPresign.bucket = "bucket-cssg-test-swift-1253653367" ;
      getPresign.httpMethod = "GET";
      getPresign.object = "object4swift";
      getPresign.setFinish { (result, error) in
          XCTAssertNil(error);
          exception.fulfill();
          if error == nil{
              print(result?.presienedURL as Any);
          }}
      QCloudCOSXMLService.defaultCOSXML().getPresignedURL(getPresign);
      
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
      self.DeleteObject();
      self.DeleteBucket();
    }

    func testObject() {
      self.PutObject();
      self.PutObjectAcl();
      self.GetObjectAcl();
      self.HeadObject();
      self.GetObject();
      self.DeleteObject();
      self.DeleteMultiObject();
      self.RestoreObject();
      self.GetPresignDownloadUrl();
    }
}
