#import <XCTest/XCTest.h>
#import <QCloudCOSXML/QCloudCOSXML.h>
#import <SecretStorage.h>
#import <QCloudCOSXML/QCloudUploadPartRequest.h>
#import <QCloudCOSXML/QCloudCompleteMultipartUploadRequest.h>
#import <QCloudCOSXML/QCloudAbortMultipfartUploadRequest.h>
#import <QCloudCOSXML/QCloudMultipartInfo.h>
#import <QCloudCOSXML/QCloudCompleteMultipartUploadInfo.h>

@interface TransferCopyObjectTest : XCTestCase <QCloudSignatureProvider>

@property (nonatomic) NSString* uploadId;
@property (nonatomic) NSMutableArray<QCloudMultipartInfo *> *parts;

@end

@implementation TransferCopyObjectTest

- (void)setUp {
    
}

- (void)tearDown {
    
}

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

- (void)TransferCopyObject {
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
    
    // 构建请求
    XCTestExpectation* exp = [self expectationWithDescription:@"transfer-copy-object"];
    QCloudCOSXMLCopyObjectRequest* request = [[QCloudCOSXMLCopyObjectRequest alloc] init];
    
    request.bucket = @"bucket-cssg-test-1253653367";//目的<BucketName-APPID>，需要是公有读或者在当前账号有权限
    request.object = @"object4iOS";//目的文件名称
    //文件来源<BucketName-APPID>，需要是公有读或者在当前账号有权限
    request.sourceBucket = @"bucket-cssg-test-1253653367";
    request.sourceObject = @"sourceObject";//源文件名称
    request.sourceAPPID = @"1253653367";//源文件的appid
    request.sourceRegion= @"ap-guangzhou";//来源的地域
    
    [request setFinishBlock:^(QCloudCopyObjectResult* result, NSError* error) {
        //可以从 outputObject 中获取 response 中 etag 或者自定义头部等信息
        XCTAssertNil(error);
        [exp fulfill];
    }];
    
    //注意如果是跨地域复制，这里使用的 transferManager 所在的 region 必须为目标桶所在的 region
    [[QCloudCOSTransferMangerService defaultCOSTransferManager] CopyObject:request];
    [self waitForExpectationsWithTimeout:80 handler:nil];
}


- (void)testTransferCopyObject {
    [self TransferCopyObject];
}

@end