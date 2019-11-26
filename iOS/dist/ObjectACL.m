#import <XCTest/XCTest.h>
#import <QCloudCOSXML/QCloudCOSXML.h>
#import <SecretStorage.h>
#import <QCloudCOSXML/QCloudUploadPartRequest.h>
#import <QCloudCOSXML/QCloudCompleteMultipartUploadRequest.h>
#import <QCloudCOSXML/QCloudAbortMultipfartUploadRequest.h>
#import <QCloudCOSXML/QCloudMultipartInfo.h>
#import <QCloudCOSXML/QCloudCompleteMultipartUploadInfo.h>

@interface ObjectACLTest : XCTestCase <QCloudSignatureProvider>

@property (nonatomic) NSString* uploadId;
@property (nonatomic) NSMutableArray<QCloudMultipartInfo *> *parts;

@end

@implementation ObjectACLTest

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

- (void)PutObject {
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
    XCTestExpectation* exp = [self expectationWithDescription:@"put-object"];
    QCloudPutObjectRequest* put = [QCloudPutObjectRequest new];
    put.object = @"object4iOS";
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

- (void)PutObjectAcl {
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
    XCTestExpectation* exp = [self expectationWithDescription:@"put-object-acl"];
    QCloudPutObjectACLRequest* request = [QCloudPutObjectACLRequest new];
    request.object = @"object4iOS";
    request.bucket = @"bucket-cssg-test-1253653367";
    NSString *grantString = [NSString stringWithFormat:@"id=\"%@\"",@"1253653367"];
    request.grantFullControl = grantString;
    [request setFinishBlock:^(id outputObject, NSError *error) {
        //可以从 outputObject 中获取 response 中 etag 或者自定义头部等信息
        XCTAssertNil(error);
        [exp fulfill];
    }];
    
    [[QCloudCOSXMLService defaultCOSXML] PutObjectACL:request];
    [self waitForExpectationsWithTimeout:80 handler:nil];
}

- (void)GetObjectAcl {
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
    XCTestExpectation* exp = [self expectationWithDescription:@"get-object-acl"];
    QCloudGetObjectACLRequest *request = [QCloudGetObjectACLRequest new];
    request.object = @"object4iOS";
    request.bucket = @"bucket-cssg-test-1253653367";
    __block QCloudACLPolicy* policy;
    [request setFinishBlock:^(QCloudACLPolicy * _Nonnull result, NSError * _Nonnull error) {
        policy = result;
        XCTAssertNil(error);
        [exp fulfill];
    }];
    
    [[QCloudCOSXMLService defaultCOSXML] GetObjectACL:request];
    [self waitForExpectationsWithTimeout:80 handler:nil];
}


- (void)testObjectACL {
    [self PutObject];
    [self PutObjectAcl];
    [self GetObjectAcl];
}

@end