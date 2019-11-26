#import <XCTest/XCTest.h>
#import <QCloudCOSXML/QCloudCOSXML.h>
#import <SecretStorage.h>
#import <QCloudCOSXML/QCloudUploadPartRequest.h>
#import <QCloudCOSXML/QCloudCompleteMultipartUploadRequest.h>
#import <QCloudCOSXML/QCloudAbortMultipfartUploadRequest.h>
#import <QCloudCOSXML/QCloudMultipartInfo.h>
#import <QCloudCOSXML/QCloudCompleteMultipartUploadInfo.h>

@interface ObjectMultiUploadTest : XCTestCase <QCloudSignatureProvider>

@property (nonatomic) NSString* uploadId;
@property (nonatomic) NSMutableArray<QCloudMultipartInfo *> *parts;

@end

@implementation ObjectMultiUploadTest

- (void)setUp {
    
}

- (void)tearDown {
    
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

- (void)InitMultiUpload {
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
    XCTestExpectation* exp = [self expectationWithDescription:@"init-multi-upload"];
    QCloudInitiateMultipartUploadRequest* initrequest = [QCloudInitiateMultipartUploadRequest new];
    initrequest.bucket = @"bucket-cssg-test-1253653367";
    initrequest.object = @"object4iOS";
    
    [initrequest setFinishBlock:^(QCloudInitiateMultipartUploadResult* outputObject, NSError *error) {
        // 获取分片上传的 uploadId，后续的上传都需要这个 id，请保存起来后续使用
        self.uploadId = outputObject.uploadId;
        XCTAssertNil(error);
        [exp fulfill];
    }];
    
    [[QCloudCOSXMLService defaultCOSXML] InitiateMultipartUpload:initrequest];
    [self waitForExpectationsWithTimeout:80 handler:nil];
}

- (void)ListMultiUpload {
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
    XCTestExpectation* exp = [self expectationWithDescription:@"list-multi-upload"];
    QCloudListBucketMultipartUploadsRequest* uploads = [QCloudListBucketMultipartUploadsRequest new];
    uploads.bucket = @"bucket-cssg-test-1253653367";
    uploads.maxUploads = 100;
    
    [uploads setFinishBlock:^(QCloudListMultipartUploadsResult* result, NSError *error) {
        //可以从 result 中返回分片信息
        XCTAssertNil(error);
        [exp fulfill];
    }];
    
    [[QCloudCOSXMLService defaultCOSXML] ListBucketMultipartUploads:uploads];
    [self waitForExpectationsWithTimeout:80 handler:nil];
}

- (void)UploadPart {
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
    XCTestExpectation* exp = [self expectationWithDescription:@"upload-part"];
    QCloudUploadPartRequest* request = [QCloudUploadPartRequest new];
    request.bucket = @"bucket-cssg-test-1253653367";
    request.object = @"object4iOS";
    request.partNumber = 1;
    //标识本次分块上传的 ID；使用 Initiate Multipart Upload 接口初始化分块上传时会得到一个 uploadId
    // 该 ID 不但唯一标识这一分块数据，也标识了这分块数据在整个文件内的相对位置
    request.uploadId = @"example-uploadId";
    request.uploadId = self.uploadId;
    //上传的数据：支持NSData*，NSURL(本地url)和QCloudFileOffsetBody *三种类型
    request.body = [@"testFileContent" dataUsingEncoding:NSUTF8StringEncoding];
    
    [request setSendProcessBlock:^(int64_t bytesSent,
                                   int64_t totalBytesSent,
                                   int64_t totalBytesExpectedToSend) {
        // 上传进度信息
    }];
    [request setFinishBlock:^(QCloudUploadPartResult* outputObject, NSError *error) {
        XCTAssertNil(error);
        QCloudMultipartInfo *part = [QCloudMultipartInfo new];
        //获取所上传分片的 etag
        part.eTag = outputObject.eTag;
        part.partNumber = @"1";
        self.parts = [NSMutableArray new];
        [self.parts addObject:part];
        [exp fulfill];
    }];
    
    [[QCloudCOSXMLService defaultCOSXML]  UploadPart:request];
    [self waitForExpectationsWithTimeout:80 handler:nil];
}

- (void)ListParts {
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
    XCTestExpectation* exp = [self expectationWithDescription:@"list-parts"];
    QCloudListMultipartRequest* request = [QCloudListMultipartRequest new];
    request.object = @"object4iOS";
    request.bucket = @"bucket-cssg-test-1253653367";
    // 在初始化分块上传的响应中，会返回一个唯一的描述符（upload ID）
    request.uploadId = @"example-uploadId"; 
    request.uploadId = self.uploadId;
    
    [request setFinishBlock:^(QCloudListPartsResult * _Nonnull result,
                              NSError * _Nonnull error) {
        //从 result 中获取已上传分片信息
        XCTAssertNil(error);
        [exp fulfill];
    }];
    
    [[QCloudCOSXMLService defaultCOSXML] ListMultipart:request];
    [self waitForExpectationsWithTimeout:80 handler:nil];
}

- (void)CompleteMultiUpload {
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
    XCTestExpectation* exp = [self expectationWithDescription:@"complete-multi-upload"];
    QCloudCompleteMultipartUploadRequest *completeRequst = [QCloudCompleteMultipartUploadRequest new];
    completeRequst.object = @"object4iOS";
    completeRequst.bucket = @"bucket-cssg-test-1253653367";
    //本次要查询的分块上传的uploadId,可从初始化分块上传的请求结果QCloudInitiateMultipartUploadResult中得到
    completeRequst.uploadId = @"example-uploadId";
    completeRequst.uploadId = self.uploadId;
    // 已上传分片的信息
    QCloudCompleteMultipartUploadInfo *partInfo = [QCloudCompleteMultipartUploadInfo new];
    partInfo.parts = self.parts;
    completeRequst.parts = partInfo;
    
    [completeRequst setFinishBlock:^(QCloudUploadObjectResult * _Nonnull result, 
        NSError * _Nonnull error) {
        //从 result 中获取上传结果
        XCTAssertNil(error);
        [exp fulfill];
    }];
    
    [[QCloudCOSXMLService defaultCOSXML] CompleteMultipartUpload:completeRequst];
    [self waitForExpectationsWithTimeout:80 handler:nil];
}

- (void)AbortMultiUpload {
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
    XCTestExpectation* exp = [self expectationWithDescription:@"abort-multi-upload"];
    QCloudAbortMultipfartUploadRequest *abortRequest = [QCloudAbortMultipfartUploadRequest new];
    abortRequest.object = @"object4iOS";
    abortRequest.bucket = @"bucket-cssg-test-1253653367";
    //本次要查询的分块上传的uploadId,可从初始化分块上传的请求结果QCloudInitiateMultipartUploadResult中得到
    abortRequest.uploadId = @"example-uploadId";
    abortRequest.uploadId = self.uploadId;
    
    [abortRequest setFinishBlock:^(id outputObject, NSError *error) {
        //可以从 outputObject 中获取 response 中 etag 或者自定义头部等信息
        XCTAssertNotNil(error);
        [exp fulfill];
    }];
    
    [[QCloudCOSXMLService defaultCOSXML]AbortMultipfartUpload:abortRequest];
    [self waitForExpectationsWithTimeout:80 handler:nil];
}


- (void)testObjectMultiUpload {
    [self InitMultiUpload];
    [self ListMultiUpload];
    [self UploadPart];
    [self ListParts];
    [self CompleteMultiUpload];
    [self AbortMultiUpload];
}

@end