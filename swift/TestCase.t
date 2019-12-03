


import XCTest
import QCloudCOSXML


class {{name}}Test: XCTestCase,QCloudSignatureProvider{


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

    {{#methods}}

    func {{name}}() {
      {{{snippet}}}
    }

    {{/methods}}

    override func setUp() {
      let config = QCloudServiceConfiguration.init();
      config.signatureProvider = self;
      config.appID = "{{appId}}";
      let endpoint = QCloudCOSXMLEndPoint.init();
      endpoint.regionName = "{{region}}";
      endpoint.useHTTPS = true;
      config.endpoint = endpoint;
      QCloudCOSXMLService.registerDefaultCOSXML(with: config);
      QCloudCOSTransferMangerService.registerDefaultCOSTransferManger(with: config);

          {{#setup}}
          self.{{name}}();
          {{/setup}}
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        {{#teardown}}
        self.{{name}}();
        {{/teardown}}
    }

    func test{{name}}() {
      {{#steps}}
      self.{{name}}();
      {{/steps}}
    }
}
