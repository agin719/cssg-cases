#import <XCTest/XCTest.h>
#import <QCloudCOSXML/QCloudCOSXML.h>
#import <SecretStorage.h>
#import <QCloudCOSXML/QCloudUploadPartRequest.h>
#import <QCloudCOSXML/QCloudCompleteMultipartUploadRequest.h>
#import <QCloudCOSXML/QCloudAbortMultipfartUploadRequest.h>
#import <QCloudCOSXML/QCloudMultipartInfo.h>
#import <QCloudCOSXML/QCloudCompleteMultipartUploadInfo.h>

@interface BucketVersioningTest : XCTestCase <QCloudSignatureProvider>

@property (nonatomic) NSString* uploadId;
@property (nonatomic) NSMutableArray<QCloudMultipartInfo *> *parts;

@end

@implementation BucketVersioningTest

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
    
    // 构建请求
    XCTestExpectation* exp = [self expectationWithDescription:@"put-bucket"];
    QCloudPutBucketRequest* request = [QCloudPutBucketRequest new];
    request.bucket = @"bucket-cssg-ios-temp-1253653367"; //additional actions after finishing
    [request setFinishBlock:^(id outputObject, NSError* error) {
        //可以从 outputObject 中获取服务器返回的 header 信息
        XCTAssertNil(error);
        [exp fulfill];
    }];
    [[QCloudCOSXMLService defaultCOSXML] PutBucket:request];
    [self waitForExpectationsWithTimeout:80 handler:nil];
}

- (void)tearDown {
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
    XCTestExpectation* exp = [self expectationWithDescription:@"delete-bucket"];
    QCloudDeleteBucketRequest* request = [[QCloudDeleteBucketRequest alloc ] init];
    request.bucket = @"bucket-cssg-ios-temp-1253653367";  //存储桶名称，命名格式：BucketName-APPID
    [request setFinishBlock:^(id outputObject,NSError*error) {
        //可以从 outputObject 中获取服务器返回的header信息
        XCTAssertNil(error);
        [exp fulfill];
    }];
    [[QCloudCOSXMLService defaultCOSXML] DeleteBucket:request];
    [self waitForExpectationsWithTimeout:80 handler:nil];
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

- (void)PutBucketVersioning {
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
    XCTestExpectation* exp = [self expectationWithDescription:@"put-bucket-versioning"];
    // 开启版本控制
    QCloudPutBucketVersioningRequest* request = [[QCloudPutBucketVersioningRequest alloc] init];
    request.bucket =@"bucket-cssg-ios-temp-1253653367";
    QCloudBucketVersioningConfiguration* versioningConfiguration = 
        [[QCloudBucketVersioningConfiguration alloc] init];
    request.configuration = versioningConfiguration;
    versioningConfiguration.status = QCloudCOSBucketVersioningStatusEnabled;
    
    [request setFinishBlock:^(id outputObject, NSError* error) {
        //可以从 outputObject 中获取服务器返回的header信息
        XCTAssertNil(error);
        [exp fulfill];
    }];
    [[QCloudCOSXMLService defaultCOSXML] PutBucketVersioning:request];
    [self waitForExpectationsWithTimeout:80 handler:nil];
}

- (void)GetBucketVersioning {
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
    XCTestExpectation* exp = [self expectationWithDescription:@"get-bucket-versioning"];
    QCloudGetBucketVersioningRequest* request = [[QCloudGetBucketVersioningRequest alloc] init];
    request.bucket = @"bucket-cssg-ios-temp-1253653367";
    [request setFinishBlock:^(QCloudBucketVersioningConfiguration* result, NSError* error) {
        //可以从 result 中获取返回信息
        XCTAssertNil(error);
        [exp fulfill];
    }];
    
    [[QCloudCOSXMLService defaultCOSXML] GetBucketVersioning:request];
    [self waitForExpectationsWithTimeout:80 handler:nil];
}


- (void)testBucketVersioning {
    [self PutBucketVersioning];
    [self GetBucketVersioning];
}

@end