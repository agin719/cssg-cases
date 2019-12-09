


import XCTest
import QCloudCOSXML

class ObjectTransferTest: XCTestCase,QCloudSignatureProvider{


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


    func ListMultiUpload() {
      let exception = XCTestExpectation.init(description: "ListMultiUpload");
      let listParts = QCloudListBucketMultipartUploadsRequest.init();
      listParts.bucket = "bucket-cssg-test-swift-1253653367";
      listParts.maxUploads = 100;
      listParts.setFinish { (result, error) in
          XCTAssertNil(error);
          exception.fulfill();
          if error != nil{
              print(error!);
          }else{
              print(result!);
          }}
      QCloudCOSXMLService.defaultCOSXML().listBucketMultipartUploads(listParts);
      
      self.wait(for: [exception], timeout: 100);
    }


    func UploadPart() {
      let exception = XCTestExpectation.init(description: "UploadPart");
      
      let uploadPart = QCloudUploadPartRequest<AnyObject>.init();
      uploadPart.bucket = "bucket-cssg-test-swift-1253653367";
      uploadPart.object = "object4swift";
      uploadPart.partNumber = 1;
      //标识本次分块上传的 ID；使用 Initiate Multipart Upload 接口初始化分块上传时会得到一个 uploadId
      //该 ID 不但唯一标识这一分块数据，也标识了这分块数据在整个文件内的相对位置
      uploadPart.uploadId = "exampleUploadId";
      if self.uploadId != nil {
           uploadPart.uploadId = self.uploadId!;
      }
      
      let dataBody:NSData? = "wrwrwrwrwrwwrwrwrwrwrwwrwrwrwrwrwwrwrwrwrwrwwrwrwrwrwrwwrwrwrwrwrwwrwrwrwrwrwwrwrwrwrwrwwrwrwrwrwrwwrwrwrwrwrwwrwrwrwrwrwwrwrwrwrwrwwrwrwrwrwrw".data(using: .utf8) as NSData?;
      uploadPart.body = dataBody!;
      uploadPart.setFinish { (result, error) in
          XCTAssertNil(error);
          exception.fulfill();
          if error != nil{
              print(error!);
          }else{
              let mutipartInfo = QCloudMultipartInfo.init();
              //获取所上传分块的 etag
              mutipartInfo.eTag = result!.eTag;
              mutipartInfo.partNumber = "1";
              // 保存起来用于最好完成上传时使用
              self.parts = [mutipartInfo];
          }}
      uploadPart.sendProcessBlock = {(bytesSent,totalBytesSent,totalBytesExpectedToSend) in
          //上传进度信息
          print("totalBytesSent:\(totalBytesSent) totalBytesExpectedToSend:\(totalBytesExpectedToSend)");
          
      }
      QCloudCOSXMLService.defaultCOSXML().uploadPart(uploadPart);
      
      self.wait(for: [exception], timeout: 100);
    }


    func ListParts() {
      let exception = XCTestExpectation.init(description: "ListParts");
      let req = QCloudListMultipartRequest.init();
      req.object = "object4swift";
      req.bucket = "bucket-cssg-test-swift-1253653367";
      //在初始化分块上传的响应中，会返回一个唯一的描述符（upload ID）
      req.uploadId = "exampleUploadId";
      if self.uploadId != nil {
          req.uploadId = self.uploadId!;
      }
      req.setFinish { (result, error) in
          XCTAssertNil(error);
          exception.fulfill();
          if error != nil{
              print(error!);
          }else{
              //从 result 中获取已上传分块信息
              print(result!);
          }}
      
      QCloudCOSXMLService.defaultCOSXML().listMultipart(req);
      
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
      if self.parts == nil {
          print("没有要完成的分块");
          return;
      }
      
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


    func AbortMultiUpload() {
      let exception = XCTestExpectation.init(description: "AbortMultiUpload");
      let abort = QCloudAbortMultipfartUploadRequest.init();
      abort.bucket = "bucket-cssg-test-swift-1253653367";
      abort.object = "object4swift";
      //本次要查询的分块上传的 uploadId，可从初始化分块上传的请求结果 QCloudInitiateMultipartUploadResult 中得到
      abort.uploadId = "exampleUploadId";
      if self.uploadId != nil {
          abort.uploadId = self.uploadId!;
      }
      
      abort.finishBlock = {(result,error)in
          XCTAssertNil(error);
          exception.fulfill();
          if error != nil{
              print(error!)
          }else{
              //可以从 outputObject 中获取 response 中 etag 或者自定义头部等信息
              print(result!);
          }    
      }
      QCloudCOSXMLService.defaultCOSXML().abortMultipfartUpload(abort);
      
      self.wait(for: [exception], timeout: 100);
    }


    func TransferUploadObject() {
      let exception = XCTestExpectation.init(description: "TransferUploadObject");
      let uploadRequest = QCloudCOSXMLUploadObjectRequest<AnyObject>.init();
      let dataBody:NSData? = "wrwrwrwrwrw".data(using: .utf8) as NSData?;
      uploadRequest.body = dataBody!;
      uploadRequest.bucket = "bucket-cssg-test-swift-1253653367";
      uploadRequest.object = "object4swift";
      //设置上传参数
      uploadRequest.initMultipleUploadFinishBlock = {(multipleUploadInitResult,resumeData) in
          //在初始化分块上传完成以后会回调该 block，在这里可以获取 resumeData，并且可以通过 resumeData 生成一个分块上传的请求
          let resumeUploadRequest = QCloudCOSXMLUploadObjectRequest<AnyObject>.init(request: resumeData as Data?);
      }
      uploadRequest.sendProcessBlock = {(bytesSent , totalBytesSent , totalBytesExpectedToSend) in
          
      }
      uploadRequest.setFinish { (result, error) in
          exception.fulfill();
          if error != nil{
              print(error!)
          }else{
              //从 result 中获取请求的结果
              print(result!);
          }}
      
      QCloudCOSTransferMangerService.defaultCOSTransferManager().uploadObject(uploadRequest);
      
      //•••在完成了初始化，并且上传没有完成前
      var error:NSError?;
          //这里是主动调用取消，并且产生 resumetData 的例子
      do {
          let resumedData = try uploadRequest.cancel(byProductingResumeData: &error);
              var resumeUploadRequest:QCloudCOSXMLUploadObjectRequest<AnyObject>?;
                   resumeUploadRequest = QCloudCOSXMLUploadObjectRequest<AnyObject>.init(request: resumedData as Data?);
                   //生成的用于恢复上传的请求可以直接上传
          if resumeUploadRequest != nil {
              QCloudCOSTransferMangerService.defaultCOSTransferManager().uploadObject(resumeUploadRequest!);
          }
                   
      } catch  {
          print("resumeData 为空");
          return;
      }
      
      self.wait(for: [exception], timeout: 100);
    }


    func TransferCopyObject() {
      let exception = XCTestExpectation.init(description: "TransferCopyObject");
      let copyRequest =  QCloudCOSXMLCopyObjectRequest.init();
      copyRequest.bucket = "bucket-cssg-test-swift-1253653367";//目的 <BucketName-APPID>，需要是公有读或者在当前账号有权限
      copyRequest.object = "object4swift";//目的文件名称
      //文件来源 <BucketName-APPID>，需要是公有读或者在当前账号有权限
      copyRequest.sourceBucket = "bucket-cssg-source-1253653367";
      copyRequest.sourceObject = "sourceObject";//源文件名称
      copyRequest.sourceAPPID = "1253653367";//源文件的 APPID
      copyRequest.sourceRegion = "ap-guangzhou";//来源的地域
      copyRequest.setFinish { (copyResult, error) in
          XCTAssertNil(error);
          exception.fulfill();
          if error != nil{
              print(error!);
          }else{
              print(copyResult!);
          }
      }
      //注意如果是跨地域复制，这里使用的 transferManager 所在的 region 必须为目标桶所在的 region
      QCloudCOSTransferMangerService.defaultCOSTransferManager().copyObject(copyRequest);
      
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

    func testObjectTransfer() {
      self.InitMultiUpload();
      self.ListMultiUpload();
      self.UploadPart();
      self.ListParts();
      self.CompleteMultiUpload();
      self.InitMultiUpload();
      self.UploadPart();
      self.AbortMultiUpload();
      self.TransferUploadObject();
      self.TransferCopyObject();
    }
}
