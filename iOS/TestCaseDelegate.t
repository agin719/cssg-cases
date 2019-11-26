#import <XCTest/XCTest.h>
#import <QCloudCOSXML/QCloudCOSXML.h>
#import <SecretStorage.h>
#import <QCloudCOSXML/QCloudUploadPartRequest.h>
#import <QCloudCOSXML/QCloudCompleteMultipartUploadRequest.h>
#import <QCloudCOSXML/QCloudAbortMultipfartUploadRequest.h>

@interface {{name}}Test : XCTestCase <QCloudSignatureProvider>

@property (nonatomic) QCloudCredentailFenceQueue* credentialFenceQueue;

@end

@implementation {{name}}Test

- (void)setUp {
    {{{setupBlock}}}
}

- (void)tearDown {
    {{{teardownBlock}}}
}

{{#steps}}
{{{snippet}}}

{{/steps}}

@end