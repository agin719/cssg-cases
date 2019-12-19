#import <XCTest/XCTest.h>
#import <QCloudCOSXML/QCloudCOSXML.h>
#import <SecretStorage.h>
#import <QCloudCOSXML/QCloudUploadPartRequest.h>
#import <QCloudCOSXML/QCloudCompleteMultipartUploadRequest.h>
#import <QCloudCOSXML/QCloudAbortMultipfartUploadRequest.h>
#import <QCloudCOSXML/QCloudMultipartInfo.h>
#import <QCloudCOSXML/QCloudCompleteMultipartUploadInfo.h>

@interface BucketTest : XCTestCase <QCloudSignatureProvider>
@property (nonatomic) NSString* uploadId;
@property (nonatomic) NSMutableArray<QCloudMultipartInfo *> *parts;
@end

@implementation BucketTest

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

- (void)putBucket {
    XCTestExpectation* exp = [self expectationWithDescription:@"putBucket"];
    //.cssg-snippet-body-start:[put-bucket]
    QCloudPutBucketRequest* request = [QCloudPutBucketRequest new];
    request.bucket = @"bucket-cssg-test-ios-1253653367"; //additional actions after finishing
    [request setFinishBlock:^(id outputObject, NSError* error) {
        [exp fulfill];
        //可以从 outputObject 中获取服务器返回的 header 信息
    }];
    [[QCloudCOSXMLService defaultCOSXML] PutBucket:request];
    //.cssg-snippet-body-end
    [self waitForExpectationsWithTimeout:80 handler:nil];
}

- (void)deleteBucket {
    XCTestExpectation* exp = [self expectationWithDescription:@"deleteBucket"];
    //.cssg-snippet-body-start:[delete-bucket]
    QCloudDeleteBucketRequest* request = [[QCloudDeleteBucketRequest alloc ] init];
    request.bucket = @"bucket-cssg-test-ios-1253653367";  //存储桶名称，命名格式：BucketName-APPID
    [request setFinishBlock:^(id outputObject,NSError*error) {
        [exp fulfill];
        //可以从 outputObject 中获取服务器返回的 header 信息
    }];
    [[QCloudCOSXMLService defaultCOSXML] DeleteBucket:request];
    //.cssg-snippet-body-end
    [self waitForExpectationsWithTimeout:80 handler:nil];
}

- (void)getBucket {
    XCTestExpectation* exp = [self expectationWithDescription:@"getBucket"];
    //.cssg-snippet-body-start:[get-bucket]
    QCloudGetBucketRequest* request = [QCloudGetBucketRequest new];
    request.bucket = @"bucket-cssg-test-ios-1253653367";
    request.maxKeys = 1000;
    
    [request setFinishBlock:^(QCloudListBucketResult * result, NSError* error) {
        XCTAssertNil(error);
        [exp fulfill];
        // result 返回具体信息
    }];
    
    [[QCloudCOSXMLService defaultCOSXML] GetBucket:request];
    //.cssg-snippet-body-end
    [self waitForExpectationsWithTimeout:80 handler:nil];
}

- (void)headBucket {
    XCTestExpectation* exp = [self expectationWithDescription:@"headBucket"];
    //.cssg-snippet-body-start:[head-bucket]
    QCloudHeadBucketRequest* request = [QCloudHeadBucketRequest new];
    request.bucket = @"bucket-cssg-test-ios-1253653367";
    [request setFinishBlock:^(id outputObject, NSError* error) {
        XCTAssertNil(error);
        [exp fulfill];
        //可以从 outputObject 中获取服务器返回的 header 信息
    }];
    [[QCloudCOSXMLService defaultCOSXML] HeadBucket:request];
    //.cssg-snippet-body-end
    [self waitForExpectationsWithTimeout:80 handler:nil];
}

- (void)putBucketAcl {
    XCTestExpectation* exp = [self expectationWithDescription:@"putBucketAcl"];
    //.cssg-snippet-body-start:[put-bucket-acl]
    QCloudPutBucketACLRequest* putACL = [QCloudPutBucketACLRequest new];
    NSString* appID = @"1131975903";//授予全新的账号 ID
    NSString *ownerIdentifier = [NSString stringWithFormat:@"qcs::cam::uin/%@:uin/%@", appID,
        appID];
    NSString *grantString = [NSString stringWithFormat:@"id=\"%@\"",ownerIdentifier];
    putACL.grantFullControl = grantString;
    putACL.bucket = @"bucket-cssg-test-ios-1253653367";
    [putACL setFinishBlock:^(id outputObject, NSError *error) {
        XCTAssertNil(error);
        [exp fulfill];
        //可以从 outputObject 中获取服务器返回的 header 信息
    }];
    
    [[QCloudCOSXMLService defaultCOSXML] PutBucketACL:putACL];
    //.cssg-snippet-body-end
    [self waitForExpectationsWithTimeout:80 handler:nil];
}

- (void)getBucketAcl {
    XCTestExpectation* exp = [self expectationWithDescription:@"getBucketAcl"];
    //.cssg-snippet-body-start:[get-bucket-acl]
    QCloudGetBucketACLRequest* getBucketACl = [QCloudGetBucketACLRequest new];
    getBucketACl.bucket = @"bucket-cssg-test-ios-1253653367";
    [getBucketACl setFinishBlock:^(QCloudACLPolicy * _Nonnull result, NSError * _Nonnull error) {
        XCTAssertNil(error);
        [exp fulfill];
        //QCloudACLPolicy 中包含了 Bucket 的 ACL 信息
    }];
    
    [[QCloudCOSXMLService defaultCOSXML] GetBucketACL:getBucketACl];
    //.cssg-snippet-body-end
    [self waitForExpectationsWithTimeout:80 handler:nil];
}

- (void)putBucketCors {
    XCTestExpectation* exp = [self expectationWithDescription:@"putBucketCors"];
    //.cssg-snippet-body-start:[put-bucket-cors]
    QCloudPutBucketCORSRequest* putCORS = [QCloudPutBucketCORSRequest new];
    QCloudCORSConfiguration* cors = [QCloudCORSConfiguration new];
    
    QCloudCORSRule* rule = [QCloudCORSRule new];
    rule.identifier = @"sdk";
    rule.allowedHeader = @[@"origin",@"host",@"accept",@"content-type",@"authorization"];
    rule.exposeHeader = @"ETag";
    rule.allowedMethod = @[@"GET",@"PUT",@"POST", @"DELETE", @"HEAD"];
    rule.maxAgeSeconds = 3600;
    rule.allowedOrigin = @"http://cloud.tencent.com";
    cors.rules = @[rule];
    putCORS.corsConfiguration = cors;
    putCORS.bucket = @"bucket-cssg-test-ios-1253653367";
    [putCORS setFinishBlock:^(id outputObject, NSError *error) {
        XCTAssertNil(error);
        [exp fulfill];
        //可以从 outputObject 中获取服务器返回的 header 信息
    }];
    
    [[QCloudCOSXMLService defaultCOSXML] PutBucketCORS:putCORS];
    //.cssg-snippet-body-end
    [self waitForExpectationsWithTimeout:80 handler:nil];
}

- (void)getBucketCors {
    XCTestExpectation* exp = [self expectationWithDescription:@"getBucketCors"];
    //.cssg-snippet-body-start:[get-bucket-cors]
    QCloudGetBucketCORSRequest* corsReqeust = [QCloudGetBucketCORSRequest new];
    corsReqeust.bucket = @"bucket-cssg-test-ios-1253653367";
    
    [corsReqeust setFinishBlock:^(QCloudCORSConfiguration * _Nonnull result, NSError * _Nonnull error) {
        XCTAssertNil(error);
        [exp fulfill];
        //CORS 设置封装在 result 中
    }];
    
    [[QCloudCOSXMLService defaultCOSXML] GetBucketCORS:corsReqeust];
    //.cssg-snippet-body-end
    [self waitForExpectationsWithTimeout:80 handler:nil];
}

- (void)optionObject {
    XCTestExpectation* exp = [self expectationWithDescription:@"optionObject"];
    //.cssg-snippet-body-start:[option-object]
    QCloudOptionsObjectRequest* request = [[QCloudOptionsObjectRequest alloc] init];
    request.bucket =@"bucket-cssg-test-ios-1253653367";
    request.origin = @"http://cloud.tencent.com";
    request.accessControlRequestMethod = @"GET";
    request.accessControlRequestHeaders = @"host";
    request.object = @"object4ios";
    
    [request setFinishBlock:^(id outputObject, NSError* error) {
        XCTAssertNil(error);
        [exp fulfill];
        //可以从 outputObject 中获取 response 中 etag 或者自定义头部等信息
    }];
    
    [[QCloudCOSXMLService defaultCOSXML] OptionsObject:request];
    //.cssg-snippet-body-end
    [self waitForExpectationsWithTimeout:80 handler:nil];
}

- (void)deleteBucketCors {
    XCTestExpectation* exp = [self expectationWithDescription:@"deleteBucketCors"];
    //.cssg-snippet-body-start:[delete-bucket-cors]
    QCloudDeleteBucketCORSRequest* deleteCORS = [QCloudDeleteBucketCORSRequest new];
    deleteCORS.bucket = @"bucket-cssg-test-ios-1253653367";
    [deleteCORS setFinishBlock:^(id outputObject, NSError *error) {
        XCTAssertNil(error);
        [exp fulfill];
        //可以从 outputObject 中获取服务器返回的 header 信息
    }];
    [[QCloudCOSXMLService defaultCOSXML] DeleteBucketCORS:deleteCORS];
    //.cssg-snippet-body-end
    [self waitForExpectationsWithTimeout:80 handler:nil];
}

- (void)putBucketLifecycle {
    XCTestExpectation* exp = [self expectationWithDescription:@"putBucketLifecycle"];
    //.cssg-snippet-body-start:[put-bucket-lifecycle]
    QCloudPutBucketLifecycleRequest* request = [QCloudPutBucketLifecycleRequest new];
    request.bucket = @"bucket-cssg-test-ios-1253653367";
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
        XCTAssertNil(error);
        [exp fulfill];
        //可以从 outputObject 中获取服务器返回的 header 信息
    }];
    
    [[QCloudCOSXMLService defaultCOSXML] PutBucketLifecycle:request];
    //.cssg-snippet-body-end
    [self waitForExpectationsWithTimeout:80 handler:nil];
}

- (void)getBucketLifecycle {
    XCTestExpectation* exp = [self expectationWithDescription:@"getBucketLifecycle"];
    //.cssg-snippet-body-start:[get-bucket-lifecycle]
    QCloudGetBucketLifecycleRequest* request = [QCloudGetBucketLifecycleRequest new];
    request.bucket = @"bucket-cssg-test-ios-1253653367";
    [request setFinishBlock:^(QCloudLifecycleConfiguration* result,NSError* error) {
        XCTAssertNil(error);
        [exp fulfill];
        // 可以从 result 中获取返回信息
    }];
    [[QCloudCOSXMLService defaultCOSXML] GetBucketLifecycle:request];
    //.cssg-snippet-body-end
    [self waitForExpectationsWithTimeout:80 handler:nil];
}

- (void)deleteBucketLifecycle {
    XCTestExpectation* exp = [self expectationWithDescription:@"deleteBucketLifecycle"];
    //.cssg-snippet-body-start:[delete-bucket-lifecycle]
    QCloudDeleteBucketLifeCycleRequest* request = [[QCloudDeleteBucketLifeCycleRequest alloc ] init];
    request.bucket = @"bucket-cssg-test-ios-1253653367";
    [request setFinishBlock:^(QCloudLifecycleConfiguration* deleteResult, NSError* error) {
        XCTAssertNil(error);
        [exp fulfill];
        //error 返回删除结果
    }];
    [[QCloudCOSXMLService defaultCOSXML] DeleteBucketLifeCycle:request];
    //.cssg-snippet-body-end
    [self waitForExpectationsWithTimeout:80 handler:nil];
}

- (void)putBucketVersioning {
    XCTestExpectation* exp = [self expectationWithDescription:@"putBucketVersioning"];
    //.cssg-snippet-body-start:[put-bucket-versioning]
    //开启版本控制
    QCloudPutBucketVersioningRequest* request = [[QCloudPutBucketVersioningRequest alloc] init];
    request.bucket =@"bucket-cssg-test-ios-1253653367";
    QCloudBucketVersioningConfiguration* versioningConfiguration =
        [[QCloudBucketVersioningConfiguration alloc] init];
    request.configuration = versioningConfiguration;
    versioningConfiguration.status = QCloudCOSBucketVersioningStatusEnabled;
    
    [request setFinishBlock:^(id outputObject, NSError* error) {
        XCTAssertNil(error);
        [exp fulfill];
        //可以从 outputObject 中获取服务器返回的 header 信息
    }];
    [[QCloudCOSXMLService defaultCOSXML] PutBucketVersioning:request];
    //.cssg-snippet-body-end
    [self waitForExpectationsWithTimeout:80 handler:nil];
}

- (void)getBucketVersioning {
    XCTestExpectation* exp = [self expectationWithDescription:@"getBucketVersioning"];
    //.cssg-snippet-body-start:[get-bucket-versioning]
    QCloudGetBucketVersioningRequest* request = [[QCloudGetBucketVersioningRequest alloc] init];
    request.bucket = @"bucket-cssg-test-ios-1253653367";
    [request setFinishBlock:^(QCloudBucketVersioningConfiguration* result, NSError* error) {
        XCTAssertNil(error);
        [exp fulfill];
        //可以从 result 中获取返回信息
    }];
    
    [[QCloudCOSXMLService defaultCOSXML] GetBucketVersioning:request];
    //.cssg-snippet-body-end
    [self waitForExpectationsWithTimeout:80 handler:nil];
}

- (void)putBucketReplication {
    XCTestExpectation* exp = [self expectationWithDescription:@"putBucketReplication"];
    //.cssg-snippet-body-start:[put-bucket-replication]
    QCloudPutBucketReplicationRequest* request = [[QCloudPutBucketReplicationRequest alloc] init];
    request.bucket = @"bucket-cssg-test-ios-1253653367";
    QCloudBucketReplicationConfiguation* replConfiguration = [[QCloudBucketReplicationConfiguation
        alloc] init];
    replConfiguration.role = @"qcs::cam::uin/1278687956:uin/1278687956";
    QCloudBucketReplicationRule* rule = [[QCloudBucketReplicationRule alloc] init];
    
    rule.identifier = @"identifier";
    rule.status = QCloudCOSXMLStatusEnabled;
    
    QCloudBucketReplicationDestination* destination = [[QCloudBucketReplicationDestination alloc] init];
    NSString* destinationBucket = @"bucket-cssg-assist-1253653367";
    NSString* region = @"ap-beijing";
    destination.bucket = [NSString stringWithFormat:@"qcs::cos:%@::%@",region,destinationBucket];
    rule.destination = destination;
    rule.prefix = @"a";
    replConfiguration.rule = @[rule];
    request.configuation = replConfiguration;
    
    [request setFinishBlock:^(id outputObject, NSError* error) {
        XCTAssertNil(error);
        [exp fulfill];
        //可以从 outputObject 中获取服务器返回的 header 信息
    }];
    [[QCloudCOSXMLService defaultCOSXML] PutBucketRelication:request];
    //.cssg-snippet-body-end
    [self waitForExpectationsWithTimeout:80 handler:nil];
}

- (void)getBucketReplication {
    XCTestExpectation* exp = [self expectationWithDescription:@"getBucketReplication"];
    //.cssg-snippet-body-start:[get-bucket-replication]
    QCloudGetBucketReplicationRequest* request = [[QCloudGetBucketReplicationRequest alloc] init];
    request.bucket = @"bucket-cssg-test-ios-1253653367";
    
    [request setFinishBlock:^(QCloudBucketReplicationConfiguation* result, NSError* error) {
        XCTAssertNil(error);
        [exp fulfill];
        //可以从 result 中获取返回信息
    }];
    [[QCloudCOSXMLService defaultCOSXML] GetBucketReplication:request];
    //.cssg-snippet-body-end
    [self waitForExpectationsWithTimeout:80 handler:nil];
}

- (void)deleteBucketReplication {
    XCTestExpectation* exp = [self expectationWithDescription:@"deleteBucketReplication"];
    //.cssg-snippet-body-start:[delete-bucket-replication]
    QCloudDeleteBucketReplicationRequest* request = [[QCloudDeleteBucketReplicationRequest alloc] init];
    request.bucket = @"bucket-cssg-test-ios-1253653367";
    
    [request setFinishBlock:^(id outputObject, NSError* error) {
        XCTAssertNil(error);
        [exp fulfill];
        //可以从 outputObject 中获取服务器返回的 header 信息
    }];
    [[QCloudCOSXMLService defaultCOSXML] DeleteBucketReplication:request];
    //.cssg-snippet-body-end
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

    [self putBucket];
}

- (void)tearDown {
    [self deleteBucket];
}

- (void)testBucketACL {
    [self getBucket];
    [self headBucket];
    [self putBucketAcl];
    [self getBucketAcl];
}
- (void)testBucketCORS {
    [self putBucketCors];
    [self getBucketCors];
    [self optionObject];
    [self deleteBucketCors];
}
- (void)testBucketLifecycle {
    [self putBucketLifecycle];
    [self getBucketLifecycle];
    [self deleteBucketLifecycle];
}
- (void)testBucketReplicationAndVersioning {
    [self putBucketVersioning];
    [self getBucketVersioning];
    [self putBucketReplication];
    [self getBucketReplication];
    [self deleteBucketReplication];
}

@end
