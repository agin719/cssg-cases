


import XCTest
import QCloudCOSXML


class ObjectMultiUploadTest: XCTestCase,QCloudSignatureProvider{


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


    func InitMultiUpload() {
      let exception = XCTestExpectation.init(description: "initRequest exception");
      let initRequest = QCloudInitiateMultipartUploadRequest.init();
      initRequest.bucket = "bucket-cssg-test-1253653367";
      initRequest.object = "object4swift";
      initRequest.setFinish { (result, error) in
          XCTAssertNil(error);
          XCTAssertNotNil(result);
          if error != nil{
              print(error!);
          }else{
              //获取分块上传的 uploadId，后续的上传都需要这个 ID，请保存以备后续使用
              self.uploadId = result!.uploadId;
              print(result!.uploadId);
          }
          exception .fulfill();
      }
      QCloudCOSXMLService.defaultCOSXML().initiateMultipartUpload(initRequest);
      self.wait(for: [exception], timeout: 100);
    }


    func ListMultiUpload() {
      let exception = XCTestExpectation.init(description: "listParts exception");
      let listParts = QCloudListBucketMultipartUploadsRequest.init();
      listParts.bucket = "bucket-cssg-test-1253653367";
      listParts.maxUploads = 100;
      listParts.setFinish { (result, error) in
          XCTAssertNil(error);
          XCTAssertNotNil(result);
          if error != nil{
              print(error!);
          }else{
              print(result!);
          }
          exception .fulfill();
      }
      QCloudCOSXMLService.defaultCOSXML().listBucketMultipartUploads(listParts);
      self.wait(for: [exception], timeout: 100);
    }


    func UploadPart() {
      let exception = XCTestExpectation.init(description: "uploadPart exception");
      
      let uploadPart = QCloudUploadPartRequest<AnyObject>.init();
      uploadPart.bucket = "bucket-cssg-test-1253653367";
      uploadPart.object = "object4swift";
      uploadPart.partNumber = 1;
      //标识本次分块上传的 ID；使用 Initiate Multipart Upload 接口初始化分块上传时会得到一个 uploadId
      //该 ID 不但唯一标识这一分块数据，也标识了这分块数据在整个文件内的相对位置
      uploadPart.uploadId = "example-uploadId";
      if self.uploadId != nil {
           uploadPart.uploadId = self.uploadId!;
      }
      
      let dataBody:NSData? = "wrwrwrwrwrwwrwrwrwrwrwwrwrwrwrwrwwrwrwrwrwrwwrwrwrwrwrwwrwrwrwrwrwwrwrwrwrwrwwrwrwrwrwrwwrwrwrwrwrwwrwrwrwrwrwwrwrwrwrwrwwrwrwrwrwrwwrwrwrwrwrw".data(using: .utf8) as NSData?;
      uploadPart.body = dataBody!;
      uploadPart.setFinish { (result, error) in
          XCTAssertNil(error);
          XCTAssertNotNil(result);
          if error != nil{
              print(error!);
          }else{
              let mutipartInfo = QCloudMultipartInfo.init();
              //获取所上传分块的 etag
              mutipartInfo.eTag = result!.eTag;
              mutipartInfo.partNumber = "1";
          }
            exception .fulfill();
      }
      uploadPart.sendProcessBlock = {(bytesSent,totalBytesSent,totalBytesExpectedToSend) in
          //上传进度信息
          print("totalBytesSent:\(totalBytesSent) totalBytesExpectedToSend:\(totalBytesExpectedToSend)");
          
      }
      QCloudCOSXMLService.defaultCOSXML().uploadPart(uploadPart);
      self.wait(for: [exception], timeout: 100);
    }


    func ListParts() {
      let exception = XCTestExpectation.init(description: "listParts exception");
      let req = QCloudListMultipartRequest.init();
      req.object = "object4swift";
      req.bucket = "bucket-cssg-test-1253653367";
      //在初始化分块上传的响应中，会返回一个唯一的描述符（upload ID）
      req.uploadId = "example-uploadId";
      if self.uploadId != nil {
          req.uploadId = self.uploadId!;
      }
      req.setFinish { (result, error) in
          XCTAssertNil(error);
          XCTAssertNotNil(result);
          if error != nil{
              print(error!);
          }else{
              //从 result 中获取已上传分块信息
              print(result!);
          }
          exception .fulfill();
      }
      
      QCloudCOSXMLService.defaultCOSXML().listMultipart(req);
      self.wait(for: [exception], timeout: 100);
    }


    func CompleteMultiUpload() {
      let exception = XCTestExpectation.init(description: "complete exception");
      let  complete = QCloudCompleteMultipartUploadRequest.init();
      complete.bucket = "bucket-cssg-test-1253653367";
      complete.object = "object4swift";
      //本次要查询的分块上传的 uploadId，可从初始化分块上传的请求结果 QCloudInitiateMultipartUploadResult 中得到
      complete.uploadId = "example-uploadId";
      if self.uploadId != nil {
          complete.uploadId = self.uploadId!;
      }
      
      
      //已上传分块的信息
      let completeInfo = QCloudCompleteMultipartUploadInfo.init();
      if self.parts == nil {
          print("没有要完成的分块");
          return;
      }
      
       completeInfo.parts = self.parts!;
      complete.parts = completeInfo;
      complete.setFinish { (result, error) in
          XCTAssertNil(error);
          XCTAssertNotNil(result);
          if error != nil{
              print(error!)
          }else{
              //从 result 中获取上传结果
              print(result!);
          }
          exception .fulfill();
      }
      QCloudCOSXMLService.defaultCOSXML().completeMultipartUpload(complete);
      self.wait(for: [exception], timeout: 100);
    }


    func AbortMultiUpload() {
      let exception = XCTestExpectation.init(description: "abort exception");
      let abort = QCloudAbortMultipfartUploadRequest.init();
      abort.bucket = "bucket-cssg-test-1253653367";
      abort.object = "object4swift";
      //本次要查询的分块上传的 uploadId，可从初始化分块上传的请求结果 QCloudInitiateMultipartUploadResult 中得到
      abort.uploadId = "example-uploadId";
      if self.uploadId != nil {
          abort.uploadId = self.uploadId!;
      }
      
      abort.finishBlock = {(result,error)in
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
      QCloudCOSXMLService.defaultCOSXML().abortMultipfartUpload(abort);
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

    func testObjectMultiUpload() {
      self.InitMultiUpload();
      self.ListMultiUpload();
      self.UploadPart();
      self.ListParts();
      self.CompleteMultiUpload();
      self.InitMultiUpload();
      self.UploadPart();
      self.AbortMultiUpload();
    }
}
