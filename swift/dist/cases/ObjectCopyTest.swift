


import XCTest
import QCloudCOSXML

class ObjectCopyTest: XCTestCase,QCloudSignatureProvider{


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


    func CopyObject() {
      let exception = XCTestExpectation.init(description: "CopyObject");
      let putObjectCopy = QCloudPutObjectCopyRequest.init();
      putObjectCopy.bucket = "bucket-cssg-test-swift-1253653367";
      putObjectCopy.object = "object4swift";
      putObjectCopy.objectCopySource = "bucket-cssg-source-1253653367.cos.ap-guangzhou.myqcloud.com/sourceObject";
      putObjectCopy.setFinish { (result, error) in
          XCTAssertNil(error);
          exception.fulfill();
          if error != nil{
              print(error!);
          }else{
              print(result!);
          }}
      QCloudCOSXMLService.defaultCOSXML().putObjectCopy(putObjectCopy);
      
      self.wait(for: [exception], timeout: 100);
    }


    func InitMultiUpload() {
      let exception = XCTestExpectation.init(description: "InitMultiUpload");
      let initRequest = QCloudInitiateMultipartUploadRequest.init();
      initRequest.bucket = "bucket-cssg-test-swift-1253653367";
      initRequest.object = "object4swift";
      initRequest.setFinish { (result, error) in
          XCTAssertNil(error);
          exception.fulfill();
          if error != nil{
              print(error!);
          }else{
              //获取分块上传的 uploadId，后续的上传都需要这个 ID，请保存以备后续使用
              self.uploadId = result!.uploadId;
              print(result!.uploadId);
          }}
      QCloudCOSXMLService.defaultCOSXML().initiateMultipartUpload(initRequest);
      
      self.wait(for: [exception], timeout: 100);
    }


    func UploadPartCopy() {
      let exception = XCTestExpectation.init(description: "UploadPartCopy");
      let req = QCloudUploadPartCopyRequest.init();
      req.bucket = "bucket-cssg-test-swift-1253653367";
      req.object = "object4swift";
      //源文件 URL 路径，可以通过 versionid 子资源指定历史版本
      req.source = "bucket-cssg-source-1253653367.cos.ap-guangzhou.myqcloud.com/sourceObject";
      //在初始化分块上传的响应中，会返回一个唯一的描述符（upload ID）
      req.uploadID = "exampleUploadId";
      if self.uploadId != nil {
          req.uploadID = self.uploadId!;
      }
      
      //标志当前分块的序号
      req.partNumber = 1;
      req.setFinish { (result, error) in
          XCTAssertNil(error);
          exception.fulfill();
          if error != nil{
              print(error!);
          }else{
              let mutipartInfo = QCloudMultipartInfo.init();
              //获取所复制分块的 etag
              mutipartInfo.eTag = result!.eTag;
              mutipartInfo.partNumber = "1";
              self.parts = [mutipartInfo];
          }}
      QCloudCOSXMLService.defaultCOSXML().uploadPartCopy(req);
      
      self.wait(for: [exception], timeout: 100);
    }


    func CompleteMultiUpload() {
      let exception = XCTestExpectation.init(description: "CompleteMultiUpload");
      let  complete = QCloudCompleteMultipartUploadRequest.init();
      complete.bucket = "bucket-cssg-test-swift-1253653367";
      complete.object = "object4swift";
      //本次要查询的分块上传的 uploadId，可从初始化分块上传的请求结果 QCloudInitiateMultipartUploadResult 中得到
      complete.uploadId = "exampleUploadId";
      if self.uploadId != nil {
          complete.uploadId = self.uploadId!;
      }
      
      
      //已上传分块的信息
      let completeInfo = QCloudCompleteMultipartUploadInfo.init();
      
      completeInfo.parts = self.parts!;
      complete.parts = completeInfo;
      complete.setFinish { (result, error) in
          XCTAssertNil(error);
          exception.fulfill();
          if error != nil{
              print(error!)
          }else{
              //从 result 中获取上传结果
              print(result!);
          }}
      QCloudCOSXMLService.defaultCOSXML().completeMultipartUpload(complete);
      
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

    func testObjectCopy() {
      self.CopyObject();
      self.InitMultiUpload();
      self.UploadPartCopy();
      self.CompleteMultiUpload();
    }
}
