


import XCTest
import QCloudCOSXML

{{#isDefine}}
{{#methods}}
class {{name}}Test : NSObject,QCloudSignatureProvider {
    var credentialFenceQueue:QCloudCredentailFenceQueue?;

      {{{snippet}}}

    {{#appInit}}
    func signature(with fileds: QCloudSignatureFields!, 
    request: QCloudBizHTTPRequest!, 
    urlRequest urlRequst: NSMutableURLRequest!, 
    compelete continueBlock: QCloudHTTPAuthentationContinueBlock!) {    
    }
    {{/appInit}}
}
{{/methods}}
{{/isDefine}}
{{^isDefine}}
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
      let exception = XCTestExpectation.init(description: "{{name}}");
      {{{snippet}}}
      self.wait(for: [exception], timeout: 100);
    }

    {{/methods}}

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

      {{#setup}}
      self.{{name}}();
      {{/setup}}
    }

    override func tearDown() {
      {{#teardown}}
      self.{{name}}();
      {{/teardown}}
    }

    {{#cases}}
    func test{{name}}() {
      {{#steps}}
      self.{{name}}();
      {{/steps}}
    }
    {{/cases}}
}
{{/isDefine}}
