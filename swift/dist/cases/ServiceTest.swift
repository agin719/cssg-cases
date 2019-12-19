


import XCTest
import QCloudCOSXML

class ServiceTest: XCTestCase,QCloudSignatureProvider{


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


    func getService() {
      let exception = XCTestExpectation.init(description: "getService");
      //.cssg-snippet-body-start:[get-service]
      let getServiceReq = QCloudGetServiceRequest.init();
      getServiceReq.setFinish{(result,error) in
          XCTAssertNil(error);
          exception.fulfill();
          if result == nil {
              print(error!);
          } else {
              //从 result 中获取返回信息
              print(result!);
          }}
      QCloudCOSXMLService.defaultCOSXML().getService(getServiceReq);
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

    }

    override func tearDown() {
    }

    func testtestGetService() {
      self.getService();
    }
}
