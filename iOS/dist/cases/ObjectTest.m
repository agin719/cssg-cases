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

- (void)putBucket {
    XCTestExpectation* exp = [self expectationWithDescription:@"putBucket"];
    QCloudPutBucketRequest* request = [QCloudPutBucketRequest new];
    request.bucket = @"bucket-cssg-test-ios-1253653367"; //additional actions after finishing
    [request setFinishBlock:^(id outputObject, NSError* error) {
        [exp fulfill];
        //可以从 outputObject 中获取服务器返回的 header 信息
    }];
    [[QCloudCOSXMLService defaultCOSXML] PutBucket:request];
    
    [self waitForExpectationsWithTimeout:80 handler:nil];
}

- (void)deleteObject {
    XCTestExpectation* exp = [self expectationWithDescription:@"deleteObject"];
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

- (void)deleteBucket {
    XCTestExpectation* exp = [self expectationWithDescription:@"deleteBucket"];
    QCloudDeleteBucketRequest* request = [[QCloudDeleteBucketRequest alloc ] init];
    request.bucket = @"bucket-cssg-test-ios-1253653367";  //存储桶名称，命名格式：BucketName-APPID
    [request setFinishBlock:^(id outputObject,NSError*error) {
        [exp fulfill];
        //可以从 outputObject 中获取服务器返回的 header 信息
    }];
    [[QCloudCOSXMLService defaultCOSXML] DeleteBucket:request];
    
    [self waitForExpectationsWithTimeout:80 handler:nil];
}

- (void)putObject {
    XCTestExpectation* exp = [self expectationWithDescription:@"putObject"];
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

- (void)putObjectAcl {
    XCTestExpectation* exp = [self expectationWithDescription:@"putObjectAcl"];
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

- (void)getObjectAcl {
    XCTestExpectation* exp = [self expectationWithDescription:@"getObjectAcl"];
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

- (void)headObject {
    XCTestExpectation* exp = [self expectationWithDescription:@"headObject"];
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

- (void)getObject {
    XCTestExpectation* exp = [self expectationWithDescription:@"getObject"];
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

- (void)getPresignDownloadUrl {
    XCTestExpectation* exp = [self expectationWithDescription:@"getPresignDownloadUrl"];
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

- (void)deleteMultiObject {
    XCTestExpectation* exp = [self expectationWithDescription:@"deleteMultiObject"];
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

- (void)restoreObject {
    XCTestExpectation* exp = [self expectationWithDescription:@"restoreObject"];
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

- (void)initMultiUpload {
    XCTestExpectation* exp = [self expectationWithDescription:@"initMultiUpload"];
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

- (void)listMultiUpload {
    XCTestExpectation* exp = [self expectationWithDescription:@"listMultiUpload"];
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

- (void)uploadPart {
    XCTestExpectation* exp = [self expectationWithDescription:@"uploadPart"];
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

- (void)listParts {
    XCTestExpectation* exp = [self expectationWithDescription:@"listParts"];
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

- (void)completeMultiUpload {
    XCTestExpectation* exp = [self expectationWithDescription:@"completeMultiUpload"];
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

- (void)abortMultiUpload {
    XCTestExpectation* exp = [self expectationWithDescription:@"abortMultiUpload"];
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

- (void)transferUploadObject {
    XCTestExpectation* exp = [self expectationWithDescription:@"transferUploadObject"];
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

- (void)transferCopyObject {
    XCTestExpectation* exp = [self expectationWithDescription:@"transferCopyObject"];
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

- (void)copyObject {
    XCTestExpectation* exp = [self expectationWithDescription:@"copyObject"];
    QCloudPutObjectCopyRequest* request = [[QCloudPutObjectCopyRequest alloc] init];
    request.bucket = @"bucket-cssg-test-ios-1253653367";
    request.object = @"object4ios";
    //源对象所在的路径
    request.objectCopySource = @"bucket-cssg-source-1253653367.cos.ap-guangzhou.myqcloud.com/sourceObject";
    [request setFinishBlock:^(QCloudCopyObjectResult * _Nonnull result, NSError * _Nonnull error) {
        XCTAssertNil(error);
        [exp fulfill];
        //result 返回具体信息
    }];
    [[QCloudCOSXMLService defaultCOSXML]  PutObjectCopy:request];
    
    [self waitForExpectationsWithTimeout:80 handler:nil];
}

- (void)uploadPartCopy {
    XCTestExpectation* exp = [self expectationWithDescription:@"uploadPartCopy"];
    QCloudUploadPartCopyRequest* request = [[QCloudUploadPartCopyRequest alloc] init];
    request.bucket = @"bucket-cssg-test-ios-1253653367";
    request.object = @"object4ios";
    //源文件 URL 路径，可以通过 versionid 子资源指定历史版本
    request.source = @"bucket-cssg-source-1253653367.cos.ap-guangzhou.myqcloud.com/sourceObject";
    //在初始化分块上传的响应中，会返回一个唯一的描述符（upload ID）
    request.uploadID = self.uploadId;
    request.partNumber = 1; // 标志当前分块的序号
    
    [request setFinishBlock:^(QCloudCopyObjectResult* result, NSError* error) {
        XCTAssertNil(error);
        [exp fulfill];
        QCloudMultipartInfo *part = [QCloudMultipartInfo new];
        //获取所复制分块的 etag
        part.eTag = result.eTag;
        part.partNumber = @"1";
        // 保存起来用于最后完成上传时使用
        self.parts=@[part];
    }];
    
    [[QCloudCOSXMLService defaultCOSXML]UploadPartCopy:request];
    
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
    [self deleteObject];
    [self deleteBucket];
}

- (void)testObjectMetadata {
    [self putObject];
    [self putObjectAcl];
    [self getObjectAcl];
    [self headObject];
    [self getObject];
    [self getPresignDownloadUrl];
    [self deleteObject];
    [self deleteMultiObject];
    [self restoreObject];
}
- (void)testObjectMultiUpload {
    [self initMultiUpload];
    [self listMultiUpload];
    [self uploadPart];
    [self listParts];
    [self completeMultiUpload];
}
- (void)testObjectAbortMultiUpload {
    [self initMultiUpload];
    [self uploadPart];
    [self abortMultiUpload];
}
- (void)testObjectTransfer {
    [self transferUploadObject];
    [self transferCopyObject];
}
- (void)testObjectCopy {
    [self copyObject];
    [self initMultiUpload];
    [self uploadPartCopy];
    [self completeMultiUpload];
}

@end
