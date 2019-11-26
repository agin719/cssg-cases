#import <XCTest/XCTest.h>
#import <QCloudCOSXML/QCloudCOSXML.h>
#import <SecretStorage.h>
#import <QCloudCOSXML/QCloudUploadPartRequest.h>
#import <QCloudCOSXML/QCloudCompleteMultipartUploadRequest.h>
#import <QCloudCOSXML/QCloudAbortMultipfartUploadRequest.h>
#import <QCloudCOSXML/QCloudMultipartInfo.h>
#import <QCloudCOSXML/QCloudCompleteMultipartUploadInfo.h>

@interface ObjectCopyTest : XCTestCase <QCloudSignatureProvider>

@property (nonatomic) NSString* uploadId;
@property (nonatomic) NSMutableArray<QCloudMultipartInfo *> *parts;

@end

@implementation ObjectCopyTest

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

- (void)CopyObject {
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
    XCTestExpectation* exp = [self expectationWithDescription:@"copy-object"];
    QCloudPutObjectCopyRequest* request = [[QCloudPutObjectCopyRequest alloc] init];
    request.bucket = @"bucket-cssg-test-1253653367";
    request.object = @"object4iOS";
    //源对象所在的路径
    request.objectCopySource = @"bucket-cssg-test-1253653367.cos.ap-guangzhou.myqcloud.com/sourceObject";
    [request setFinishBlock:^(QCloudCopyObjectResult * _Nonnull result, NSError * _Nonnull error) {
        // result 返回具体信息
        XCTAssertNil(error);
        [exp fulfill];
    }];
    [[QCloudCOSXMLService defaultCOSXML]  PutObjectCopy:request];
    [self waitForExpectationsWithTimeout:80 handler:nil];
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

- (void)UploadPartCopy {
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
    XCTestExpectation* exp = [self expectationWithDescription:@"upload-part-copy"];
    QCloudUploadPartCopyRequest* request = [[QCloudUploadPartCopyRequest alloc] init];
    request.bucket = @"bucket-cssg-test-1253653367";
    request.object = @"object4iOS";
    //  源文件 URL 路径，可以通过 versionid 子资源指定历史版本
    request.source = @"bucket-cssg-test-1253653367.cos.ap-guangzhou.myqcloud.com/sourceObject"; 
    // 在初始化分块上传的响应中，会返回一个唯一的描述符（upload ID）
    request.uploadID = @"example-uploadId"; 
    request.uploadID = self.uploadId; 
    request.partNumber = 1; // 标志当前分块的序号
    
    [request setFinishBlock:^(QCloudCopyObjectResult* result, NSError* error) {
        XCTAssertNil(error);
        QCloudMultipartInfo *part = [QCloudMultipartInfo new];
        //获取所复制分片的 etag
        part.eTag = result.eTag;
        part.partNumber = @"1";
        self.parts = [NSMutableArray new];
        [self.parts addObject:part];
        [exp fulfill];
    }];
    
    [[QCloudCOSXMLService defaultCOSXML]UploadPartCopy:request];
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


- (void)testObjectCopy {
    [self CopyObject];
    [self InitMultiUpload];
    [self UploadPartCopy];
    [self CompleteMultiUpload];
}

@end