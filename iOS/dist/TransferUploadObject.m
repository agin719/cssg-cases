#import <XCTest/XCTest.h>
#import <QCloudCOSXML/QCloudCOSXML.h>
#import <SecretStorage.h>
#import <QCloudCOSXML/QCloudUploadPartRequest.h>
#import <QCloudCOSXML/QCloudCompleteMultipartUploadRequest.h>
#import <QCloudCOSXML/QCloudAbortMultipfartUploadRequest.h>
#import <QCloudCOSXML/QCloudMultipartInfo.h>
#import <QCloudCOSXML/QCloudCompleteMultipartUploadInfo.h>

@interface TransferUploadObjectTest : XCTestCase <QCloudSignatureProvider>
@property (nonatomic) NSString* uploadId;
@property (nonatomic) NSMutableArray<QCloudMultipartInfo *> *parts;
@end

@implementation TransferUploadObjectTest

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

- (void)TransferUploadObject {
    XCTestExpectation* exp = [self expectationWithDescription:@"transfer-upload-object"];
    QCloudCOSXMLUploadObjectRequest* put = [QCloudCOSXMLUploadObjectRequest new];
    put.object = @"object4ios";
    put.bucket = @"bucket-cssg-test-1253653367";
    put.body = [@"testFileContent" dataUsingEncoding:NSUTF8StringEncoding];
    //设置一些上传的参数
    put.initMultipleUploadFinishBlock = ^(QCloudInitiateMultipartUploadResult * multipleUploadInitResult, 
        QCloudCOSXMLUploadObjectResumeData resumeData) {
        //在初始化分块上传完成以后会回调该block，在这里可以获取 resumeData，
        //并且可以通过 resumeData 生成一个分块上传的请求
        QCloudCOSXMLUploadObjectRequest* request = [QCloudCOSXMLUploadObjectRequest 
            requestWithRequestData:resumeData];
    };
    [put setSendProcessBlock:^(int64_t bytesSent, int64_t totalBytesSent, 
        int64_t totalBytesExpectedToSend) {
        NSLog(@"upload %lld totalSend %lld aim %lld", bytesSent, totalBytesSent, 
            totalBytesExpectedToSend);
    }];
    [put setFinishBlock:^(id outputObject, NSError* error) {
        //可以从 outputObject 中获取 response 中 etag 或者自定义头部等信息
        XCTAssertNotNil(error);
        [exp fulfill];
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

- (void)testTransferUploadObject {
    [self TransferUploadObject];
}

@end
