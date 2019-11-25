#import <XCTest/XCTest.h>
#import <QCloudCOSXML/QCloudCOSXML.h>
#import <SecretStorage.h>

@interface {{name}}Test : XCTestCase <QCloudSignatureProvider>

@end

@implementation {{name}}Test

- (void)setUp {
{{{setupBlock}}}
}

- (void)tearDown {
{{{teardownBlock}}}
}

- (void) signatureWithFields:(QCloudSignatureFields*)fileds
                     request:(QCloudBizHTTPRequest*)request
                  urlRequest:(NSMutableURLRequest*)urlRequst
                   compelete:(QCloudHTTPAuthentationContinueBlock)continueBlock
{
    QCloudCredential* credential = [QCloudCredential new];
    credential.secretID  = {{{secretId}}};
    credential.secretKey = {{{secretKey}}};
    QCloudAuthentationV5Creator* creator = [[QCloudAuthentationV5Creator alloc] initWithCredential:credential];
    QCloudSignature* signature =  [creator signatureForData:urlRequst];
    continueBlock(signature, nil);
}

{{#steps}}
- (void){{name}} {
{{{snippet}}}
}
{{/steps}}

- (void)test{{name}} {
{{#steps}}
[self {{name}}];
{{/steps}}
}

@end