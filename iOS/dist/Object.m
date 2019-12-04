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

- (void)GetBucket {
    XCTestExpectation* exp = [self expectationWithDescription:@"get-bucket"];
    QCloudGetBucketRequest* request = [QCloudGetBucketRequest new];
    request.bucket = @"bucket-cssg-test-1253653367";
    request.maxKeys = 1000;
    
    [request setFinishBlock:^(QCloudListBucketResult * result, NSError* error) {
        // result 返回具体信息
        XCTAssertNil(error);
        [exp fulfill];
    }];
    
    [[QCloudCOSXMLService defaultCOSXML] GetBucket:request];
    [self waitForExpectationsWithTimeout:80 handler:nil];
}

- (void)PutObject {
    XCTestExpectation* exp = [self expectationWithDescription:@"put-object"];
    QCloudPutObjectRequest* put = [QCloudPutObjectRequest new];
    put.object = @"object4ios";
    put.bucket = @"bucket-cssg-test-1253653367";
    put.body =  [@"testFileContent" dataUsingEncoding:NSUTF8StringEncoding];
    
    [put setFinishBlock:^(id outputObject, NSError *error) {
        //可以从 outputObject 中获取 response 中 etag 或者自定义头部等信息
        XCTAssertNil(error);
        [exp fulfill];
    }];
    
    [[QCloudCOSXMLService defaultCOSXML] PutObject:put];
    [self waitForExpectationsWithTimeout:80 handler:nil];
}

- (void)HeadObject {
    XCTestExpectation* exp = [self expectationWithDescription:@"head-object"];
    QCloudHeadObjectRequest* headerRequest = [QCloudHeadObjectRequest new];
    headerRequest.object = @"object4ios";
    headerRequest.bucket = @"bucket-cssg-test-1253653367";
    
    [headerRequest setFinishBlock:^(NSDictionary* result, NSError *error) {
        // result 返回具体信息
        XCTAssertNil(error);
        [exp fulfill];
    }];
    
    [[QCloudCOSXMLService defaultCOSXML] HeadObject:headerRequest];
    [self waitForExpectationsWithTimeout:80 handler:nil];
}

- (void)GetObject {
    XCTestExpectation* exp = [self expectationWithDescription:@"get-object"];
    QCloudGetObjectRequest* request = [QCloudGetObjectRequest new];
    //设置下载的路径 URL，如果设置了，文件将会被下载到指定路径中。
    // 如果该参数没有设置，那么文件将会被下载至内存里，存放在在 finishBlock 的 	outputObject 里。
    request.downloadingURL = [NSURL URLWithString:QCloudTempFilePathWithExtension(@"downding")];
    request.object = @"object4ios";
    request.bucket = @"bucket-cssg-test-1253653367";
    
    [request setFinishBlock:^(id outputObject, NSError *error) {
        //可以从 outputObject 中获取 response 中 etag 或者自定义头部等信息
        XCTAssertNil(error);
        [exp fulfill];
    }];
    [request setDownProcessBlock:^(int64_t bytesDownload, int64_t totalBytesDownload,
        int64_t totalBytesExpectedToDownload) {
        //下载过程中的进度
    }];
    
    [[QCloudCOSXMLService defaultCOSXML] GetObject:request];
    [self waitForExpectationsWithTimeout:80 handler:nil];
}

- (void)DeleteObject {
    XCTestExpectation* exp = [self expectationWithDescription:@"delete-object"];
    QCloudDeleteObjectRequest* deleteObjectRequest = [QCloudDeleteObjectRequest new];
    deleteObjectRequest.bucket = @"bucket-cssg-test-1253653367";
    deleteObjectRequest.object = @"object4ios";
    
    [deleteObjectRequest setFinishBlock:^(id outputObject, NSError *error) {
        //可以从 outputObject 中获取 response 中 etag 或者自定义头部等信息
        XCTAssertNil(error);
        [exp fulfill];
    }];
    
    [[QCloudCOSXMLService defaultCOSXML] DeleteObject:deleteObjectRequest];
    [self waitForExpectationsWithTimeout:80 handler:nil];
}

- (void)DeleteMultiObject {
    XCTestExpectation* exp = [self expectationWithDescription:@"delete-multi-object"];
    QCloudDeleteMultipleObjectRequest* delteRequest = [QCloudDeleteMultipleObjectRequest new];
    delteRequest.bucket = @"bucket-cssg-test-1253653367";
    
    QCloudDeleteObjectInfo* deletedObject0 = [QCloudDeleteObjectInfo new];
    deletedObject0.key = @"object4ios";
    
    QCloudDeleteInfo* deleteInfo = [QCloudDeleteInfo new];
    deleteInfo.quiet = NO;
    deleteInfo.objects = @[deletedObject0];
    delteRequest.deleteObjects = deleteInfo;
    
    [delteRequest setFinishBlock:^(QCloudDeleteResult* outputObject, NSError *error) {
        //可以从 outputObject 中获取 response 中 etag 或者自定义头部等信息
        XCTAssertNil(error);
        [exp fulfill];
    }];
    
    [[QCloudCOSXMLService defaultCOSXML] DeleteMultipleObject:delteRequest];
    [self waitForExpectationsWithTimeout:80 handler:nil];
}

- (void)RestoreObject {
    XCTestExpectation* exp = [self expectationWithDescription:@"restore-object"];
    QCloudPostObjectRestoreRequest *req = [QCloudPostObjectRestoreRequest new];
    req.bucket = @"bucket-cssg-test-1253653367";
    req.object = @"object4ios";
    req.restoreRequest.days  = 10;
    req.restoreRequest.CASJobParameters.tier =QCloudCASTierStandard;
    
    [req setFinishBlock:^(id outputObject, NSError *error) {
        //可以从 outputObject 中获取 response 中 etag 或者自定义头部等信息
        [exp fulfill];
    }];
    
    [[QCloudCOSXMLService defaultCOSXML] PostObjectRestore:req];
    [self waitForExpectationsWithTimeout:80 handler:nil];
}

- (void)GetPresignDownloadUrl {
    XCTestExpectation* exp = [self expectationWithDescription:@"get-presign-download-url"];
    QCloudGetPresignedURLRequest* getPresignedURLRequest = [[QCloudGetPresignedURLRequest alloc] init];
    getPresignedURLRequest.bucket = @"bucket-cssg-test-1253653367";
    getPresignedURLRequest.HTTPMethod = @"GET";
    getPresignedURLRequest.object = @"object4ios";
    
    [getPresignedURLRequest setFinishBlock:^(QCloudGetPresignedURLResult * _Nonnull result, NSError * _Nonnull error) {
        XCTAssertNil(error);
        NSString* presignedURL = result.presienedURL;
        [exp fulfill];
    }];
    
    [[QCloudCOSXMLService defaultCOSXML] getPresignedURL:getPresignedURLRequest];
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

}

- (void)tearDown {
}

- (void)testObject {
    [self GetBucket];
    [self PutObject];
    [self HeadObject];
    [self GetObject];
    [self DeleteObject];
    [self DeleteMultiObject];
    [self RestoreObject];
    [self GetPresignDownloadUrl];
}

@end
