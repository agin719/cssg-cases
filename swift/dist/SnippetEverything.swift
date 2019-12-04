


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
      let getServiceReq = QCloudGetServiceRequest.init();
      getServiceReq.setFinish{(result,error) in
          if result == nil {
              print(error!);
          } else {
              //从result中获取返回信息
              print(result!);
          }}
      QCloudCOSXMLService.defaultCOSXML().getService(getServiceReq);
    }


    func PutBucket() {
      let putBucketReq = QCloudPutBucketRequest.init();
      putBucketReq.bucket = "examplebucket-1250000000";
      putBucketReq.finishBlock = {(result,error) in
          if error != nil {
              print(error!);
          } else {
              print(result!);
          }}
      QCloudCOSXMLService.defaultCOSXML().putBucket(putBucketReq);
    }


    func HeadBucket() {
      let headBucketReq = QCloudHeadBucketRequest.init();
      headBucketReq.bucket = "examplebucket-1250000000";
      headBucketReq.finishBlock = {(result,error) in
          if error != nil{
              print(error!);
          }else{
              print( result!);
          }}
      QCloudCOSXMLService.defaultCOSXML().headBucket(headBucketReq);
    }


    func DeleteBucket() {
      let deleteBucketReq = QCloudDeleteBucketRequest.init();
      deleteBucketReq.bucket = "examplebucket-1250000000";
      deleteBucketReq.finishBlock = {(result,error) in
          if error != nil{
              print(error!);
          }else{
              print(result!);
          }}
      QCloudCOSXMLService.defaultCOSXML().deleteBucket(deleteBucketReq);
    }


    func PutBucketAcl() {
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
          }}
      QCloudCOSXMLService.defaultCOSXML().putBucketACL(putBucketACLReq);
    }


    func GetBucketAcl() {
      let getBucketACLReq = QCloudGetBucketACLRequest.init();
      getBucketACLReq.bucket = "examplebucket-1250000000";
      getBucketACLReq.setFinish { (result, error) in
          if error != nil{
              print(error!);
          }else{
              print(result!);
          }}
      QCloudCOSXMLService.defaultCOSXML().getBucketACL(getBucketACLReq)
    }


    func PutBucketCors() {
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
          }}
      
      QCloudCOSXMLService.defaultCOSXML().putBucketCORS(putBucketCorsReq);
    }


    func GetBucketCors() {
      let  getBucketCorsRes = QCloudGetBucketCORSRequest.init();
      getBucketCorsRes.bucket = "examplebucket-1250000000";
      getBucketCorsRes.setFinish { (corsConfig, error) in
          if error != nil{
              print(error!);
          }else{
              print(corsConfig!);
          }}
      QCloudCOSXMLService.defaultCOSXML().getBucketCORS(getBucketCorsRes);
    }


    func DeleteBucketCors() {
      let deleteBucketCorsRequest = QCloudDeleteBucketCORSRequest.init();
      deleteBucketCorsRequest.bucket = "examplebucket-1250000000";
      deleteBucketCorsRequest.finishBlock = {(result,error) in
          if error != nil{
              print(error!);
          }else{
              print(result!);
          }}
      QCloudCOSXMLService.defaultCOSXML().deleteBucketCORS(deleteBucketCorsRequest);
    }


    func PutBucketLifecycle() {
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
          }}
      QCloudCOSXMLService.defaultCOSXML().putBucketLifecycle(putBucketLifecycleReq);
    }


    func GetBucketLifecycle() {
      let getBucketLifeCycle = QCloudGetBucketLifecycleRequest.init();
      getBucketLifeCycle.bucket = "examplebucket-1250000000";
      getBucketLifeCycle.setFinish { (config, error) in
          if error != nil{
              print(error!);
          }else{
              print(config!);
          }};
      QCloudCOSXMLService.defaultCOSXML().getBucketLifecycle(getBucketLifeCycle);
    }


    func DeleteBucketLifecycle() {
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
    }


    func PutBucketVersioning() {
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
    }


    func GetBucketVersioning() {
      let getBucketVersioning = QCloudGetBucketVersioningRequest.init();
      getBucketVersioning.bucket = "examplebucket-1250000000";
      getBucketVersioning.setFinish { (config, error) in
          if error != nil{
              print(error!);
          }else{
              print(config!);
          }}
      QCloudCOSXMLService.defaultCOSXML().getBucketVersioning(getBucketVersioning);
    }


    func PutBucketReplication() {
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
    }


    func GetBucketReplication() {
      let getBucketReplication = QCloudGetBucketReplicationRequest.init();
      getBucketReplication.bucket = "examplebucket-1250000000";
      getBucketReplication.setFinish { (config, error) in
          if error != nil{
              print(error!);
          }else{
              print(config!);
          }}
      QCloudCOSXMLService.defaultCOSXML().getBucketReplication(getBucketReplication);
    }


    func DeleteBucketReplication() {
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
    }


    func TransferUploadObject() {
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
      let getBucketReq = QCloudGetBucketRequest.init();
      getBucketReq.bucket = "examplebucket-1250000000";
      getBucketReq.maxKeys = 1000;
      getBucketReq.setFinish { (result, error) in
          if error != nil{
              print(error!);
          }else{
              print( result!.commonPrefixes);
          }}
      QCloudCOSXMLService.defaultCOSXML().getBucket(getBucketReq);
    }


    func PutObject() {
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
          }}
      QCloudCOSXMLService.defaultCOSXML().putObject(putObject);
    }


    func HeadObject() {
      let headObject = QCloudHeadObjectRequest.init();
      headObject.bucket = "examplebucket-1250000000";
      headObject.object  = "exampleobject";
      headObject.finishBlock =  {(result,error) in
          if error != nil{
              print(error!);
          }else{
              print(result!);
          }}
      QCloudCOSXMLService.defaultCOSXML().headObject(headObject);
    }


    func GetObject() {
      let getObject = QCloudGetObjectRequest.init();
      getObject.bucket = "examplebucket-1250000000";
      getObject.object = "exampleobject";
      getObject.downloadingURL = URL.init(string: NSTemporaryDirectory())!.appendingPathComponent(getObject.object);
      getObject.finishBlock = {(result,error) in
          if error != nil{
              print(error!);
          }else{
              print(result!);
          }};
      getObject.downProcessBlock = {(bytesDownload, totalBytesDownload,  totalBytesExpectedToDownload) in
          print("totalBytesDownload:\(totalBytesDownload) totalBytesExpectedToDownload:\(totalBytesExpectedToDownload)");
      }
      QCloudCOSXMLService.defaultCOSXML().getObject(getObject);
    }


    func OptionObject() {
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
          }}
      QCloudCOSXMLService.defaultCOSXML().optionsObject(optionsObject);
    }


    func CopyObject() {
      let putObjectCopy = QCloudPutObjectCopyRequest.init();
      putObjectCopy.bucket = "examplebucket-1250000000";
      putObjectCopy.object = "exampleobject";
      putObjectCopy.objectCopySource = "source-1250000000.cos.ap-guangzhou.myqcloud.com/sourceObject";
      putObjectCopy.setFinish { (result, error) in
          if error != nil{
              print(error!);
          }else{
              print(result!);
          }}
      QCloudCOSXMLService.defaultCOSXML().putObjectCopy(putObjectCopy);
    }


    func DeleteObject() {
      let deleteObject = QCloudDeleteObjectRequest.init();
      deleteObject.bucket = "examplebucket-1250000000";
      deleteObject.object = "exampleobject";
      deleteObject.finishBlock = {(result,error)in
          if error != nil{
              print(error!);
          }else{
              print(result!);
          }}
      QCloudCOSXMLService.defaultCOSXML().deleteObject(deleteObject);
    }


    func DeleteMultiObject() {
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
          }}
      QCloudCOSXMLService.defaultCOSXML().deleteMultipleObject(mutipleDel);
    }


    func ListMultiUpload() {
      let listParts = QCloudListBucketMultipartUploadsRequest.init();
      listParts.bucket = "examplebucket-1250000000";
      listParts.maxUploads = 100;
      listParts.setFinish { (result, error) in
          if error != nil{
              print(error!);
          }else{
              print(result!);
          }}
      QCloudCOSXMLService.defaultCOSXML().listBucketMultipartUploads(listParts);
    }


    func InitMultiUpload() {
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
          }}
      QCloudCOSXMLService.defaultCOSXML().initiateMultipartUpload(initRequest);
    }


    func UploadPart() {
      
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
          }}
      uploadPart.sendProcessBlock = {(bytesSent,totalBytesSent,totalBytesExpectedToSend) in
          //上传进度信息
          print("totalBytesSent:\(totalBytesSent) totalBytesExpectedToSend:\(totalBytesExpectedToSend)");
          
      }
      QCloudCOSXMLService.defaultCOSXML().uploadPart(uploadPart);
    }


    func UploadPartCopy() {
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
          }}
      QCloudCOSXMLService.defaultCOSXML().uploadPartCopy(req);
    }


    func ListParts() {
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
          }}
      
      QCloudCOSXMLService.defaultCOSXML().listMultipart(req);
    }


    func CompleteMultiUpload() {
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
          }}
      QCloudCOSXMLService.defaultCOSXML().completeMultipartUpload(complete);
    }


    func AbortMultiUpload() {
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
      }
      QCloudCOSXMLService.defaultCOSXML().abortMultipfartUpload(abort);
    }


    func RestoreObject() {
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
          }}
      QCloudCOSXMLService.defaultCOSXML().postObjectRestore(restore);
    }


    func PutObjectAcl() {
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
          }}
      QCloudCOSXMLService.defaultCOSXML().putObjectACL(putObjectACl);
    }


    func GetObjectAcl() {
      let getObjectACL = QCloudGetObjectACLRequest.init();
      getObjectACL.bucket = "examplebucket-1250000000";
      getObjectACL.object = "exampleobject";
      getObjectACL.setFinish { (result, error) in
          if error != nil{
              print(error!)
          }else{
              //可以从 result的accessControlList中获取对象的 acl
              print(result!.accessControlList);
          }}
      QCloudCOSXMLService.defaultCOSXML().getObjectACL(getObjectACL);
    }


    func GetPresignDownloadUrl() {
      let getPresign  = QCloudGetPresignedURLRequest.init();
      getPresign.bucket = "examplebucket-1250000000" ;
      getPresign.httpMethod = "GET";
      getPresign.object = "exampleobject";
      getPresign.setFinish { (result, error) in
          if error == nil{
              print(result?.presienedURL as Any);
          }}
      QCloudCOSXMLService.defaultCOSXML().getPresignedURL(getPresign);
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
