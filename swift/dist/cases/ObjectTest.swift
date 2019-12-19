


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


    func deleteObject() {
      let exception = XCTestExpectation.init(description: "deleteObject");
      //.cssg-snippet-body-start:[delete-object]
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


    func putObject() {
      let exception = XCTestExpectation.init(description: "putObject");
      //.cssg-snippet-body-start:[put-object]
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
      //.cssg-snippet-body-end
      self.wait(for: [exception], timeout: 100);
    }


    func putObjectAcl() {
      let exception = XCTestExpectation.init(description: "putObjectAcl");
      //.cssg-snippet-body-start:[put-object-acl]
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
      //.cssg-snippet-body-end
      self.wait(for: [exception], timeout: 100);
    }


    func getObjectAcl() {
      let exception = XCTestExpectation.init(description: "getObjectAcl");
      //.cssg-snippet-body-start:[get-object-acl]
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
      //.cssg-snippet-body-end
      self.wait(for: [exception], timeout: 100);
    }


    func getPresignDownloadUrl() {
      let exception = XCTestExpectation.init(description: "getPresignDownloadUrl");
      //.cssg-snippet-body-start:[get-presign-download-url]
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
      //.cssg-snippet-body-end
      self.wait(for: [exception], timeout: 100);
    }


    func deleteMultiObject() {
      let exception = XCTestExpectation.init(description: "deleteMultiObject");
      //.cssg-snippet-body-start:[delete-multi-object]
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
      //.cssg-snippet-body-end
      self.wait(for: [exception], timeout: 100);
    }


    func restoreObject() {
      let exception = XCTestExpectation.init(description: "restoreObject");
      //.cssg-snippet-body-start:[restore-object]
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
      //.cssg-snippet-body-end
      self.wait(for: [exception], timeout: 100);
    }


    func initMultiUpload() {
      let exception = XCTestExpectation.init(description: "initMultiUpload");
      //.cssg-snippet-body-start:[init-multi-upload]
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
      //.cssg-snippet-body-end
      self.wait(for: [exception], timeout: 100);
    }


    func listMultiUpload() {
      let exception = XCTestExpectation.init(description: "listMultiUpload");
      //.cssg-snippet-body-start:[list-multi-upload]
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
      //.cssg-snippet-body-end
      self.wait(for: [exception], timeout: 100);
    }


    func uploadPart() {
      let exception = XCTestExpectation.init(description: "uploadPart");
      //.cssg-snippet-body-start:[upload-part]
      
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
      //.cssg-snippet-body-end
      self.wait(for: [exception], timeout: 100);
    }


    func listParts() {
      let exception = XCTestExpectation.init(description: "listParts");
      //.cssg-snippet-body-start:[list-parts]
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
      //.cssg-snippet-body-end
      self.wait(for: [exception], timeout: 100);
    }


    func completeMultiUpload() {
      let exception = XCTestExpectation.init(description: "completeMultiUpload");
      //.cssg-snippet-body-start:[complete-multi-upload]
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
      //.cssg-snippet-body-end
      self.wait(for: [exception], timeout: 100);
    }


    func abortMultiUpload() {
      let exception = XCTestExpectation.init(description: "abortMultiUpload");
      //.cssg-snippet-body-start:[abort-multi-upload]
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
      //.cssg-snippet-body-end
      self.wait(for: [exception], timeout: 100);
    }


    func transferUploadObject() {
      let exception = XCTestExpectation.init(description: "transferUploadObject");
      //.cssg-snippet-body-start:[transfer-upload-object]
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
      //.cssg-snippet-body-end
      self.wait(for: [exception], timeout: 100);
    }


    func transferCopyObject() {
      let exception = XCTestExpectation.init(description: "transferCopyObject");
      //.cssg-snippet-body-start:[transfer-copy-object]
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
      //.cssg-snippet-body-end
      self.wait(for: [exception], timeout: 100);
    }


    func copyObject() {
      let exception = XCTestExpectation.init(description: "copyObject");
      //.cssg-snippet-body-start:[copy-object]
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
      //.cssg-snippet-body-end
      self.wait(for: [exception], timeout: 100);
    }


    func uploadPartCopy() {
      let exception = XCTestExpectation.init(description: "uploadPartCopy");
      //.cssg-snippet-body-start:[upload-part-copy]
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
      //.cssg-snippet-body-end
      self.wait(for: [exception], timeout: 100);
    }


    func headObject() {
      let exception = XCTestExpectation.init(description: "headObject");
      //.cssg-snippet-body-start:[head-object]
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
      //.cssg-snippet-body-end
      self.wait(for: [exception], timeout: 100);
    }


    func getObject() {
      let exception = XCTestExpectation.init(description: "getObject");
      //.cssg-snippet-body-start:[get-object]
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
      self.deleteObject();
      self.deleteBucket();
    }

    func testtestObjectMetadata() {
      self.putObject();
      self.putObjectAcl();
      self.getObjectAcl();
      self.getPresignDownloadUrl();
      self.deleteMultiObject();
      self.restoreObject();
    }
    func testtestObjectMultiUpload() {
      self.initMultiUpload();
      self.listMultiUpload();
      self.uploadPart();
      self.listParts();
      self.completeMultiUpload();
    }
    func testtestObjectAbortMultiUpload() {
      self.initMultiUpload();
      self.uploadPart();
      self.abortMultiUpload();
    }
    func testtestObjectTransfer() {
      self.transferUploadObject();
      self.transferCopyObject();
    }
    func testtestObjectCopy() {
      self.copyObject();
      self.initMultiUpload();
      self.uploadPartCopy();
      self.completeMultiUpload();
    }
    func testtestObjectPutget() {
      self.putObject();
      self.headObject();
      self.getObject();
      self.deleteObject();
    }
}
