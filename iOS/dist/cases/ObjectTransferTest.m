#import <XCTest/XCTest.h>
#import <QCloudCOSXML/QCloudCOSXML.h>
#import <SecretStorage.h>
#import <QCloudCOSXML/QCloudUploadPartRequest.h>
#import <QCloudCOSXML/QCloudCompleteMultipartUploadRequest.h>
#import <QCloudCOSXML/QCloudAbortMultipfartUploadRequest.h>
#import <QCloudCOSXML/QCloudMultipartInfo.h>
#import <QCloudCOSXML/QCloudCompleteMultipartUploadInfo.h>

@interface ObjectTransferTest : XCTestCase <QCloudSignatureProvider>
@property (nonatomic) NSString* uploadId;
@property (nonatomic) NSMutableArray<QCloudMultipartInfo *> *parts;
@end

@implementation ObjectTransferTest

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

- (void)InitMultiUpload {
    XCTestExpectation* exp = [self expectationWithDescription:@"InitMultiUpload"];
    QCloudInitiateMultipartUploadRequest* initrequest = [QCloudInitiateMultipartUploadRequest new];
    initrequest.bucket = @"bucket-cssg-test-ios-1253653367";
    initrequest.object = @"object4ios";
    
    [initrequest setFinishBlock:^(QCloudInitiateMultipartUploadResult* outputObject, NSError *error) {
        XCTAssertNil(error);
        [exp fulfill];
        //获取分块上传的 uploadId，后续的上传都需要这个 ID，请保存以备后续使用
        self.uploadId = outputObject.uploadId;
    }];
    
    [[QCloudCOSXMLService defaultCOSXML] InitiateMultipartUpload:initrequest];
    
    [self waitForExpectationsWithTimeout:80 handler:nil];
}

- (void)ListMultiUpload {
    XCTestExpectation* exp = [self expectationWithDescription:@"ListMultiUpload"];
    QCloudListBucketMultipartUploadsRequest* uploads = [QCloudListBucketMultipartUploadsRequest new];
    uploads.bucket = @"bucket-cssg-test-ios-1253653367";
    uploads.maxUploads = 100;
    
    [uploads setFinishBlock:^(QCloudListMultipartUploadsResult* result, NSError *error) {
        XCTAssertNil(error);
        [exp fulfill];
        //可以从 result 中返回分块信息
    }];
    
    [[QCloudCOSXMLService defaultCOSXML] ListBucketMultipartUploads:uploads];
    
    [self waitForExpectationsWithTimeout:80 handler:nil];
}

- (void)UploadPart {
    XCTestExpectation* exp = [self expectationWithDescription:@"UploadPart"];
    QCloudUploadPartRequest* request = [QCloudUploadPartRequest new];
    request.bucket = @"bucket-cssg-test-ios-1253653367";
    request.object = @"object4ios";
    request.partNumber = 1;
    //标识本次分块上传的 ID；使用 Initiate Multipart Upload 接口初始化分块上传时会得到一个 uploadId
    //该 ID 不但唯一标识这一分块数据，也标识了这分块数据在整个文件内的相对位置
    request.uploadId = self.uploadId;
    //上传的数据：支持 NSData*，NSURL(本地 URL) 和 QCloudFileOffsetBody * 三种类型
    request.body = [@"testFileContent" dataUsingEncoding:NSUTF8StringEncoding];
    
    [request setSendProcessBlock:^(int64_t bytesSent,
                                   int64_t totalBytesSent,
                                   int64_t totalBytesExpectedToSend) {
        //上传进度信息
    }];
    [request setFinishBlock:^(QCloudUploadPartResult* outputObject, NSError *error) {
        XCTAssertNil(error);
        [exp fulfill];
        QCloudMultipartInfo *part = [QCloudMultipartInfo new];
        //获取所上传分块的 etag
        part.eTag = outputObject.eTag;
        part.partNumber = @"1";
        // 保存起来用于最好完成上传时使用
        self.parts = @[part];
    }];
    
    [[QCloudCOSXMLService defaultCOSXML]  UploadPart:request];
    
    [self waitForExpectationsWithTimeout:80 handler:nil];
}

- (void)ListParts {
    XCTestExpectation* exp = [self expectationWithDescription:@"ListParts"];
    QCloudListMultipartRequest* request = [QCloudListMultipartRequest new];
    request.object = @"object4ios";
    request.bucket = @"bucket-cssg-test-ios-1253653367";
    //在初始化分块上传的响应中，会返回一个唯一的描述符（upload ID）
    request.uploadId = self.uploadId;
    
    [request setFinishBlock:^(QCloudListPartsResult * _Nonnull result, NSError * _Nonnull error) {
        XCTAssertNil(error);
        [exp fulfill];
        //从 result 中获取已上传分块信息
    }];
    
    [[QCloudCOSXMLService defaultCOSXML] ListMultipart:request];
    
    [self waitForExpectationsWithTimeout:80 handler:nil];
}

- (void)CompleteMultiUpload {
    XCTestExpectation* exp = [self expectationWithDescription:@"CompleteMultiUpload"];
    QCloudCompleteMultipartUploadRequest *completeRequst = [QCloudCompleteMultipartUploadRequest new];
    completeRequst.object = @"object4ios";
    completeRequst.bucket = @"bucket-cssg-test-ios-1253653367";
    //本次要查询的分块上传的 uploadId，可从初始化分块上传的请求结果 QCloudInitiateMultipartUploadResult 中得到
    completeRequst.uploadId = self.uploadId;
    //已上传分块的信息
    QCloudCompleteMultipartUploadInfo *partInfo = [QCloudCompleteMultipartUploadInfo new];
    partInfo.parts = self.parts;
    completeRequst.parts = partInfo;
    
    [completeRequst setFinishBlock:^(QCloudUploadObjectResult * _Nonnull result, NSError * _Nonnull error) {
        XCTAssertNil(error);
        [exp fulfill];
        //从 result 中获取上传结果
    }];
    
    [[QCloudCOSXMLService defaultCOSXML] CompleteMultipartUpload:completeRequst];
    
    [self waitForExpectationsWithTimeout:80 handler:nil];
}

- (void)AbortMultiUpload {
    XCTestExpectation* exp = [self expectationWithDescription:@"AbortMultiUpload"];
    QCloudAbortMultipfartUploadRequest *abortRequest = [QCloudAbortMultipfartUploadRequest new];
    abortRequest.object = @"object4ios";
    abortRequest.bucket = @"bucket-cssg-test-ios-1253653367";
    //本次要查询的分块上传的 uploadId，可从初始化分块上传的请求结果 QCloudInitiateMultipartUploadResult 中得到
    abortRequest.uploadId = self.uploadId;
    
    [abortRequest setFinishBlock:^(id outputObject, NSError *error) {
        XCTAssertNil(error);
        [exp fulfill];
        //可以从 outputObject 中获取 response 中 etag 或者自定义头部等信息
    }];
    
    [[QCloudCOSXMLService defaultCOSXML]AbortMultipfartUpload:abortRequest];
    
    [self waitForExpectationsWithTimeout:80 handler:nil];
}

- (void)TransferUploadObject {
    XCTestExpectation* exp = [self expectationWithDescription:@"TransferUploadObject"];
    QCloudCOSXMLUploadObjectRequest* put = [QCloudCOSXMLUploadObjectRequest new];
    put.object = @"object4ios";
    put.bucket = @"bucket-cssg-test-ios-1253653367";
    put.body = [@"testFileContent" dataUsingEncoding:NSUTF8StringEncoding];
    //设置一些上传的参数
    put.initMultipleUploadFinishBlock = ^(QCloudInitiateMultipartUploadResult * multipleUploadInitResult,
        QCloudCOSXMLUploadObjectResumeData resumeData) {
        //在初始化分块上传完成以后会回调该 block，在这里可以获取 resumeData，
        //并且可以通过 resumeData 生成一个分块上传的请求
        QCloudCOSXMLUploadObjectRequest* request = [QCloudCOSXMLUploadObjectRequest
            requestWithRequestData:resumeData];
    };
    [put setSendProcessBlock:^(int64_t bytesSent, int64_t totalBytesSent,
        int64_t totalBytesExpectedToSend) {
        NSLog(@"upload %lld totalSend %lld aim %lld", bytesSent, totalBytesSent,
            totalBytesExpectedToSend);
    }];
    [put setFinishBlock:^(QCloudUploadObjectResult *result, NSError* error) {
        [exp fulfill];
        //可以从 result 获取结果
    }];
    
    [[QCloudCOSTransferMangerService defaultCOSTransferManager] UploadObject:put];
    
    //•••在完成了初始化，并且上传没有完成前
    NSError* error;
    //这里是主动调用取消，并且产生 resumetData 的例子
    QCloudCOSXMLUploadObjectResumeData resumeData = [put cancelByProductingResumeData:&error];
    QCloudCOSXMLUploadObjectRequest* request = nil;
    if (resumeData) {
        request = [QCloudCOSXMLUploadObjectRequest requestWithRequestData:resumeData];
    }
    //生成的用于恢复上传的请求可以直接上传
    [[QCloudCOSTransferMangerService defaultCOSTransferManager] UploadObject:request];
    
    [self waitForExpectationsWithTimeout:80 handler:nil];
}

- (void)TransferCopyObject {
    XCTestExpectation* exp = [self expectationWithDescription:@"TransferCopyObject"];
    QCloudCOSXMLCopyObjectRequest* request = [[QCloudCOSXMLCopyObjectRequest alloc] init];
    
    request.bucket = @"bucket-cssg-test-ios-1253653367";//目的 <BucketName-APPID>，需要是公有读或者在当前账号有权限
    request.object = @"object4ios";//目的文件名称
    //文件来源 <BucketName-APPID>，需要是公有读或者在当前账号有权限
    request.sourceBucket = @"bucket-cssg-source-1253653367";
    request.sourceObject = @"sourceObject";//源文件名称
    request.sourceAPPID = @"1253653367";//源文件的 APPID
    request.sourceRegion= @"ap-guangzhou";//来源的地域
    
    [request setFinishBlock:^(QCloudCopyObjectResult* result, NSError* error) {
        XCTAssertNil(error);
        [exp fulfill];
        //可以从 outputObject 中获取 response 中 etag 或者自定义头部等信息
    }];
    
    //注意如果是跨地域复制，这里使用的 transferManager 所在的 region 必须为目标桶所在的 region
    [[QCloudCOSTransferMangerService defaultCOSTransferManager] CopyObject:request];
    
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

- (void)testObjectTransfer {
    [self InitMultiUpload];
    [self ListMultiUpload];
    [self UploadPart];
    [self ListParts];
    [self CompleteMultiUpload];
    [self InitMultiUpload];
    [self UploadPart];
    [self AbortMultiUpload];
    [self TransferUploadObject];
    [self TransferCopyObject];
}

@end
