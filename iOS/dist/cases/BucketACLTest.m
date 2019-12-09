#import <XCTest/XCTest.h>
#import <QCloudCOSXML/QCloudCOSXML.h>
#import <SecretStorage.h>
#import <QCloudCOSXML/QCloudUploadPartRequest.h>
#import <QCloudCOSXML/QCloudCompleteMultipartUploadRequest.h>
#import <QCloudCOSXML/QCloudAbortMultipfartUploadRequest.h>
#import <QCloudCOSXML/QCloudMultipartInfo.h>
#import <QCloudCOSXML/QCloudCompleteMultipartUploadInfo.h>

@interface BucketACLTest : XCTestCase <QCloudSignatureProvider>
@property (nonatomic) NSString* uploadId;
@property (nonatomic) NSMutableArray<QCloudMultipartInfo *> *parts;
@end

@implementation BucketACLTest

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

- (void)GetBucket {
    XCTestExpectation* exp = [self expectationWithDescription:@"GetBucket"];
    QCloudGetBucketRequest* request = [QCloudGetBucketRequest new];
    request.bucket = @"bucket-cssg-test-ios-1253653367";
    request.maxKeys = 1000;
    
    [request setFinishBlock:^(QCloudListBucketResult * result, NSError* error) {
        XCTAssertNil(error);
        [exp fulfill];
        // result 返回具体信息
    }];
    
    [[QCloudCOSXMLService defaultCOSXML] GetBucket:request];
    
    [self waitForExpectationsWithTimeout:80 handler:nil];
}

- (void)HeadBucket {
    XCTestExpectation* exp = [self expectationWithDescription:@"HeadBucket"];
    QCloudHeadBucketRequest* request = [QCloudHeadBucketRequest new];
    request.bucket = @"bucket-cssg-test-ios-1253653367";
    [request setFinishBlock:^(id outputObject, NSError* error) {
        XCTAssertNil(error);
        [exp fulfill];
        //可以从 outputObject 中获取服务器返回的 header 信息
    }];
    [[QCloudCOSXMLService defaultCOSXML] HeadBucket:request];
    
    [self waitForExpectationsWithTimeout:80 handler:nil];
}

- (void)PutBucketAcl {
    XCTestExpectation* exp = [self expectationWithDescription:@"PutBucketAcl"];
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
    
    [self waitForExpectationsWithTimeout:80 handler:nil];
}

- (void)GetBucketAcl {
    XCTestExpectation* exp = [self expectationWithDescription:@"GetBucketAcl"];
    QCloudGetBucketACLRequest* getBucketACl = [QCloudGetBucketACLRequest new];
    getBucketACl.bucket = @"bucket-cssg-test-ios-1253653367";
    [getBucketACl setFinishBlock:^(QCloudACLPolicy * _Nonnull result, NSError * _Nonnull error) {
        XCTAssertNil(error);
        [exp fulfill];
        //QCloudACLPolicy 中包含了 Bucket 的 ACL 信息
    }];
    
    [[QCloudCOSXMLService defaultCOSXML] GetBucketACL:getBucketACl];
    
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

- (void)testBucketACL {
    [self GetBucket];
    [self HeadBucket];
    [self PutBucketAcl];
    [self GetBucketAcl];
}

@end
