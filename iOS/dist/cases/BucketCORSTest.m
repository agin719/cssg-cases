#import <XCTest/XCTest.h>
#import <QCloudCOSXML/QCloudCOSXML.h>
#import <SecretStorage.h>
#import <QCloudCOSXML/QCloudUploadPartRequest.h>
#import <QCloudCOSXML/QCloudCompleteMultipartUploadRequest.h>
#import <QCloudCOSXML/QCloudAbortMultipfartUploadRequest.h>
#import <QCloudCOSXML/QCloudMultipartInfo.h>
#import <QCloudCOSXML/QCloudCompleteMultipartUploadInfo.h>

@interface BucketCORSTest : XCTestCase <QCloudSignatureProvider>
@property (nonatomic) NSString* uploadId;
@property (nonatomic) NSMutableArray<QCloudMultipartInfo *> *parts;
@end

@implementation BucketCORSTest

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

- (void)PutBucketCors {
    XCTestExpectation* exp = [self expectationWithDescription:@"PutBucketCors"];
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
    
    [self waitForExpectationsWithTimeout:80 handler:nil];
}

- (void)GetBucketCors {
    XCTestExpectation* exp = [self expectationWithDescription:@"GetBucketCors"];
    QCloudGetBucketCORSRequest* corsReqeust = [QCloudGetBucketCORSRequest new];
    corsReqeust.bucket = @"bucket-cssg-test-ios-1253653367";
    
    [corsReqeust setFinishBlock:^(QCloudCORSConfiguration * _Nonnull result, NSError * _Nonnull error) {
        XCTAssertNil(error);
        [exp fulfill];
        //CORS 设置封装在 result 中
    }];
    
    [[QCloudCOSXMLService defaultCOSXML] GetBucketCORS:corsReqeust];
    
    [self waitForExpectationsWithTimeout:80 handler:nil];
}

- (void)OptionObject {
    XCTestExpectation* exp = [self expectationWithDescription:@"OptionObject"];
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
    
    [self waitForExpectationsWithTimeout:80 handler:nil];
}

- (void)DeleteBucketCors {
    XCTestExpectation* exp = [self expectationWithDescription:@"DeleteBucketCors"];
    QCloudDeleteBucketCORSRequest* deleteCORS = [QCloudDeleteBucketCORSRequest new];
    deleteCORS.bucket = @"bucket-cssg-test-ios-1253653367";
    [deleteCORS setFinishBlock:^(id outputObject, NSError *error) {
        XCTAssertNil(error);
        [exp fulfill];
        //可以从 outputObject 中获取服务器返回的 header 信息
    }];
    [[QCloudCOSXMLService defaultCOSXML] DeleteBucketCORS:deleteCORS];
    
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

- (void)testBucketCORS {
    [self PutBucketCors];
    [self GetBucketCors];
    [self OptionObject];
    [self DeleteBucketCors];
}

@end
