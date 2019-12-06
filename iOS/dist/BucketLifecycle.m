#import <XCTest/XCTest.h>
#import <QCloudCOSXML/QCloudCOSXML.h>
#import <SecretStorage.h>
#import <QCloudCOSXML/QCloudUploadPartRequest.h>
#import <QCloudCOSXML/QCloudCompleteMultipartUploadRequest.h>
#import <QCloudCOSXML/QCloudAbortMultipfartUploadRequest.h>
#import <QCloudCOSXML/QCloudMultipartInfo.h>
#import <QCloudCOSXML/QCloudCompleteMultipartUploadInfo.h>

@interface BucketLifecycleTest : XCTestCase <QCloudSignatureProvider>
@property (nonatomic) NSString* uploadId;
@property (nonatomic) NSMutableArray<QCloudMultipartInfo *> *parts;
@end

@implementation BucketLifecycleTest

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

- (void)PutBucket {
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

- (void)PutBucketLifecycle {
    XCTestExpectation* exp = [self expectationWithDescription:@"put-bucket-lifecycle"];
    QCloudPutBucketLifecycleRequest* request = [QCloudPutBucketLifecycleRequest new];
    request.bucket = @"bucket-cssg-ios-temp-1253653367";
    __block QCloudLifecycleConfiguration* lifecycleConfiguration = [[QCloudLifecycleConfiguration
        alloc] init];
    QCloudLifecycleRule* rule = [[QCloudLifecycleRule alloc] init];
    rule.identifier = @"identifier";
    rule.status = QCloudLifecycleStatueEnabled;
    QCloudLifecycleRuleFilter* filter = [[QCloudLifecycleRuleFilter alloc] init];
    filter.prefix = @"0";
    rule.filter = filter;
    
    QCloudLifecycleTransition* transition = [[QCloudLifecycleTransition alloc] init];
    transition.days = 100;
    transition.storageClass = QCloudCOSStorageStandardIA;
    rule.transition = transition;
    request.lifeCycle = lifecycleConfiguration;
    request.lifeCycle.rules = @[rule];
    [request setFinishBlock:^(id outputObject, NSError* error) {
        //可以从 outputObject 中获取服务器返回的 header 信息
        XCTAssertNil(error);
        [exp fulfill];
    }];
    
    [[QCloudCOSXMLService defaultCOSXML] PutBucketLifecycle:request];
    [self waitForExpectationsWithTimeout:80 handler:nil];
}

- (void)GetBucketLifecycle {
    XCTestExpectation* exp = [self expectationWithDescription:@"get-bucket-lifecycle"];
    QCloudGetBucketLifecycleRequest* request = [QCloudGetBucketLifecycleRequest new];
    request.bucket = @"bucket-cssg-ios-temp-1253653367";
    [request setFinishBlock:^(QCloudLifecycleConfiguration* result,NSError* error) {
        // 可以从 result 中获取返回信息
        XCTAssertNil(error);
        [exp fulfill];
    }];
    [[QCloudCOSXMLService defaultCOSXML] GetBucketLifecycle:request];
    [self waitForExpectationsWithTimeout:80 handler:nil];
}

- (void)DeleteBucketLifecycle {
    XCTestExpectation* exp = [self expectationWithDescription:@"delete-bucket-lifecycle"];
    QCloudDeleteBucketLifeCycleRequest* request = [[QCloudDeleteBucketLifeCycleRequest alloc ] init];
    request.bucket = @"bucket-cssg-ios-temp-1253653367";
    [request setFinishBlock:^(QCloudLifecycleConfiguration* deleteResult, NSError* deleteError) {
        //deleteResult 返回删除结果
        XCTAssertNil(deleteError);
        [exp fulfill];
    }];
    [[QCloudCOSXMLService defaultCOSXML] DeleteBucketLifeCycle:request];
    [self waitForExpectationsWithTimeout:80 handler:nil];
}

- (void)DeleteBucket {
    XCTestExpectation* exp = [self expectationWithDescription:@"delete-bucket"];
    QCloudDeleteBucketRequest* request = [[QCloudDeleteBucketRequest alloc ] init];
    request.bucket = @"bucket-cssg-ios-temp-1253653367";  //存储桶名称，命名格式：BucketName-APPID
    [request setFinishBlock:^(id outputObject,NSError*error) {
        //可以从 outputObject 中获取服务器返回的 header 信息
        XCTAssertNil(error);
        [exp fulfill];
    }];
    [[QCloudCOSXMLService defaultCOSXML] DeleteBucket:request];
    [self waitForExpectationsWithTimeout:80 handler:nil];
}


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

    [self PutBucket];
}

- (void)tearDown {
    [self DeleteBucket];
}

- (void)testBucketLifecycle {
    [self PutBucketLifecycle];
    [self GetBucketLifecycle];
    [self DeleteBucketLifecycle];
}

@end
