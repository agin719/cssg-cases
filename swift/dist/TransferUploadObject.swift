


import XCTest
import QCloudCOSXML


class TransferUploadObjectTest: XCTestCase,QCloudSignatureProvider{


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


    func TransferUploadObject() {
      let exception = XCTestExpectation.init(description: "transfer-upload-object exception");
      let uploadRequest = QCloudCOSXMLUploadObjectRequest<AnyObject>.init();
      let dataBody:NSData? = "wrwrwrwrwrw".data(using: .utf8) as NSData?;
      uploadRequest.body = dataBody!;
      uploadRequest.bucket = "bucket-cssg-test-1253653367";
      uploadRequest.object = "object4swift";
      //设置一些上传的参数
      uploadRequest.initMultipleUploadFinishBlock = {(multipleUploadInitResult,resumeData) in
          //在初始化分块上传完成以后会回调该block，在这里可以获取 resumeData，并且可以通过 resumeData 生成一个分块上传的请求
          let resumeUploadRequest = QCloudCOSXMLUploadObjectRequest<AnyObject>.init(request: resumeData as Data?);
      }
      uploadRequest.sendProcessBlock = {(bytesSent , totalBytesSent , totalBytesExpectedToSend) in
          
      }
      uploadRequest.setFinish { (result, error) in
          XCTAssertNotNil(error);
          XCTAssertNil(result);
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

    func testTransferUploadObject() {
      self.TransferUploadObject();
    }
}
