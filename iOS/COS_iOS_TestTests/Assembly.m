//
//  Assembly.m
//
//  Copyright © 2019 tencentyun.com. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <QCloudCOSXML/QCloudCOSXML.h>
#import <SecretStorage.h>
#import <QCloudCOSXML/QCloudUploadPartRequest.h>
#import <QCloudCOSXML/QCloudCompleteMultipartUploadRequest.h>
#import <QCloudCOSXML/QCloudAbortMultipfartUploadRequest.h>
#import <QCloudCOSXML/QCloudCompleteMultipartUploadInfo.h>
#import <QCloudCOSXML/QCloudMultipartInfo.h>
#import <QCloudCOSXML/QCloudCompleteMultipartUploadInfo.h>

// cssg-snippet-lang: [iOS]
@interface Assembly : XCTestCase <QCloudSignatureProvider>

@property (nonatomic) QCloudCredentailFenceQueue* credentialFenceQueue;

@property (nonatomic) NSString* uploadId;
@property (nonatomic) NSMutableArray<QCloudMultipartInfo *> *parts;

@end

@implementation Assembly

// .cssg-body-start: [global-init]
//AppDelegate.m
//第一步：注册默认的cos服务
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    QCloudServiceConfiguration* configuration = [QCloudServiceConfiguration new];
    configuration.appID = @"{{appId}}";
    configuration.signatureProvider = self;
    QCloudCOSXMLEndPoint* endpoint = [[QCloudCOSXMLEndPoint alloc] init];
    endpoint.regionName = @"{{region}}";//服务地域名称，可用的地域请参考注释
    configuration.endpoint = endpoint;
    [QCloudCOSXMLService registerDefaultCOSXMLWithConfiguration:configuration];
    [QCloudCOSTransferMangerService registerDefaultCOSTransferMangerWithConfiguration:configuration];
    return YES;
}

//第二步：实现QCloudSignatureProvider协议
//实现签名的过程，我们推荐在服务器端实现签名的过程，具体请参考接下来的 “生成签名” 这一章。
// .cssg-body-end

// .cssg-body-start: [global-init-fence-queue]
//AppDelegate.m

// 这里定义一个成员变量 @property (nonatomic) QCloudCredentailFenceQueue* credentialFenceQueue;

- (void) fenceQueue:(QCloudCredentailFenceQueue * )queue requestCreatorWithContinue:(QCloudCredentailFenceQueueContinue)continueBlock
{
    QCloudCredential* credential = [QCloudCredential new];
    //在这里可以同步过程从服务器获取临时签名需要的secretID,secretKey,expiretionDate和token参数
    credential.secretID = @"COS_SECRETID";
    credential.secretKey = @"COS_SECRETKEY";
    /*强烈建议返回服务器时间作为签名的开始时间，用来避免由于用户手机本地时间偏差过大导致的签名不正确 */
    credential.startDate = [[[NSDateFormatter alloc] init] dateFromString:@"start-time"];
    credential.experationDate = [[[NSDateFormatter alloc] init] dateFromString:@"expire-time"];
    credential.token = @"COS_TOKEN";
    QCloudAuthentationV5Creator* creator = [[QCloudAuthentationV5Creator alloc] 
        initWithCredential:credential];
    continueBlock(creator, nil);
}

- (void) signatureWithFields:(QCloudSignatureFields*)fileds
                     request:(QCloudBizHTTPRequest*)request
                  urlRequest:(NSMutableURLRequest*)urlRequst
                   compelete:(QCloudHTTPAuthentationContinueBlock)continueBlock
{
    [self.credentialFenceQueue performAction:^(QCloudAuthentationCreator *creator, NSError *error) {
        if (error) {
            continueBlock(nil, error);
        } else {
            QCloudSignature* signature =  [creator signatureForData:urlRequst];
            continueBlock(signature, nil);
        }
    }];
}
// .cssg-body-end

- (void)method1 {
    // .cssg-body-start: [get-service]
    XCTestExpectation* exp = [self expectationWithDescription:@"get-service"];
    QCloudGetServiceRequest* request = [[QCloudGetServiceRequest alloc] init];
    [request setFinishBlock:^(QCloudListAllMyBucketsResult* result, NSError* error) {
        //从result中获取返回信息
        XCTAssertNil(error);
        [exp fulfill];
    }];
    [[QCloudCOSXMLService defaultCOSXML] GetService:request];
    [self waitForExpectationsWithTimeout:80 handler:nil];
    // .cssg-body-end
}

- (void)method2 {
    // .cssg-body-start: [put-bucket]
    XCTestExpectation* exp = [self expectationWithDescription:@"put-bucket"];
    QCloudPutBucketRequest* request = [QCloudPutBucketRequest new];
    request.bucket = @"{{tempBucket}}"; //additional actions after finishing
    [request setFinishBlock:^(id outputObject, NSError* error) {
        //可以从 outputObject 中获取服务器返回的 header 信息
        XCTAssertNil(error);
        [exp fulfill];
    }];
    [[QCloudCOSXMLService defaultCOSXML] PutBucket:request];
    [self waitForExpectationsWithTimeout:80 handler:nil];
    // .cssg-body-end
}

- (void)method3 {
    // .cssg-body-start: [head-bucket]
    XCTestExpectation* exp = [self expectationWithDescription:@"head-bucket"];
    QCloudHeadBucketRequest* request = [QCloudHeadBucketRequest new];
    request.bucket = @"{{tempBucket}}";
    [request setFinishBlock:^(id outputObject, NSError* error) {
        //可以从 outputObject 中获取服务器返回的header信息
        XCTAssertNil(error);
        [exp fulfill];
    }];
    [[QCloudCOSXMLService defaultCOSXML] HeadBucket:request];
    [self waitForExpectationsWithTimeout:80 handler:nil];
    // .cssg-body-end
}

- (void)method4 {
    // .cssg-body-start: [delete-bucket]
    XCTestExpectation* exp = [self expectationWithDescription:@"delete-bucket"];
    QCloudDeleteBucketRequest* request = [[QCloudDeleteBucketRequest alloc ] init];
    request.bucket = @"{{tempBucket}}";  //存储桶名称，命名格式：BucketName-APPID
    [request setFinishBlock:^(id outputObject,NSError*error) {
        //可以从 outputObject 中获取服务器返回的header信息
        XCTAssertNil(error);
        [exp fulfill];
    }];
    [[QCloudCOSXMLService defaultCOSXML] DeleteBucket:request];
    [self waitForExpectationsWithTimeout:80 handler:nil];
    // .cssg-body-end
}

- (void)method5 {
    // .cssg-body-start: [put-bucket-acl]
    XCTestExpectation* exp = [self expectationWithDescription:@"put-bucket-acl"];
    QCloudPutBucketACLRequest* putACL = [QCloudPutBucketACLRequest new];
    NSString* appID = @"1131975903";//您的AppID
    NSString *ownerIdentifier = [NSString stringWithFormat:@"qcs::cam::uin/%@:uin/%@", appID,
        appID];
    NSString *grantString = [NSString stringWithFormat:@"id=\"%@\"",ownerIdentifier];
    putACL.grantFullControl = grantString;
    putACL.bucket = @"{{tempBucket}}";
    [putACL setFinishBlock:^(id outputObject, NSError *error) {
        //可以从 outputObject 中获取服务器返回的header信息
        XCTAssertNil(error);
        [exp fulfill];
    }];

    [[QCloudCOSXMLService defaultCOSXML] PutBucketACL:putACL];
    [self waitForExpectationsWithTimeout:80 handler:nil];
    // .cssg-body-end
}

- (void)method6 {
    // .cssg-body-start: [get-bucket-acl]
    XCTestExpectation* exp = [self expectationWithDescription:@"get-bucket-acl"];
    QCloudGetBucketACLRequest* getBucketACl = [QCloudGetBucketACLRequest new];
    getBucketACl.bucket = @"{{tempBucket}}";
    [getBucketACl setFinishBlock:^(QCloudACLPolicy * _Nonnull result, NSError * _Nonnull error) {
        //QCloudACLPolicy中包含了 Bucket 的 ACL 信息。
        XCTAssertNil(error);
        [exp fulfill];
    }];
    
    [[QCloudCOSXMLService defaultCOSXML] GetBucketACL:getBucketACl];
    [self waitForExpectationsWithTimeout:80 handler:nil];
    // .cssg-body-end
}

- (void)method7 {
    // .cssg-body-start: [put-bucket-cors]
    XCTestExpectation* exp = [self expectationWithDescription:@"put-bucket-cors"];
    QCloudPutBucketCORSRequest* putCORS = [QCloudPutBucketCORSRequest new];
    QCloudCORSConfiguration* cors = [QCloudCORSConfiguration new];
    
    QCloudCORSRule* rule = [QCloudCORSRule new];
    rule.identifier = @"sdk";
    rule.allowedHeader = @[@"origin",@"host",@"accept",@"content-type",@"authorization"];
    rule.exposeHeader = @"ETag";
    rule.allowedMethod = @[@"GET",@"PUT",@"POST", @"DELETE", @"HEAD"];
    rule.maxAgeSeconds = 3600;
    rule.allowedOrigin = @"http://cloud.tencent.com";
    cors.rules = @[rule];
    putCORS.corsConfiguration = cors;
    putCORS.bucket = @"{{tempBucket}}";
    [putCORS setFinishBlock:^(id outputObject, NSError *error) {
        //可以从 outputObject 中获取服务器返回的header信息
        XCTAssertNil(error);
        [exp fulfill];
    }];

    [[QCloudCOSXMLService defaultCOSXML] PutBucketCORS:putCORS];
    [self waitForExpectationsWithTimeout:80 handler:nil];
    // .cssg-body-end
}

- (void)method8 {
    // .cssg-body-start: [get-bucket-cors]
    XCTestExpectation* exp = [self expectationWithDescription:@"get-bucket-cors"];
    QCloudGetBucketCORSRequest* corsReqeust = [QCloudGetBucketCORSRequest new];
    corsReqeust.bucket = @"{{tempBucket}}";
    
    [corsReqeust setFinishBlock:^(QCloudCORSConfiguration * _Nonnull result, NSError * _Nonnull error) {
        //CORS设置封装在result中。
        XCTAssertNil(error);
        [exp fulfill];
    }];
    
    [[QCloudCOSXMLService defaultCOSXML] GetBucketCORS:corsReqeust];
    [self waitForExpectationsWithTimeout:80 handler:nil];
    // .cssg-body-end
}

- (void)method9 {
    // .cssg-body-start: [delete-bucket-cors]
    XCTestExpectation* exp = [self expectationWithDescription:@"delete-bucket-cors"];
    QCloudDeleteBucketCORSRequest* deleteCORS = [QCloudDeleteBucketCORSRequest new];
    deleteCORS.bucket = @"{{tempBucket}}";
    [deleteCORS setFinishBlock:^(id outputObject, NSError *error) {
        //可以从 outputObject 中获取服务器返回的header信息
        XCTAssertNil(error);
        [exp fulfill];
    }];
    [[QCloudCOSXMLService defaultCOSXML] DeleteBucketCORS:deleteCORS];
    [self waitForExpectationsWithTimeout:80 handler:nil];
    // .cssg-body-end
}

- (void)method10 {
    // .cssg-body-start: [put-bucket-lifecycle]
    XCTestExpectation* exp = [self expectationWithDescription:@"put-bucket-lifecycle"];
    QCloudPutBucketLifecycleRequest* request = [QCloudPutBucketLifecycleRequest new];
    request.bucket = @"{{tempBucket}}";
    __block QCloudLifecycleConfiguration* lifecycleConfiguration = [[QCloudLifecycleConfiguration 
        alloc] init];
    QCloudLifecycleRule* rule = [[QCloudLifecycleRule alloc] init];
    rule.identifier = @"identifier";
    rule.status = QCloudLifecycleStatueEnabled;
    QCloudLifecycleRuleFilter* filter = [[QCloudLifecycleRuleFilter alloc] init];
    filter.prefix = @"0";
    rule.filter = filter;
    
    QCloudLifecycleTransition* transition = [[QCloudLifecycleTransition alloc] init];
    transition.days = 100;
    transition.storageClass = QCloudCOSStorageStandardIA;
    rule.transition = transition;
    request.lifeCycle = lifecycleConfiguration;
    request.lifeCycle.rules = @[rule];
    [request setFinishBlock:^(id outputObject, NSError* error) {
        //可以从 outputObject 中获取服务器返回的header信息
        XCTAssertNil(error);
        [exp fulfill];
    }];

    [[QCloudCOSXMLService defaultCOSXML] PutBucketLifecycle:request];
    [self waitForExpectationsWithTimeout:80 handler:nil];
    // .cssg-body-end
}

- (void)method11 {
    // .cssg-body-start: [get-bucket-lifecycle]
    XCTestExpectation* exp = [self expectationWithDescription:@"get-bucket-lifecycle"];
    QCloudGetBucketLifecycleRequest* request = [QCloudGetBucketLifecycleRequest new];
    request.bucket = @"{{tempBucket}}";
    [request setFinishBlock:^(QCloudLifecycleConfiguration* result,NSError* error) {
        // 可以从 result 中获取返回信息
        XCTAssertNil(error);
        [exp fulfill];
    }];
    [[QCloudCOSXMLService defaultCOSXML] GetBucketLifecycle:request];
    [self waitForExpectationsWithTimeout:80 handler:nil];
    // .cssg-body-end
}

- (void)method12 {
    // .cssg-body-start: [delete-bucket-lifecycle]
    XCTestExpectation* exp = [self expectationWithDescription:@"delete-bucket-lifecycle"];
    QCloudDeleteBucketLifeCycleRequest* request = [[QCloudDeleteBucketLifeCycleRequest alloc ] init];
    request.bucket = @"{{tempBucket}}";
    [request setFinishBlock:^(QCloudLifecycleConfiguration* deleteResult, NSError* deleteError) {
        // deleteResult 返回删除结果
        XCTAssertNil(deleteError);
        [exp fulfill];
    }];
    [[QCloudCOSXMLService defaultCOSXML] DeleteBucketLifeCycle:request];
    [self waitForExpectationsWithTimeout:80 handler:nil];
    // .cssg-body-end
}

- (void)method13 {
    // .cssg-body-start: [put-bucket-versioning]
    XCTestExpectation* exp = [self expectationWithDescription:@"put-bucket-versioning"];
    // 开启版本控制
    QCloudPutBucketVersioningRequest* request = [[QCloudPutBucketVersioningRequest alloc] init];
    request.bucket =@"{{tempBucket}}";
    QCloudBucketVersioningConfiguration* versioningConfiguration = 
        [[QCloudBucketVersioningConfiguration alloc] init];
    request.configuration = versioningConfiguration;
    versioningConfiguration.status = QCloudCOSBucketVersioningStatusEnabled;
    
    [request setFinishBlock:^(id outputObject, NSError* error) {
        //可以从 outputObject 中获取服务器返回的header信息
        XCTAssertNil(error);
        [exp fulfill];
    }];
    [[QCloudCOSXMLService defaultCOSXML] PutBucketVersioning:request];
    [self waitForExpectationsWithTimeout:80 handler:nil];
    // .cssg-body-end
}

- (void)method14 {
    // .cssg-body-start: [get-bucket-versioning]
    XCTestExpectation* exp = [self expectationWithDescription:@"get-bucket-versioning"];
    QCloudGetBucketVersioningRequest* request = [[QCloudGetBucketVersioningRequest alloc] init];
    request.bucket = @"{{tempBucket}}";
    [request setFinishBlock:^(QCloudBucketVersioningConfiguration* result, NSError* error) {
        //可以从 result 中获取返回信息
        XCTAssertNil(error);
        [exp fulfill];
    }];

    [[QCloudCOSXMLService defaultCOSXML] GetBucketVersioning:request];
    [self waitForExpectationsWithTimeout:80 handler:nil];
    // .cssg-body-end
}

- (void)method15 {
    // .cssg-body-start: [put-bucket-replication]
    XCTestExpectation* exp = [self expectationWithDescription:@"put-bucket-replication"];
    QCloudPutBucketReplicationRequest* request = [[QCloudPutBucketReplicationRequest alloc] init];
    request.bucket = @"{{tempBucket}}";
    QCloudBucketReplicationConfiguation* replConfiguration = [[QCloudBucketReplicationConfiguation 
        alloc] init];
    replConfiguration.role = @"qcs::cam::uin/{{uin}}:uin/{{uin}}";
    QCloudBucketReplicationRule* rule = [[QCloudBucketReplicationRule alloc] init];
    
    rule.identifier = @"identifier";
    rule.status = QCloudCOSXMLStatusEnabled;
    
    QCloudBucketReplicationDestination* destination = [[QCloudBucketReplicationDestination alloc] init];
    NSString* destinationBucket = @"{{{replicationDestBucket}}}";
    NSString* region = @"{{replicationDestBucketRegion}}";
    destination.bucket = [NSString stringWithFormat:@"qcs::cos:%@::%@",region,destinationBucket];
    rule.destination = destination;
    rule.prefix = @"a";
    replConfiguration.rule = @[rule];
    request.configuation = replConfiguration;

    [request setFinishBlock:^(id outputObject, NSError* error) {
        //可以从 outputObject 中获取服务器返回的header信息
        XCTAssertNil(error);
        [exp fulfill];
    }];
    [[QCloudCOSXMLService defaultCOSXML] PutBucketRelication:request];
    [self waitForExpectationsWithTimeout:80 handler:nil];
    // .cssg-body-end
}

- (void)method16 {
    // .cssg-body-start: [get-bucket-replication]
    XCTestExpectation* exp = [self expectationWithDescription:@"get-bucket-replication"];
    QCloudGetBucketReplicationRequest* request = [[QCloudGetBucketReplicationRequest alloc] init];
    request.bucket = @"{{tempBucket}}";

    [request setFinishBlock:^(QCloudBucketReplicationConfiguation* result, NSError* error) {
        //可以从 result 中获取返回信息
        XCTAssertNil(error);
        [exp fulfill];
    }];
    [[QCloudCOSXMLService defaultCOSXML] GetBucketReplication:request];
    [self waitForExpectationsWithTimeout:80 handler:nil];
    // .cssg-body-end
}

- (void)method17 {
    // .cssg-body-start: [delete-bucket-replication]
    XCTestExpectation* exp = [self expectationWithDescription:@"delete-bucket-replication"];
    QCloudDeleteBucketReplicationRequest* request = [[QCloudDeleteBucketReplicationRequest alloc] init];
    request.bucket = @"{{tempBucket}}";

    [request setFinishBlock:^(id outputObject, NSError* error) {
        //可以从 outputObject 中获取服务器返回的header信息
        XCTAssertNil(error);
        [exp fulfill];
    }];
    [[QCloudCOSXMLService defaultCOSXML] DeleteBucketReplication:request];
    [self waitForExpectationsWithTimeout:80 handler:nil];
    // .cssg-body-end
}

- (void)method18 {
    // .cssg-body-start: [transfer-upload-object]
    XCTestExpectation* exp = [self expectationWithDescription:@"transfer-upload-object"];
    QCloudCOSXMLUploadObjectRequest* put = [QCloudCOSXMLUploadObjectRequest new];
    put.object = @"{{object}}";
    put.bucket = @"{{persistBucket}}";
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
    // .cssg-body-end
}

- (void)method19 {
    // .cssg-body-start: [transfer-copy-object]
    XCTestExpectation* exp = [self expectationWithDescription:@"transfer-copy-object"];
    QCloudCOSXMLCopyObjectRequest* request = [[QCloudCOSXMLCopyObjectRequest alloc] init];

    request.bucket = @"{{persistBucket}}";//目的<BucketName-APPID>，需要是公有读或者在当前账号有权限
    request.object = @"{{object}}";//目的文件名称
    //文件来源<BucketName-APPID>，需要是公有读或者在当前账号有权限
    request.sourceBucket = @"{{{copySourceBucket}}}";
    request.sourceObject = @"{{copySourceObject}}";//源文件名称
    request.sourceAPPID = @"{{appId}}";//源文件的appid
    request.sourceRegion= @"{{region}}";//来源的地域

    [request setFinishBlock:^(QCloudCopyObjectResult* result, NSError* error) {
        //可以从 outputObject 中获取 response 中 etag 或者自定义头部等信息
        XCTAssertNil(error);
        [exp fulfill];
    }];

    //注意如果是跨地域复制，这里使用的 transferManager 所在的 region 必须为目标桶所在的 region
    [[QCloudCOSTransferMangerService defaultCOSTransferManager] CopyObject:request];
    [self waitForExpectationsWithTimeout:80 handler:nil];
    // .cssg-body-end
}

- (void)method20 {
    // .cssg-body-start: [get-bucket]
    XCTestExpectation* exp = [self expectationWithDescription:@"get-bucket"];
    QCloudGetBucketRequest* request = [QCloudGetBucketRequest new];
    request.bucket = @"{{persistBucket}}";
    request.maxKeys = 1000;

    [request setFinishBlock:^(QCloudListBucketResult * result, NSError* error) {
        // result 返回具体信息
        XCTAssertNil(error);
        [exp fulfill];
    }];

    [[QCloudCOSXMLService defaultCOSXML] GetBucket:request];
    [self waitForExpectationsWithTimeout:80 handler:nil];
    // .cssg-body-end
}

- (void)method21 {
    // .cssg-body-start: [put-object]
    XCTestExpectation* exp = [self expectationWithDescription:@"put-object"];
    QCloudPutObjectRequest* put = [QCloudPutObjectRequest new];
    put.object = @"{{object}}";
    put.bucket = @"{{persistBucket}}";
    put.body =  [@"testFileContent" dataUsingEncoding:NSUTF8StringEncoding];

    [put setFinishBlock:^(id outputObject, NSError *error) {
        //可以从 outputObject 中获取 response 中 etag 或者自定义头部等信息
        XCTAssertNil(error);
        [exp fulfill];
    }];

    [[QCloudCOSXMLService defaultCOSXML] PutObject:put];
    [self waitForExpectationsWithTimeout:80 handler:nil];
    // .cssg-body-end
}

- (void)method22 {
    // .cssg-body-start: [head-object]
    XCTestExpectation* exp = [self expectationWithDescription:@"head-object"];
    QCloudHeadObjectRequest* headerRequest = [QCloudHeadObjectRequest new];
    headerRequest.object = @"{{object}}";
    headerRequest.bucket = @"{{persistBucket}}";
    
    [headerRequest setFinishBlock:^(NSDictionary* result, NSError *error) {
        // result 返回具体信息
        XCTAssertNil(error);
        [exp fulfill];
    }];

    [[QCloudCOSXMLService defaultCOSXML] HeadObject:headerRequest];
    [self waitForExpectationsWithTimeout:80 handler:nil];
    // .cssg-body-end
}

- (void)method23 {
    // .cssg-body-start: [get-object]
    XCTestExpectation* exp = [self expectationWithDescription:@"get-object"];
    QCloudGetObjectRequest* request = [QCloudGetObjectRequest new];
    //设置下载的路径 URL，如果设置了，文件将会被下载到指定路径中。
    // 如果该参数没有设置，那么文件将会被下载至内存里，存放在在 finishBlock 的 	outputObject 里。
    request.downloadingURL = [NSURL URLWithString:QCloudTempFilePathWithExtension(@"downding")];
    request.object = @"{{object}}";
    request.bucket = @"{{persistBucket}}";

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
    // .cssg-body-end
}

- (void)method24 {
    // .cssg-body-start: [option-object]
    XCTestExpectation* exp = [self expectationWithDescription:@"option-object"];
    QCloudOptionsObjectRequest* request = [[QCloudOptionsObjectRequest alloc] init];
    request.bucket =@"{{tempBucket}}";
    request.origin = @"http://cloud.tencent.com";
    request.accessControlRequestMethod = @"GET";
    request.accessControlRequestHeaders = @"host";
    request.object = @"{{object}}";

    [request setFinishBlock:^(id outputObject, NSError* error) {
        //可以从 outputObject 中获取 response 中 etag 或者自定义头部等信息
        XCTAssertNil(error);
        [exp fulfill];
    }];
    
    [[QCloudCOSXMLService defaultCOSXML] OptionsObject:request];
    [self waitForExpectationsWithTimeout:80 handler:nil];
    // .cssg-body-end
}

- (void)method25 {
    // .cssg-body-start: [copy-object]
    XCTestExpectation* exp = [self expectationWithDescription:@"copy-object"];
    QCloudPutObjectCopyRequest* request = [[QCloudPutObjectCopyRequest alloc] init];
    request.bucket = @"{{persistBucket}}";
    request.object = @"{{object}}";
    //源对象所在的路径
    request.objectCopySource = @"{{{copySourceBucket}}}.cos.{{region}}.myqcloud.com/{{copySourceObject}}";
    [request setFinishBlock:^(QCloudCopyObjectResult * _Nonnull result, NSError * _Nonnull error) {
        // result 返回具体信息
        XCTAssertNil(error);
        [exp fulfill];
    }];
    [[QCloudCOSXMLService defaultCOSXML]  PutObjectCopy:request];
    [self waitForExpectationsWithTimeout:80 handler:nil];
    // .cssg-body-end
}

- (void)method26 {
    // .cssg-body-start: [delete-object]
    XCTestExpectation* exp = [self expectationWithDescription:@"delete-object"];
    QCloudDeleteObjectRequest* deleteObjectRequest = [QCloudDeleteObjectRequest new];
    deleteObjectRequest.bucket = @"{{persistBucket}}";
    deleteObjectRequest.object = @"{{object}}";

    [deleteObjectRequest setFinishBlock:^(id outputObject, NSError *error) {
        //可以从 outputObject 中获取 response 中 etag 或者自定义头部等信息
        XCTAssertNil(error);
        [exp fulfill];
    }];

    [[QCloudCOSXMLService defaultCOSXML] DeleteObject:deleteObjectRequest];
    [self waitForExpectationsWithTimeout:80 handler:nil];
    // .cssg-body-end
}

- (void)method27 {
    // .cssg-body-start: [delete-multi-object]
    XCTestExpectation* exp = [self expectationWithDescription:@"delete-multi-object"];
    QCloudDeleteMultipleObjectRequest* delteRequest = [QCloudDeleteMultipleObjectRequest new];
    delteRequest.bucket = @"{{persistBucket}}";
    
    QCloudDeleteObjectInfo* deletedObject0 = [QCloudDeleteObjectInfo new];
    deletedObject0.key = @"{{object}}";
    
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
    // .cssg-body-end
}

- (void)method28 {
    // .cssg-body-start: [list-multi-upload]
    XCTestExpectation* exp = [self expectationWithDescription:@"list-multi-upload"];
    QCloudListBucketMultipartUploadsRequest* uploads = [QCloudListBucketMultipartUploadsRequest new];
    uploads.bucket = @"{{persistBucket}}";
    uploads.maxUploads = 100;

    [uploads setFinishBlock:^(QCloudListMultipartUploadsResult* result, NSError *error) {
        //可以从 result 中返回分片信息
        XCTAssertNil(error);
        [exp fulfill];
    }];

    [[QCloudCOSXMLService defaultCOSXML] ListBucketMultipartUploads:uploads];
    [self waitForExpectationsWithTimeout:80 handler:nil];
    // .cssg-body-end
}

- (void)method29 {
    // .cssg-body-start: [init-multi-upload]
    XCTestExpectation* exp = [self expectationWithDescription:@"init-multi-upload"];
    QCloudInitiateMultipartUploadRequest* initrequest = [QCloudInitiateMultipartUploadRequest new];
    initrequest.bucket = @"{{persistBucket}}";
    initrequest.object = @"{{object}}";

    [initrequest setFinishBlock:^(QCloudInitiateMultipartUploadResult* outputObject, NSError *error) {
        // 获取分片上传的 uploadId，后续的上传都需要这个 id，请保存起来后续使用
        self.uploadId = outputObject.uploadId;
        XCTAssertNil(error);
        [exp fulfill];
    }];

    [[QCloudCOSXMLService defaultCOSXML] InitiateMultipartUpload:initrequest];
    [self waitForExpectationsWithTimeout:80 handler:nil];
    // .cssg-body-end
}

- (void)method30 {
    // .cssg-body-start: [upload-part]
    XCTestExpectation* exp = [self expectationWithDescription:@"upload-part"];
    QCloudUploadPartRequest* request = [QCloudUploadPartRequest new];
    request.bucket = @"{{persistBucket}}";
    request.object = @"{{object}}";
    request.partNumber = 1;
    //标识本次分块上传的 ID；使用 Initiate Multipart Upload 接口初始化分块上传时会得到一个 uploadId
    // 该 ID 不但唯一标识这一分块数据，也标识了这分块数据在整个文件内的相对位置
    request.uploadId = @"{{uploadId}}";
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
    // .cssg-body-end
}

- (void)method31 {
    // .cssg-body-start: [upload-part-copy]
    XCTestExpectation* exp = [self expectationWithDescription:@"upload-part-copy"];
    QCloudUploadPartCopyRequest* request = [[QCloudUploadPartCopyRequest alloc] init];
    request.bucket = @"{{persistBucket}}";
    request.object = @"{{object}}";
    //  源文件 URL 路径，可以通过 versionid 子资源指定历史版本
    request.source = @"{{{copySourceBucket}}}.cos.{{region}}.myqcloud.com/{{copySourceObject}}"; 
    // 在初始化分块上传的响应中，会返回一个唯一的描述符（upload ID）
    request.uploadID = @"{{uploadId}}"; 
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
    // .cssg-body-end
}

- (void)method32 {
    // .cssg-body-start: [list-parts]
    XCTestExpectation* exp = [self expectationWithDescription:@"list-parts"];
    QCloudListMultipartRequest* request = [QCloudListMultipartRequest new];
    request.object = @"{{object}}";
    request.bucket = @"{{persistBucket}}";
    // 在初始化分块上传的响应中，会返回一个唯一的描述符（upload ID）
    request.uploadId = @"{{uploadId}}"; 
    request.uploadId = self.uploadId;

    [request setFinishBlock:^(QCloudListPartsResult * _Nonnull result,
                              NSError * _Nonnull error) {
        //从 result 中获取已上传分片信息
        XCTAssertNil(error);
        [exp fulfill];
    }];
    
    [[QCloudCOSXMLService defaultCOSXML] ListMultipart:request];
    [self waitForExpectationsWithTimeout:80 handler:nil];
    // .cssg-body-end
}

- (void)method33 {
    // .cssg-body-start: [complete-multi-upload]
    XCTestExpectation* exp = [self expectationWithDescription:@"complete-multi-upload"];
    QCloudCompleteMultipartUploadRequest *completeRequst = [QCloudCompleteMultipartUploadRequest new];
    completeRequst.object = @"{{object}}";
    completeRequst.bucket = @"{{persistBucket}}";
    //本次要查询的分块上传的uploadId,可从初始化分块上传的请求结果QCloudInitiateMultipartUploadResult中得到
    completeRequst.uploadId = @"{{uploadId}}";
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
    // .cssg-body-end
}

- (void)method34 {
    // .cssg-body-start: [abort-multi-upload]
    XCTestExpectation* exp = [self expectationWithDescription:@"abort-multi-upload"];
    QCloudAbortMultipfartUploadRequest *abortRequest = [QCloudAbortMultipfartUploadRequest new];
    abortRequest.object = @"{{object}}";
    abortRequest.bucket = @"{{persistBucket}}";
    //本次要查询的分块上传的uploadId,可从初始化分块上传的请求结果QCloudInitiateMultipartUploadResult中得到
    abortRequest.uploadId = @"{{uploadId}}";
    abortRequest.uploadId = self.uploadId;

    [abortRequest setFinishBlock:^(id outputObject, NSError *error) {
        //可以从 outputObject 中获取 response 中 etag 或者自定义头部等信息
        XCTAssertNotNil(error);
        [exp fulfill];
    }];

    [[QCloudCOSXMLService defaultCOSXML]AbortMultipfartUpload:abortRequest];
    [self waitForExpectationsWithTimeout:80 handler:nil];
    // .cssg-body-end
}

- (void)method35 {
    // .cssg-body-start: [restore-object]
    XCTestExpectation* exp = [self expectationWithDescription:@"restore-object"];
    QCloudPostObjectRestoreRequest *req = [QCloudPostObjectRestoreRequest new];
    req.bucket = @"{{persistBucket}}";
    req.object = @"{{object}}";
    req.restoreRequest.days  = 10;
    req.restoreRequest.CASJobParameters.tier =QCloudCASTierStandard;

    [req setFinishBlock:^(id outputObject, NSError *error) {
        //可以从 outputObject 中获取 response 中 etag 或者自定义头部等信息
        [exp fulfill];
    }];

    [[QCloudCOSXMLService defaultCOSXML] PostObjectRestore:req];
    [self waitForExpectationsWithTimeout:80 handler:nil];
    // .cssg-body-end
}

- (void)method36 {
    // .cssg-body-start: [put-object-acl]
    XCTestExpectation* exp = [self expectationWithDescription:@"put-object-acl"];
    QCloudPutObjectACLRequest* request = [QCloudPutObjectACLRequest new];
    request.object = @"{{object}}";
    request.bucket = @"{{persistBucket}}";
    NSString *grantString = [NSString stringWithFormat:@"id=\"%@\"",@"{{appId}}"];
    request.grantFullControl = grantString;
    [request setFinishBlock:^(id outputObject, NSError *error) {
        //可以从 outputObject 中获取 response 中 etag 或者自定义头部等信息
        XCTAssertNil(error);
        [exp fulfill];
    }];
    
    [[QCloudCOSXMLService defaultCOSXML] PutObjectACL:request];
    [self waitForExpectationsWithTimeout:80 handler:nil];
    // .cssg-body-end
}

- (void)method37 {
    // .cssg-body-start: [get-object-acl]
    XCTestExpectation* exp = [self expectationWithDescription:@"get-object-acl"];
    QCloudGetObjectACLRequest *request = [QCloudGetObjectACLRequest new];
    request.object = @"{{object}}";
    request.bucket = @"{{persistBucket}}";
    __block QCloudACLPolicy* policy;
    [request setFinishBlock:^(QCloudACLPolicy * _Nonnull result, NSError * _Nonnull error) {
        policy = result;
        XCTAssertNil(error);
        [exp fulfill];
    }];

    [[QCloudCOSXMLService defaultCOSXML] GetObjectACL:request];
    [self waitForExpectationsWithTimeout:80 handler:nil];
    // .cssg-body-end
}

- (void)method48 {
    // .cssg-body-start: [get-presign-download-url]
    XCTestExpectation* exp = [self expectationWithDescription:@"get-presign-download-url"];
    QCloudGetPresignedURLRequest* getPresignedURLRequest = [[QCloudGetPresignedURLRequest alloc] init];
    getPresignedURLRequest.bucket = @"{{persistBucket}}";
    getPresignedURLRequest.HTTPMethod = @"GET";
    getPresignedURLRequest.object = @"{{object}}";
    
    [getPresignedURLRequest setFinishBlock:^(QCloudGetPresignedURLResult * _Nonnull result, NSError * _Nonnull error) {
        XCTAssertNil(error);
        NSString* presignedURL = result.presienedURL;
        [exp fulfill];
    }];

    [[QCloudCOSXMLService defaultCOSXML] getPresignedURL:getPresignedURLRequest];
    [self waitForExpectationsWithTimeout:80 handler:nil];
     // .cssg-body-end
}
     
@end
