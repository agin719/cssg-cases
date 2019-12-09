#import <XCTest/XCTest.h>
#import <QCloudCOSXML/QCloudCOSXML.h>
#import <SecretStorage.h>
#import <QCloudCOSXML/QCloudUploadPartRequest.h>
#import <QCloudCOSXML/QCloudCompleteMultipartUploadRequest.h>
#import <QCloudCOSXML/QCloudAbortMultipfartUploadRequest.h>
#import <QCloudCOSXML/QCloudMultipartInfo.h>
#import <QCloudCOSXML/QCloudCompleteMultipartUploadInfo.h>

@interface ObjectTest : XCTestCase <QCloudSignatureProvider>
@property (nonatomic) NSString* uploadId;
@property (nonatomic) NSMutableArray<QCloudMultipartInfo *> *parts;
@end

@implementation ObjectTest

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

- (void)PutObject {
    XCTestExpectation* exp = [self expectationWithDescription:@"PutObject"];
    QCloudPutObjectRequest* put = [QCloudPutObjectRequest new];
    put.object = @"object4ios";
    put.bucket = @"bucket-cssg-test-ios-1253653367";
    put.body =  [@"testFileContent" dataUsingEncoding:NSUTF8StringEncoding];
    
    [put setFinishBlock:^(id outputObject, NSError *error) {
        XCTAssertNil(error);
        [exp fulfill];
        //可以从 outputObject 中获取 response 中 etag 或者自定义头部等信息
    }];
    
    [[QCloudCOSXMLService defaultCOSXML] PutObject:put];
    
    [self waitForExpectationsWithTimeout:80 handler:nil];
}

- (void)PutObjectAcl {
    XCTestExpectation* exp = [self expectationWithDescription:@"PutObjectAcl"];
    QCloudPutObjectACLRequest* request = [QCloudPutObjectACLRequest new];
    request.object = @"object4ios";
    request.bucket = @"bucket-cssg-test-ios-1253653367";
    NSString *grantString = [NSString stringWithFormat:@"id=\"%@\"",@"1253653367"];
    request.grantFullControl = grantString;
    [request setFinishBlock:^(id outputObject, NSError *error) {
        XCTAssertNil(error);
        [exp fulfill];
        //可以从 outputObject 中获取 response 中 etag 或者自定义头部等信息
    }];
    
    [[QCloudCOSXMLService defaultCOSXML] PutObjectACL:request];
    
    [self waitForExpectationsWithTimeout:80 handler:nil];
}

- (void)GetObjectAcl {
    XCTestExpectation* exp = [self expectationWithDescription:@"GetObjectAcl"];
    QCloudGetObjectACLRequest *request = [QCloudGetObjectACLRequest new];
    request.object = @"object4ios";
    request.bucket = @"bucket-cssg-test-ios-1253653367";
    __block QCloudACLPolicy* policy;
    [request setFinishBlock:^(QCloudACLPolicy * _Nonnull result, NSError * _Nonnull error) {
        XCTAssertNil(error);
        [exp fulfill];
        policy = result;
    }];
    
    [[QCloudCOSXMLService defaultCOSXML] GetObjectACL:request];
    
    [self waitForExpectationsWithTimeout:80 handler:nil];
}

- (void)HeadObject {
    XCTestExpectation* exp = [self expectationWithDescription:@"HeadObject"];
    QCloudHeadObjectRequest* headerRequest = [QCloudHeadObjectRequest new];
    headerRequest.object = @"object4ios";
    headerRequest.bucket = @"bucket-cssg-test-ios-1253653367";
    
    [headerRequest setFinishBlock:^(NSDictionary* result, NSError *error) {
        XCTAssertNil(error);
        [exp fulfill];
        // result 返回具体信息
    }];
    
    [[QCloudCOSXMLService defaultCOSXML] HeadObject:headerRequest];
    
    [self waitForExpectationsWithTimeout:80 handler:nil];
}

- (void)GetObject {
    XCTestExpectation* exp = [self expectationWithDescription:@"GetObject"];
    QCloudGetObjectRequest* request = [QCloudGetObjectRequest new];
    //设置下载的路径 URL，如果设置了，文件将会被下载到指定路径中
    //如果未设置该参数，那么文件将会被下载至内存里，存放在在 finishBlock 的 outputObject 里
    request.downloadingURL = [NSURL URLWithString:QCloudTempFilePathWithExtension(@"downding")];
    request.object = @"object4ios";
    request.bucket = @"bucket-cssg-test-ios-1253653367";
    
    [request setFinishBlock:^(id outputObject, NSError *error) {
        XCTAssertNil(error);
        [exp fulfill];
        //可以从 outputObject 中获取 response 中 etag 或者自定义头部等信息
    }];
    [request setDownProcessBlock:^(int64_t bytesDownload, int64_t totalBytesDownload,
        int64_t totalBytesExpectedToDownload) {
        //下载过程中的进度
    }];
    
    [[QCloudCOSXMLService defaultCOSXML] GetObject:request];
    
    [self waitForExpectationsWithTimeout:80 handler:nil];
}

- (void)DeleteObject {
    XCTestExpectation* exp = [self expectationWithDescription:@"DeleteObject"];
    QCloudDeleteObjectRequest* deleteObjectRequest = [QCloudDeleteObjectRequest new];
    deleteObjectRequest.bucket = @"bucket-cssg-test-ios-1253653367";
    deleteObjectRequest.object = @"object4ios";
    
    [deleteObjectRequest setFinishBlock:^(id outputObject, NSError *error) {
        XCTAssertNil(error);
        [exp fulfill];
        //可以从 outputObject 中获取 response 中 etag 或者自定义头部等信息
    }];
    
    [[QCloudCOSXMLService defaultCOSXML] DeleteObject:deleteObjectRequest];
    
    [self waitForExpectationsWithTimeout:80 handler:nil];
}

- (void)DeleteMultiObject {
    XCTestExpectation* exp = [self expectationWithDescription:@"DeleteMultiObject"];
    QCloudDeleteMultipleObjectRequest* delteRequest = [QCloudDeleteMultipleObjectRequest new];
    delteRequest.bucket = @"bucket-cssg-test-ios-1253653367";
    
    QCloudDeleteObjectInfo* deletedObject0 = [QCloudDeleteObjectInfo new];
    deletedObject0.key = @"object4ios";
    
    QCloudDeleteInfo* deleteInfo = [QCloudDeleteInfo new];
    deleteInfo.quiet = NO;
    deleteInfo.objects = @[deletedObject0];
    delteRequest.deleteObjects = deleteInfo;
    
    [delteRequest setFinishBlock:^(QCloudDeleteResult* outputObject, NSError *error) {
        XCTAssertNil(error);
        [exp fulfill];
        //可以从 outputObject 中获取 response 中 etag 或者自定义头部等信息
    }];
    
    [[QCloudCOSXMLService defaultCOSXML] DeleteMultipleObject:delteRequest];
    
    [self waitForExpectationsWithTimeout:80 handler:nil];
}

- (void)RestoreObject {
    XCTestExpectation* exp = [self expectationWithDescription:@"RestoreObject"];
    QCloudPostObjectRestoreRequest *req = [QCloudPostObjectRestoreRequest new];
    req.bucket = @"bucket-cssg-test-ios-1253653367";
    req.object = @"object4ios";
    req.restoreRequest.days  = 10;
    req.restoreRequest.CASJobParameters.tier =QCloudCASTierStandard;
    
    [req setFinishBlock:^(id outputObject, NSError *error) {
        [exp fulfill];
        //可以从 outputObject 中获取 response 中 etag 或者自定义头部等信息
    }];
    
    [[QCloudCOSXMLService defaultCOSXML] PostObjectRestore:req];
    
    [self waitForExpectationsWithTimeout:80 handler:nil];
}

- (void)GetPresignDownloadUrl {
    XCTestExpectation* exp = [self expectationWithDescription:@"GetPresignDownloadUrl"];
    QCloudGetPresignedURLRequest* getPresignedURLRequest = [[QCloudGetPresignedURLRequest alloc] init];
    getPresignedURLRequest.bucket = @"bucket-cssg-test-ios-1253653367";
    getPresignedURLRequest.HTTPMethod = @"GET";
    getPresignedURLRequest.object = @"object4ios";
    
    [getPresignedURLRequest setFinishBlock:^(QCloudGetPresignedURLResult * _Nonnull result, NSError * _Nonnull error) {
        XCTAssertNil(error);
        [exp fulfill];
        NSString* presignedURL = result.presienedURL;
    }];
    
    [[QCloudCOSXMLService defaultCOSXML] getPresignedURL:getPresignedURLRequest];
    
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
    [self DeleteObject];
    [self DeleteBucket];
}

- (void)testObject {
    [self PutObject];
    [self PutObjectAcl];
    [self GetObjectAcl];
    [self HeadObject];
    [self GetObject];
    [self DeleteObject];
    [self DeleteMultiObject];
    [self RestoreObject];
    [self GetPresignDownloadUrl];
}

@end
