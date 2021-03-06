#import <XCTest/XCTest.h>
#import <QCloudCOSXML/QCloudCOSXML.h>
#import <SecretStorage.h>
#import <QCloudCOSXML/QCloudUploadPartRequest.h>
#import <QCloudCOSXML/QCloudCompleteMultipartUploadRequest.h>
#import <QCloudCOSXML/QCloudAbortMultipfartUploadRequest.h>
#import <QCloudCOSXML/QCloudMultipartInfo.h>
#import <QCloudCOSXML/QCloudCompleteMultipartUploadInfo.h>

{{#isDefine}}
{{#methods}}
@interface {{name}}Test : NSObject
@property (nonatomic) QCloudCredentailFenceQueue* credentialFenceQueue;
@end

@implementation {{name}}Test

    {{{snippet}}}

@end

{{/methods}}
{{/isDefine}}
{{^isDefine}}
@interface {{name}}Test : XCTestCase <QCloudSignatureProvider>
@property (nonatomic) NSString* uploadId;
@property (nonatomic) NSMutableArray<QCloudMultipartInfo *> *parts;
@end

@implementation {{name}}Test

- (void) signatureWithFields:(QCloudSignatureFields*)fileds
                     request:(QCloudBizHTTPRequest*)request
                  urlRequest:(NSMutableURLRequest*)urlRequst
                   compelete:(QCloudHTTPAuthentationContinueBlock)continueBlock
{
    QCloudCredential* credential = [QCloudCredential new];
    credential.secretID  = [SecretStorage sharedInstance].secretID;
    credential.secretKey = [SecretStorage sharedInstance].secretKey;
    QCloudAuthentationV5Creator* creator = [[QCloudAuthentationV5Creator alloc] initWithCredential:credential];
    QCloudSignature* signature =  [creator signatureForData:urlRequst];
    continueBlock(signature, nil);
}

{{#methods}}
- (void){{name}} {
    XCTestExpectation* exp = [self expectationWithDescription:@"{{name}}"];
    {{{snippet}}}
    [self waitForExpectationsWithTimeout:80 handler:nil];
}

{{/methods}}

- (void)setUp {
    QCloudServiceConfiguration* configuration = [QCloudServiceConfiguration new];
    configuration.appID = @"1253653367";
    // 签名提供者，这里假设由当前实例提供
    configuration.signatureProvider = self;
    QCloudCOSXMLEndPoint* endpoint = [[QCloudCOSXMLEndPoint alloc] init];
    endpoint.regionName = @"ap-guangzhou";
    endpoint.useHTTPS = YES;
    configuration.endpoint = endpoint;

    [QCloudCOSXMLService registerDefaultCOSXMLWithConfiguration:configuration];
    [QCloudCOSTransferMangerService registerDefaultCOSTransferMangerWithConfiguration:configuration];

    {{#setup}}
    [self {{name}}];
    {{/setup}}
}

- (void)tearDown {
    {{#teardown}}
    [self {{name}}];
    {{/teardown}}
}

{{#cases}}
- (void){{name}} {
    {{#steps}}
    [self {{name}}];
    {{/steps}}
}
{{/cases}}

@end
{{/isDefine}}