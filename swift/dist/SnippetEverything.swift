


import XCTest
import QCloudCOSXML


class SnippetEverythingTest: XCTestCase,QCloudSignatureProvider{


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


    func GetService() {
      let exception = XCTestExpectation.init(description: "get service exception");
      let getServiceReq = QCloudGetServiceRequest.init();
      getServiceReq.setFinish{(result,error) in
          if result == nil {
              print(error!);
          } else {
              //从result中获取返回信息
              print(result!);
          }
          exception .fulfill();
      }
      QCloudCOSXMLService.defaultCOSXML().getService(getServiceReq);
      self.wait(for: [exception], timeout: 100);
    }


    func PutBucket() {
      let exception = XCTestExpectation.init(description: "putBucket exception");
      let putBucketReq = QCloudPutBucketRequest.init();
      putBucketReq.bucket = "examplebucket-1250000000";
      putBucketReq.finishBlock = {(result,error) in
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


    func HeadBucket() {
      let exception = XCTestExpectation.init(description: "headBucket exception");
      let headBucketReq = QCloudHeadBucketRequest.init();
      headBucketReq.bucket = "examplebucket-1250000000";
      headBucketReq.finishBlock = {(result,error) in
          if error != nil{
              print(error!);
          }else{
              print( result!);
          }
          exception .fulfill();
      }
      QCloudCOSXMLService.defaultCOSXML().headBucket(headBucketReq);
      self.wait(for: [exception], timeout: 100);
    }


    func DeleteBucket() {
      let exception = XCTestExpectation.init(description: "deleteBucket exception");
      let deleteBucketReq = QCloudDeleteBucketRequest.init();
      deleteBucketReq.bucket = "examplebucket-1250000000";
      deleteBucketReq.finishBlock = {(result,error) in
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


    func PutBucketAcl() {
      let exception = XCTestExpectation.init(description: "putBucketACL exception");
      let putBucketACLReq = QCloudPutBucketACLRequest.init();
      putBucketACLReq.bucket = "examplebucket-1250000000";
      let appTD = "1131975903";//授予全新的账号ID
      let ownerIdentifier = "qcs::cam::uin/\(appTD):uin/\(appTD)";
      let grantString = "id=\"\(ownerIdentifier)\"";
      putBucketACLReq.grantWrite = grantString;
      putBucketACLReq.finishBlock = {(result,error) in
          if error != nil{
              print(error!);
          }else{
              print(result!);
          }
          exception .fulfill();
      }
      QCloudCOSXMLService.defaultCOSXML().putBucketACL(putBucketACLReq);
      self.wait(for: [exception], timeout: 100);
    }


    func GetBucketAcl() {
      let exception = XCTestExpectation.init(description: "getBucketACL exception");
      let getBucketACLReq = QCloudGetBucketACLRequest.init();
      getBucketACLReq.bucket = "examplebucket-1250000000";
      getBucketACLReq.setFinish { (result, error) in
          if error != nil{
              print(error!);
          }else{
              print(result!);
          }
          exception .fulfill();
      }
      QCloudCOSXMLService.defaultCOSXML().getBucketACL(getBucketACLReq)
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
      putBucketCorsReq.bucket = "examplebucket-1250000000";
      putBucketCorsReq.finishBlock = {(result,error) in
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
      getBucketCorsRes.bucket = "examplebucket-1250000000";
      getBucketCorsRes.setFinish { (corsConfig, error) in
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


    func DeleteBucketCors() {
      let exception = XCTestExpectation.init(description: "deleteBucketCors exception");
      let deleteBucketCorsRequest = QCloudDeleteBucketCORSRequest.init();
      deleteBucketCorsRequest.bucket = "examplebucket-1250000000";
      deleteBucketCorsRequest.finishBlock = {(result,error) in
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


    func PutBucketLifecycle() {
      let exception = XCTestExpectation.init(description: "putBucketLifecycle exception");
      let putBucketLifecycleReq = QCloudPutBucketLifecycleRequest.init();
      putBucketLifecycleReq.bucket = "examplebucket-1250000000";
      
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
      getBucketLifeCycle.bucket = "examplebucket-1250000000";
      getBucketLifeCycle.setFinish { (config, error) in
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
      deleteBucketLifeCycle.bucket = "examplebucket-1250000000";
      deleteBucketLifeCycle.finishBlock = { (result, error) in
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


    func PutBucketVersioning() {
      let exception = XCTestExpectation.init(description: "putBucketVersioning exception");
      let putBucketVersioning = QCloudPutBucketVersioningRequest.init();
      putBucketVersioning.bucket = "examplebucket-1250000000";
      
      let config = QCloudBucketVersioningConfiguration.init();
      config.status = .enabled;
      
      putBucketVersioning.configuration = config;
      
      putBucketVersioning.finishBlock = {(result,error) in
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


    func GetBucketVersioning() {
      let exception = XCTestExpectation.init(description: "testGetBucketVersioning exception");
      let getBucketVersioning = QCloudGetBucketVersioningRequest.init();
      getBucketVersioning.bucket = "examplebucket-1250000000";
      getBucketVersioning.setFinish { (config, error) in
          if error != nil{
              print(error!);
          }else{
              print(config!);
          }
          exception .fulfill();
      }
      QCloudCOSXMLService.defaultCOSXML().getBucketVersioning(getBucketVersioning);
      self.wait(for: [exception], timeout: 100);
    }


    func PutBucketReplication() {
      let exception = XCTestExpectation.init(description: "putBucketReplication exception");
      let putBucketReplication = QCloudPutBucketReplicationRequest.init();
      putBucketReplication.bucket = "examplebucket-1250000000";
      
      let config = QCloudBucketReplicationConfiguation.init();
      config.role = "qcs::cam::uin/100000000001:uin/100000000001";
      
      let rule = QCloudBucketReplicationRule.init();
      rule.identifier = "swift";
      rule.status = .enabled;
      
      let destination = QCloudBucketReplicationDestination.init();
      let destinationBucket = "destinationbucket-1250000000";
      let region = "ap-beijing";
      destination.bucket = "qcs::cos:\(region)::\(destinationBucket)";
      rule.destination = destination;
      rule.prefix = "a";
      
      config.rule = [rule];
      
      putBucketReplication.configuation = config;
      
      putBucketReplication.finishBlock = {(result,error) in
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
      getBucketReplication.bucket = "examplebucket-1250000000";
      getBucketReplication.setFinish { (config, error) in
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
      deleteBucketReplication.bucket = "examplebucket-1250000000";
      deleteBucketReplication.finishBlock = {(result,error) in
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


    func TransferUploadObject() {
      let exception = XCTestExpectation.init(description: "transfer-upload-object exception");
      let uploadRequest = QCloudCOSXMLUploadObjectRequest<AnyObject>.init();
      let dataBody:NSData? = "wrwrwrwrwrw".data(using: .utf8) as NSData?;
      uploadRequest.body = dataBody!;
      uploadRequest.bucket = "examplebucket-1250000000";
      uploadRequest.object = "exampleobject";
      //设置一些上传的参数
      uploadRequest.initMultipleUploadFinishBlock = {(multipleUploadInitResult,resumeData) in
          //在初始化分块上传完成以后会回调该block，在这里可以获取 resumeData，并且可以通过 resumeData 生成一个分块上传的请求
          let resumeUploadRequest = QCloudCOSXMLUploadObjectRequest<AnyObject>.init(request: resumeData as Data?);
      }
      uploadRequest.sendProcessBlock = {(bytesSent , totalBytesSent , totalBytesExpectedToSend) in
          
      }
      uploadRequest.setFinish { (result, error) in
          if error != nil{
              print(error!)
          }else{
              ////从result中获取请求的结果
              print(result!);
          }
          exception.fulfill();
      }
      
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
      let copyRequest =  QCloudCOSXMLCopyObjectRequest.init();
      copyRequest.bucket = "examplebucket-1250000000";//目的<BucketName-APPID>，需要是公有读或者在当前账号有权限
      copyRequest.object = "exampleobject";//目的文件名称
      //文件来源<BucketName-APPID>，需要是公有读或者在当前账号有权限
      copyRequest.sourceBucket = "source-1250000000";
      copyRequest.sourceObject = "sourceObject";//源文件名称
      copyRequest.sourceAPPID = "1250000000";//源文件的appid
      copyRequest.sourceRegion = "ap-guangzhou";//来源的地域
      copyRequest.setFinish { (copyResult, error) in
          if error != nil{
              print(error!);
          }else{
              print(copyResult!);
          }
      }
      //注意如果是跨地域复制，这里使用的 transferManager 所在的 region 必须为目标桶所在的 region
      QCloudCOSTransferMangerService.defaultCOSTransferManager().copyObject(copyRequest);
    }


    func GetBucket() {
      let exception = XCTestExpectation.init(description: "getBucket exception");
      let getBucketReq = QCloudGetBucketRequest.init();
      getBucketReq.bucket = "examplebucket-1250000000";
      getBucketReq.maxKeys = 1000;
      getBucketReq.setFinish { (result, error) in
          if error != nil{
              print(error!);
          }else{
              print( result!.commonPrefixes);
          }
          exception .fulfill();
      }
      QCloudCOSXMLService.defaultCOSXML().getBucket(getBucketReq);
      self.wait(for: [exception], timeout: 100);
    }


    func PutObject() {
      let exception = XCTestExpectation.init(description: "putObject exception");
      let putObject = QCloudPutObjectRequest<AnyObject>.init();
      putObject.bucket = "examplebucket-1250000000";
      let dataBody:NSData? = "wrwrwrwrwrw".data(using: .utf8) as NSData?;
      putObject.body =  dataBody!;
      putObject.object = "exampleobject";
      putObject.finishBlock = {(result,error) in
          if error != nil{
              print(error!);
          }else{
              print(result!);
          }
          exception .fulfill();
      }
      QCloudCOSXMLService.defaultCOSXML().putObject(putObject);
      self.wait(for: [exception], timeout: 100);
    }


    func HeadObject() {
      let exception = XCTestExpectation.init(description: "headObject exception");
      let headObject = QCloudHeadObjectRequest.init();
      headObject.bucket = "examplebucket-1250000000";
      headObject.object  = "exampleobject";
      headObject.finishBlock =  {(result,error) in
          if error != nil{
              print(error!);
          }else{
              print(result!);
          }
          exception .fulfill();
      }
      QCloudCOSXMLService.defaultCOSXML().headObject(headObject);
      self.wait(for: [exception], timeout: 100);
    }


    func GetObject() {
      let exception = XCTestExpectation.init(description: "getObject exception");
      let getObject = QCloudGetObjectRequest.init();
      getObject.bucket = "examplebucket-1250000000";
      getObject.object = "exampleobject";
      getObject.downloadingURL = URL.init(string: NSTemporaryDirectory())!.appendingPathComponent(getObject.object);
      getObject.finishBlock = {(result,error) in
          if error != nil{
              print(error!);
          }else{
              print(result!);
          }
          exception .fulfill();
      };
      getObject.downProcessBlock = {(bytesDownload, totalBytesDownload,  totalBytesExpectedToDownload) in
          print("totalBytesDownload:\(totalBytesDownload) totalBytesExpectedToDownload:\(totalBytesExpectedToDownload)");
      }
      QCloudCOSXMLService.defaultCOSXML().getObject(getObject);
      self.wait(for: [exception], timeout: 100);
    }


    func OptionObject() {
      let exception = XCTestExpectation.init(description: "optionsObject exception");
      let optionsObject = QCloudOptionsObjectRequest.init();
      optionsObject.object = "exampleobject";
      optionsObject.origin = "http://www.qcloud.com";
      optionsObject.accessControlRequestMethod = "GET";
      optionsObject.accessControlRequestHeaders = "origin";
      optionsObject.bucket = "examplebucket-1250000000";
      optionsObject.finishBlock = {(result,error) in
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


    func CopyObject() {
      let exception = XCTestExpectation.init(description: "getBucket exception");
      let putObjectCopy = QCloudPutObjectCopyRequest.init();
      putObjectCopy.bucket = "examplebucket-1250000000";
      putObjectCopy.object = "exampleobject";
      putObjectCopy.objectCopySource = "source-1250000000.cos.ap-guangzhou.myqcloud.com/sourceObject";
      putObjectCopy.setFinish { (result, error) in
          if error != nil{
              print(error!);
          }else{
              print(result!);
          }
          exception .fulfill();
      }
      QCloudCOSXMLService.defaultCOSXML().putObjectCopy(putObjectCopy);
      self.wait(for: [exception], timeout: 100);
    }


    func DeleteObject() {
      let exception = XCTestExpectation.init(description: "deleteObject exception");
      let deleteObject = QCloudDeleteObjectRequest.init();
      deleteObject.bucket = "examplebucket-1250000000";
      deleteObject.object = "exampleobject";
      deleteObject.finishBlock = {(result,error)in
          if error != nil{
              print(error!);
          }else{
              print(result!);
          }
          exception .fulfill();
      }
      QCloudCOSXMLService.defaultCOSXML().deleteObject(deleteObject);
      self.wait(for: [exception], timeout: 100);
    }


    func DeleteMultiObject() {
      let exception = XCTestExpectation.init(description: "mutipleDel exception");
      let mutipleDel = QCloudDeleteMultipleObjectRequest.init();
      mutipleDel.bucket = "examplebucket-1250000000";
      
      let info1 = QCloudDeleteObjectInfo.init();
      info1.key = "exampleobject";
      let info2 = QCloudDeleteObjectInfo.init();
      
      
      let deleteInfos = QCloudDeleteInfo.init();
      deleteInfos.objects = [info1];
      deleteInfos.quiet = false;
      mutipleDel.deleteObjects = deleteInfos;
      
      mutipleDel.setFinish { (result, error) in
          if error != nil{
              print(error!);
          }else{
              print(result!);
          }
          exception .fulfill();
      }
      QCloudCOSXMLService.defaultCOSXML().deleteMultipleObject(mutipleDel);
      self.wait(for: [exception], timeout: 100);
    }


    func ListMultiUpload() {
      let exception = XCTestExpectation.init(description: "listParts exception");
      let listParts = QCloudListBucketMultipartUploadsRequest.init();
      listParts.bucket = "examplebucket-1250000000";
      listParts.maxUploads = 100;
      listParts.setFinish { (result, error) in
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


    func InitMultiUpload() {
      let exception = XCTestExpectation.init(description: "initRequest exception");
      let initRequest = QCloudInitiateMultipartUploadRequest.init();
      initRequest.bucket = "examplebucket-1250000000";
      initRequest.object = "exampleobject";
      initRequest.setFinish { (result, error) in
          if error != nil{
              print(error!);
          }else{
              //获取分片上传的 uploadId，后续的上传都需要这个 id，请保存起来后续使用
              self.uploadId = result!.uploadId;
              print(result!.uploadId);
          }
          exception .fulfill();
      }
      QCloudCOSXMLService.defaultCOSXML().initiateMultipartUpload(initRequest);
      self.wait(for: [exception], timeout: 100);
    }


    func UploadPart() {
      let exception = XCTestExpectation.init(description: "uploadPart exception");
      
      let uploadPart = QCloudUploadPartRequest<AnyObject>.init();
      uploadPart.bucket = "examplebucket-1250000000";
      uploadPart.object = "exampleobject";
      uploadPart.partNumber = 1;
      //标识本次分块上传的 ID；使用 Initiate Multipart Upload 接口初始化分块上传时会得到一个 uploadId
      // 该 ID 不但唯一标识这一分块数据，也标识了这分块数据在整个文件内的相对位置
      uploadPart.uploadId = "example-uploadId";
      if self.uploadId != nil {
           uploadPart.uploadId = self.uploadId!;
      }
      
      let dataBody:NSData? = "wrwrwrwrwrwwrwrwrwrwrwwrwrwrwrwrwwrwrwrwrwrwwrwrwrwrwrwwrwrwrwrwrwwrwrwrwrwrwwrwrwrwrwrwwrwrwrwrwrwwrwrwrwrwrwwrwrwrwrwrwwrwrwrwrwrwwrwrwrwrwrw".data(using: .utf8) as NSData?;
      uploadPart.body = dataBody!;
      uploadPart.setFinish { (result, error) in
          if error != nil{
              print(error!);
          }else{
              let mutipartInfo = QCloudMultipartInfo.init();
              //获取所上传分片的 etag
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


    func UploadPartCopy() {
      let exception = XCTestExpectation.init(description: "uploadPartCopy exception");
      let req = QCloudUploadPartCopyRequest.init();
      req.bucket = "examplebucket-1250000000";
      req.object = "exampleobject";
      //  源文件 URL 路径，可以通过 versionid 子资源指定历史版本
      req.source = "source-1250000000.cos.ap-guangzhou.myqcloud.com/sourceObject";
      // 在初始化分块上传的响应中，会返回一个唯一的描述符（upload ID）
      req.uploadID = "example-uploadId";
      if self.uploadId != nil {
          req.uploadID = self.uploadId!;
      }
      
      //// 标志当前分块的序号
      req.partNumber = 1;
      req.setFinish { (result, error) in
          if error != nil{
              print(error!);
          }else{
              let mutipartInfo = QCloudMultipartInfo.init();
              //获取所复制分片的 etag
              mutipartInfo.eTag = result!.eTag;
              mutipartInfo.partNumber = "1";
          }
            exception .fulfill();
      }
      QCloudCOSXMLService.defaultCOSXML().uploadPartCopy(req);
      self.wait(for: [exception], timeout: 100);
    }


    func ListParts() {
      let exception = XCTestExpectation.init(description: "listParts exception");
      let req = QCloudListMultipartRequest.init();
      req.object = "exampleobject";
      req.bucket = "examplebucket-1250000000";
      // 在初始化分块上传的响应中，会返回一个唯一的描述符（upload ID
      req.uploadId = "example-uploadId";
      if self.uploadId != nil {
          req.uploadId = self.uploadId!;
      }
      req.setFinish { (result, error) in
          if error != nil{
              print(error!);
          }else{
              //从 result 中获取已上传分片信息
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
      complete.bucket = "examplebucket-1250000000";
      complete.object = "exampleobject";
      ////本次要查询的分块上传的uploadId,可从初始化分块上传的请求结果QCloudInitiateMultipartUploadResult中得到
      complete.uploadId = "example-uploadId";
      if self.uploadId != nil {
          complete.uploadId = self.uploadId!;
      }
      
      
      // 已上传分片的信息
      let completeInfo = QCloudCompleteMultipartUploadInfo.init();
      if self.parts == nil {
          print("没有要完成的分片");
          return;
      }
      
       completeInfo.parts = self.parts!;
      complete.parts = completeInfo;
      complete.setFinish { (result, error) in
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
      abort.bucket = "examplebucket-1250000000";
      abort.object = "exampleobject";
      //本次要查询的分块上传的uploadId,可从初始化分块上传的请求结果QCloudInitiateMultipartUploadResult中得到
      abort.uploadId = "example-uploadId";
      if self.uploadId != nil {
          abort.uploadId = self.uploadId!;
      }
      
      abort.finishBlock = {(result,error)in
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


    func RestoreObject() {
      let exception = XCTestExpectation.init(description: "restore exception");
      let restore = QCloudPostObjectRestoreRequest.init();
      restore.bucket = "examplebucket-1250000000";
      restore.object = "object4swift";
      restore.restoreRequest.days = 10;
      restore.restoreRequest.casJobParameters.tier = .standard;
      restore.finishBlock = {(result,error)in
          if error != nil{
              print(error!)
          }else{
              //可以从 outputObject 中获取 response 中 etag 或者自定义头部等信息
              print(result!);
          }
          exception .fulfill();
      }
      QCloudCOSXMLService.defaultCOSXML().postObjectRestore(restore);
      
      self.wait(for: [exception], timeout: 100);
    }


    func PutObjectAcl() {
      let exception = XCTestExpectation.init(description: "putObjectACl exception");
      let putObjectACl = QCloudPutObjectACLRequest.init();
      putObjectACl.bucket = "examplebucket-1250000000";
      putObjectACl.object = "exampleobject";
      let grantString = "id=\"1250000000\"";
      putObjectACl.grantFullControl = grantString;
      putObjectACl.finishBlock = {(result,error)in
          if error != nil{
              print(error!)
          }else{
              //可以从 outputObject 中获取 response 中 etag 或者自定义头部等信息
              print(result!);
          }
          exception .fulfill();
      }
      QCloudCOSXMLService.defaultCOSXML().putObjectACL(putObjectACl);
      self.wait(for: [exception], timeout: 100);
    }


    func GetObjectAcl() {
      let exception = XCTestExpectation.init(description: "getObjectACL exception");
      let getObjectACL = QCloudGetObjectACLRequest.init();
      getObjectACL.bucket = "examplebucket-1250000000";
      getObjectACL.object = "exampleobject";
      getObjectACL.setFinish { (result, error) in
          if error != nil{
              print(error!)
          }else{
              //可以从 result的accessControlList中获取对象的 acl
              print(result!.accessControlList);
          }
          exception .fulfill();
      }
      QCloudCOSXMLService.defaultCOSXML().getObjectACL(getObjectACL);
      self.wait(for: [exception], timeout: 100);
    }


    func GetPresignDownloadUrl() {
      let exception = XCTestExpectation.init(description: "putObjectACl exception");
      let getPresign  = QCloudGetPresignedURLRequest.init();
      getPresign.bucket = "examplebucket-1250000000" ;
      getPresign.httpMethod = "GET";
      getPresign.object = "exampleobject";
      getPresign.setFinish { (result, error) in
          if error == nil{
              print(result?.presienedURL as Any);
          }
          exception .fulfill();
      }
      QCloudCOSXMLService.defaultCOSXML().getPresignedURL(getPresign);
      self.wait(for: [exception], timeout: 100);
    }


    override func setUp() {
      let config = QCloudServiceConfiguration.init();
      config.signatureProvider = self;
      config.appID = "";
      let endpoint = QCloudCOSXMLEndPoint.init();
      endpoint.regionName = "";
      endpoint.useHTTPS = true;
      config.endpoint = endpoint;
      QCloudCOSXMLService.registerDefaultCOSXML(with: config);
      QCloudCOSTransferMangerService.registerDefaultCOSTransferManger(with: config);

    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testSnippetEverything() {
    }
}
