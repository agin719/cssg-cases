#import <XCTest/XCTest.h>
#import <QCloudCOSXML/QCloudCOSXML.h>
#import <SecretStorage.h>
#import <QCloudCOSXML/QCloudUploadPartRequest.h>
#import <QCloudCOSXML/QCloudCompleteMultipartUploadRequest.h>
#import <QCloudCOSXML/QCloudAbortMultipfartUploadRequest.h>
#import <QCloudCOSXML/QCloudMultipartInfo.h>
#import <QCloudCOSXML/QCloudCompleteMultipartUploadInfo.h>

@interface BucketReplicationAndVersioningTest : XCTestCase <QCloudSignatureProvider>
@property (nonatomic) NSString* uploadId;
@property (nonatomic) NSMutableArray<QCloudMultipartInfo *> *parts;
@end

@implementation BucketReplicationAndVersioningTest

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
    XCTestExpectation* exp = [self expectationWithDescription:@"PutBucket"];
    QCloudPutBucketRequest* request = [QCloudPutBucketRequest new];
    request.bucket = @"bucket-cssg-test-ios-1253653367"; //additional actions after finishing
    [request setFinishBlock:^(id outputObject, NSError* error) {
        [exp fulfill];
        //可以从 outputObject 中获取服务器返回的 header 信息
    }];
    [[QCloudCOSXMLService defaultCOSXML] PutBucket:request];
    
    [self waitForExpectationsWithTimeout:80 handler:nil];
}

- (void)PutBucketVersioning {
    XCTestExpectation* exp = [self expectationWithDescription:@"PutBucketVersioning"];
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
    
    [self waitForExpectationsWithTimeout:80 handler:nil];
}

- (void)GetBucketVersioning {
    XCTestExpectation* exp = [self expectationWithDescription:@"GetBucketVersioning"];
    QCloudGetBucketVersioningRequest* request = [[QCloudGetBucketVersioningRequest alloc] init];
    request.bucket = @"bucket-cssg-test-ios-1253653367";
    [request setFinishBlock:^(QCloudBucketVersioningConfiguration* result, NSError* error) {
        XCTAssertNil(error);
        [exp fulfill];
        //可以从 result 中获取返回信息
    }];
    
    [[QCloudCOSXMLService defaultCOSXML] GetBucketVersioning:request];
    
    [self waitForExpectationsWithTimeout:80 handler:nil];
}

- (void)PutBucketReplication {
    XCTestExpectation* exp = [self expectationWithDescription:@"PutBucketReplication"];
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
    
    [self waitForExpectationsWithTimeout:80 handler:nil];
}

- (void)GetBucketReplication {
    XCTestExpectation* exp = [self expectationWithDescription:@"GetBucketReplication"];
    QCloudGetBucketReplicationRequest* request = [[QCloudGetBucketReplicationRequest alloc] init];
    request.bucket = @"bucket-cssg-test-ios-1253653367";
    
    [request setFinishBlock:^(QCloudBucketReplicationConfiguation* result, NSError* error) {
        XCTAssertNil(error);
        [exp fulfill];
        //可以从 result 中获取返回信息
    }];
    [[QCloudCOSXMLService defaultCOSXML] GetBucketReplication:request];
    
    [self waitForExpectationsWithTimeout:80 handler:nil];
}

- (void)DeleteBucketReplication {
    XCTestExpectation* exp = [self expectationWithDescription:@"DeleteBucketReplication"];
    QCloudDeleteBucketReplicationRequest* request = [[QCloudDeleteBucketReplicationRequest alloc] init];
    request.bucket = @"bucket-cssg-test-ios-1253653367";
    
    [request setFinishBlock:^(id outputObject, NSError* error) {
        XCTAssertNil(error);
        [exp fulfill];
        //可以从 outputObject 中获取服务器返回的 header 信息
    }];
    [[QCloudCOSXMLService defaultCOSXML] DeleteBucketReplication:request];
    
    [self waitForExpectationsWithTimeout:80 handler:nil];
}

- (void)DeleteBucket {
    XCTestExpectation* exp = [self expectationWithDescription:@"DeleteBucket"];
    QCloudDeleteBucketRequest* request = [[QCloudDeleteBucketRequest alloc ] init];
    request.bucket = @"bucket-cssg-test-ios-1253653367";  //存储桶名称，命名格式：BucketName-APPID
    [request setFinishBlock:^(id outputObject,NSError*error) {
        [exp fulfill];
        //可以从 outputObject 中获取服务器返回的 header 信息
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

- (void)testBucketReplicationAndVersioning {
    [self PutBucketVersioning];
    [self GetBucketVersioning];
    [self PutBucketReplication];
    [self GetBucketReplication];
    [self DeleteBucketReplication];
}

@end
