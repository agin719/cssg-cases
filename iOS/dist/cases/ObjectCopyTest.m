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

- (void)CopyObject {
    XCTestExpectation* exp = [self expectationWithDescription:@"CopyObject"];
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

- (void)UploadPartCopy {
    XCTestExpectation* exp = [self expectationWithDescription:@"UploadPartCopy"];
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

- (void)testObjectCopy {
    [self CopyObject];
    [self InitMultiUpload];
    [self UploadPartCopy];
    [self CompleteMultiUpload];
}

@end
