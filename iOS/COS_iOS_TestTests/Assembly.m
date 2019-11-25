//
//  Assembly.m
//
//  Copyright © 2019 tencentyun.com. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <QCloudCOSXML/QCloudCOSXML.h>

// cssg-snippet-lang: [iOS]
@interface Assembly : XCTestCase <QCloudSignatureProvider>

@end

@implementation Assembly

// .cssg-body-start: [global-init]
//AppDelegate.m
//第一步：注册默认的cos服务
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    QCloudServiceConfiguration* configuration = [QCloudServiceConfiguration new];
    configuration.appID = @"APPID";
    configuration.signatureProvider = self;
    QCloudCOSXMLEndPoint* endpoint = [[QCloudCOSXMLEndPoint alloc] init];
    endpoint.regionName = @"ap-beijing";//服务地域名称，可用的地域请参考注释
    configuration.endpoint = endpoint;
    [QCloudCOSXMLService registerDefaultCOSXMLWithConfiguration:configuration];
    [QCloudCOSTransferMangerService registerDefaultCOSTransferMangerWithConfiguration:configuration];
}

//第二步：实现QCloudSignatureProvider协议
- (void) signatureWithFields:(QCloudSignatureFields*)fileds
                     request:(QCloudBizHTTPRequest*)request
                  urlRequest:(NSURLRequest*)urlRequst
                   compelete:(QCloudHTTPAuthentationContinueBlock)continueBlock
{
    //实现签名的过程，我们推荐在服务器端实现签名的过程，具体请参考接下来的 “生成签名” 这一章。
}

// .cssg-body-end
// .cssg-body-start: [global-init-signature-sts]
- (void) signatureWithFields:(QCloudSignatureFields*)fileds
                     request:(QCloudBizHTTPRequest*)request
                  urlRequest:(NSURLRequest*)urlRequst
                   compelete:(QCloudHTTPAuthentationContinueBlock)continueBlock
{
    /*向签名服务器请求临时的 Secret ID,Secret Key,Token*/
    QCloudCredential* credential = [QCloudCredential new];
    credential.secretID = @"AKIDHTVVaVR6e3";
    credential.secretKey = @"PdkhT9e2rZCfy6";
    credential.token = @"从 CAM 系统返回的 Token，为会话 ID"
    /*强烈建议返回服务器时间作为签名的开始时间，用来避免由于用户手机本地时间偏差过大导致的签名不正确 */
    credential.startDate = /*返回的服务器时间*/
    credential.expiretionDate	 = /*签名过期时间*/
    QCloudAuthentationV5Creator* creator = [[QCloudAuthentationV5Creator alloc] initWithCredential:credential];
    QCloudSignature* signature =  [creator signatureForData:urlRequst];
    continueBlock(signature, nil);
}

// .cssg-body-end
// .cssg-body-start: [global-init-signature]
- (void) signatureWithFields:(QCloudSignatureFields*)fileds
                     request:(QCloudBizHTTPRequest*)request
                  urlRequest:(NSMutableURLRequest*)urlRequst
                   compelete:(QCloudHTTPAuthentationContinueBlock)continueBlock
{
    
    QCloudCredential* credential = [QCloudCredential new];
    credential.secretID = @"AKIDHTVVaVR6e3";
    credential.secretKey = @"PdkhT9e2rZCfy6";
    QCloudAuthentationV5Creator* creator = [[QCloudAuthentationV5Creator alloc] initWithCredential:credential];
    QCloudSignature* signature =  [creator signatureForData:urlRequst];
    continueBlock(signature, nil);
}

// .cssg-body-end
// .cssg-body-start: [global-init-fence-queue]
//AppDelegate.m
- (void) fenceQueue:(QCloudCredentailFenceQueue * )queue requestCreatorWithContinue:(QCloudCredentailFenceQueueContinue)continueBlock
{
    QCloudCredential* credential = [QCloudCredential new];
    //在这里可以同步过程从服务器获取临时签名需要的secretID,secretKey,expiretionDate和token参数
    credential.secretID = @"AKIDHTVVaVR6e3";
    credential.secretKey = @"PdkhT9e2rZCfy6";
    /*强烈建议返回服务器时间作为签名的开始时间，用来避免由于用户手机本地时间偏差过大导致的签名不正确 */
    credential.startDate =[NSDate dateWithTimeIntervalSince1970:@"返回的服务器时间"]
    credential.experationDate = [NSDate dateWithTimeIntervalSince1970:1504183628];
    credential.token = @"Token";
    QCloudAuthentationV5Creator* creator = [[QCloudAuthentationV5Creator alloc] initWithCredential:credential];
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
    }];
    [[QCloudCOSXMLService defaultCOSXML] GetService:request];e("CosServerException: " + serverEx.GetInfo());
    
    [self waitForExpectationsWithTimeout:80 handler:nil];
    // .cssg-body-end
}
- (void)method2 {
    // .cssg-body-start: [put-bucket]
    XCTestExpectation* exp = [self expectationWithDescription:@"put-bucket"];
    QCloudPutBucketRequest* request = [QCloudPutBucketRequest new];
    request.bucket = @"examplebucket-1250000000"; //additional actions after finishing
    [request setFinishBlock:^(id outputObject, NSError* error) {
        //可以从 outputObject 中获取服务器返回的 header 信息
    }];
    [[QCloudCOSXMLService defaultCOSXML] PutBucket:request];
    
    [self waitForExpectationsWithTimeout:80 handler:nil];
    // .cssg-body-end
}
- (void)method3 {
    // .cssg-body-start: [head-bucket]
    XCTestExpectation* exp = [self expectationWithDescription:@"head-bucket"];
    QCloudHeadBucketRequest* request = [QCloudHeadBucketRequest new];
    request.bucket = @"examplebucket-1250000000";
    [request setFinishBlock:^(id outputObject, NSError* error) {
        //可以从 outputObject 中获取服务器返回的header信息
        //设置完成回调。如果没有 error，则可以正常访问 bucket。如果有 error，可以从 error code 和 message 中获取具体的失败原因。
    }];
    [[QCloudCOSXMLService defaultCOSXML] HeadBucket:request];
    
    [self waitForExpectationsWithTimeout:80 handler:nil];
    // .cssg-body-end
}
- (void)method4 {
    // .cssg-body-start: [delete-bucket]
    XCTestExpectation* exp = [self expectationWithDescription:@"delete-bucket"];
    QCloudDeleteBucketRequest* request = [[QCloudDeleteBucketRequest alloc ] init];
    request.bucket = @"examplebucket-1250000000";  //存储桶名称，命名格式：BucketName-APPID
    [request setFinishBlock:^(id outputObject,NSError*error) {
        //additional actions after finishing
        //可以从 outputObject 中获取服务器返回的header信息
    }];
    [[QCloudCOSXMLService defaultCOSXML] DeleteBucket:request];
    
    [self waitForExpectationsWithTimeout:80 handler:nil];
    // .cssg-body-end
}
- (void)method5 {
    // .cssg-body-start: [put-bucket-acl]
    XCTestExpectation* exp = [self expectationWithDescription:@"put-bucket-acl"];
    QCloudPutBucketACLRequest* putACL = [QCloudPutBucketACLRequest new];
    NSString* appID = @“1250000000”;//您的AppID
    NSString *ownerIdentifier = [NSString stringWithFormat:@"qcs::cam::uin/%@:uin/%@", appID, appID];
    NSString *grantString = [NSString stringWithFormat:@"id=\"%@\"",ownerIdentifier];
    putACL.grantFullControl = grantString;
    putACL.bucket = @“examplebucket-1250000000”;
    [putACL setFinishBlock:^(id outputObject, NSError *error) {
        //error occucs if error != nil
        //可以从 outputObject 中获取服务器返回的header信息
    }];
    [[QCloudCOSXMLService defaultCOSXML] PutBucketACL:putACL];
    
    
    [self waitForExpectationsWithTimeout:80 handler:nil];
    // .cssg-body-end
}
- (void)method6 {
    // .cssg-body-start: [get-bucket-acl]
    XCTestExpectation* exp = [self expectationWithDescription:@"get-bucket-acl"];
    QCloudGetBucketACLRequest* getBucketACl   = [QCloudGetBucketACLRequest new];
    getBucketACl.bucket = @"testbucket-123456789";
    [getBucketACl setFinishBlock:^(QCloudACLPolicy * _Nonnull result, NSError * _Nonnull error) {
        //QCloudACLPolicy中包含了 Bucket 的 ACL 信息。
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
    rule.allowedOrigin = @"*";
    cors.rules = @[rule];
    putCORS.corsConfiguration = cors;
    putCORS.bucket = @"examplebucket-1250000000";
    [putCORS setFinishBlock:^(id outputObject, NSError *error) {
        //可以从 outputObject 中获取服务器返回的header信息
        if (!error) {
            //success
        }
    }];
    [[QCloudCOSXMLService defaultCOSXML] PutBucketCORS:putCORS];
    
    [self waitForExpectationsWithTimeout:80 handler:nil];
    // .cssg-body-end
}
- (void)method8 {
    // .cssg-body-start: [get-bucket-cors]
    XCTestExpectation* exp = [self expectationWithDescription:@"get-bucket-cors"];
    QCloudGetBucketCORSRequest* corsReqeust = [QCloudGetBucketCORSRequest new];
    corsReqeust.bucket = @"examplebucket-1250000000";
    
    [corsReqeust setFinishBlock:^(QCloudCORSConfiguration * _Nonnull result, NSError * _Nonnull error) {
        //CORS设置封装在result中。
    }];
    
    [[QCloudCOSXMLService defaultCOSXML] GetBucketCORS:corsReqeust];
    
    [self waitForExpectationsWithTimeout:80 handler:nil];
    // .cssg-body-end
}
- (void)method9 {
    // .cssg-body-start: [delete-bucket-cors]
    XCTestExpectation* exp = [self expectationWithDescription:@"delete-bucket-cors"];
    QCloudDeleteBucketCORSRequest* deleteCORS = [QCloudDeleteBucketCORSRequest new];
    deleteCORS.bucket = @"examplebucket-1250000000";
    [deleteCORS setFinishBlock:^(id outputObject, NSError *error) {
        //可以从 outputObject 中获取服务器返回的header信息
        //success if error == nil
    }];
    [[QCloudCOSXMLService defaultCOSXML] DeleteBucketCORS:deleteCORS];
    
    [self waitForExpectationsWithTimeout:80 handler:nil];
    // .cssg-body-end
}
- (void)method10 {
    // .cssg-body-start: [put-bucket-lifecycle]
    XCTestExpectation* exp = [self expectationWithDescription:@"put-bucket-lifecycle"];
    QCloudPutBucketLifecycleRequest* request = [QCloudPutBucketLifecycleRequest new];
    request.bucket = @"examplebucket-1250000000";
    __block QCloudLifecycleConfiguration* configuration = [[QCloudLifecycleConfiguration alloc] init];
    QCloudLifecycleRule* rule = [[QCloudLifecycleRule alloc] init];
    rule.identifier = @"identifier";
    rule.status = QCloudLifecycleStatueEnabled;
    QCloudLifecycleRuleFilter* filter = [[QCloudLifecycleRuleFilter alloc] init];
    filter.prefix = @"0";
    rule.filter = filter;
    
    QCloudLifecycleTransition* transition = [[QCloudLifecycleTransition alloc] init];
    transition.days = 100;
    transition.storageClass = QCloudCOSStorageStandarIA;
    rule.transition = transition;
    request.lifeCycle = configuration;
    request.lifeCycle.rules = @[rule];
    [request setFinishBlock:^(id outputObject, NSError* error) {
        //可以从 outputObject 中获取服务器返回的header信息
        //设置完成回调
    }];
    [[QCloudCOSXMLService defaultCOSXML] PutBucketLifecycle:request];
    
    
    [self waitForExpectationsWithTimeout:80 handler:nil];
    // .cssg-body-end
}
- (void)method11 {
    // .cssg-body-start: [get-bucket-lifecycle]
    XCTestExpectation* exp = [self expectationWithDescription:@"get-bucket-lifecycle"];
    QCloudGetBucketLifecycleRequest* request = [QCloudGetBucketLifecycleRequest new];
    request.bucket = @"examplebucket-1250000000";
    [request setFinishBlock:^(QCloudLifecycleConfiguration* result,NSError* error) {
        //设置完成回调
    }];
    [[QCloudCOSXMLService defaultCOSXML] GetBucketLifecycle:request];
    
    
    [self waitForExpectationsWithTimeout:80 handler:nil];
    // .cssg-body-end
}
- (void)method12 {
    // .cssg-body-start: [delete-bucket-lifecycle]
    XCTestExpectation* exp = [self expectationWithDescription:@"delete-bucket-lifecycle"];
    QCloudDeleteBucketLifeCycleRequest* request = [[QCloudDeleteBucketLifeCycleRequest alloc ] init];
    request.bucket = @"examplebucket-1250000000";
    [request setFinishBlock:^(QCloudLifecycleConfiguration* deleteResult, NSError* deleteError) {
        
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
    request.bucket =@"examplebucket-1250000000";
    QCloudBucketVersioningConfiguration* configuration = [[QCloudBucketVersioningConfiguration alloc] init];
    request.configuration = configuration;
    configuration.status = QCloudCOSBucketVersioningStatusEnabled;
    [request setFinishBlock:^(id outputObject, NSError* error) {
        //设置完成回调
    }];
    [[QCloudCOSXMLService defaultCOSXML] PutBucketVersioning:request];
    
    // 暂停版本控制
    QCloudPutBucketVersioningRequest* request = [[QCloudPutBucketVersioningRequest alloc] init];
    request.bucket = @"examplebucket-1250000000";
    QCloudBucketVersioningConfiguration* configuration = [[QCloudBucketVersioningConfiguration alloc] init];
    request.configuration = configuration;
    configuration.status = QCloudCOSBucketVersioningStatusSuspended;
    [request setFinishBlock:^(id outputObject, NSError* error) {
        //设置完成回调
    }];
    [[QCloudCOSXMLService defaultCOSXML] PutBucketVersioning:request];
    
    [self waitForExpectationsWithTimeout:80 handler:nil];
    // .cssg-body-end
}
- (void)method14 {
    // .cssg-body-start: [get-bucket-versioning]
    XCTestExpectation* exp = [self expectationWithDescription:@"get-bucket-versioning"];
    CloudGetBucketVersioningRequest* request = [[QCloudGetBucketVersioningRequest alloc] init];
    request.bucket = @"examplebucket-1250000000";
    [request setFinishBlock:^(QCloudBucketVersioningConfiguration* result, NSError* error) {
        //设置完成回调
    }];
    [[QCloudCOSXMLService defaultCOSXML] GetBucketVersioning:request];
    
    [self waitForExpectationsWithTimeout:80 handler:nil];
    // .cssg-body-end
}
- (void)method15 {
    // .cssg-body-start: [put-bucket-replication]
    XCTestExpectation* exp = [self expectationWithDescription:@"put-bucket-replication"];
    QCloudPutBucketReplicationRequest* request = [[QCloudPutBucketReplicationRequest alloc] init];
    request.bucket = @"examplebucket-1250000000";
    QCloudBucketReplicationConfiguation* configuration = [[QCloudBucketReplicationConfiguation alloc] init];
    configuration.role = [NSString identifierStringWithID:@"uin" :@"uin"];
    QCloudBucketReplicationRule* rule = [[QCloudBucketReplicationRule alloc] init];
    
    rule.identifier = @"identifier";
    rule.status = QCloudQCloudCOSXMLStatusEnabled;
    
    QCloudBucketReplicationDestination* destination = [[QCloudBucketReplicationDestination alloc] init];
    NSString* destinationBucket = @"destinationBucket";
    NSString* region = @"destinationRegion"
    destination.bucket = [NSString stringWithFormat:@"qcs:id/0:cos:%@:appid/%@:%@",@"region",@"appid",@"destinationBucket"];
    rule.destination = destination;
    configuration.rule = @[rule];
    request.configuation = configuration;
    [request setFinishBlock:^(id outputObject, NSError* error) {
        //设置完成回调
    }];
    [[QCloudCOSXMLService defaultCOSXML] PutBucketRelication:request];
    
    [self waitForExpectationsWithTimeout:80 handler:nil];
    // .cssg-body-end
}
- (void)method16 {
    // .cssg-body-start: [get-bucket-replication]
    XCTestExpectation* exp = [self expectationWithDescription:@"get-bucket-replication"];
    QCloudGetBucketReplicationRequest* request = [[QCloudGetBucketReplicationRequest alloc] init];
    request.bucket = @"examplebucket-1250000000";
    [request setFinishBlock:^(QCloudBucketReplicationConfiguation* result, NSError* error) {
        //设置完成回调
    }];
    [[QCloudCOSXMLService defaultCOSXML] GetBucketReplication:request];
    
    [self waitForExpectationsWithTimeout:80 handler:nil];
    // .cssg-body-end
}
- (void)method17 {
    // .cssg-body-start: [delete-bucket-replication]
    XCTestExpectation* exp = [self expectationWithDescription:@"delete-bucket-replication"];
    QCloudDeleteBucketReplicationRequest* request = [[QCloudDeleteBucketReplicationRequest alloc] init];
    request.bucket = @"examplebucket-1250000000";
    [request setFinishBlock:^(id outputObject, NSError* error) {
        
    }];
    [[QCloudCOSXMLService defaultCOSXML] DeleteBucketReplication:request];
    
    [self waitForExpectationsWithTimeout:80 handler:nil];
    // .cssg-body-end
}
- (void)method18 {
    // .cssg-body-start: [transfer-upload-object]
    XCTestExpectation* exp = [self expectationWithDescription:@"transfer-upload-object"];
    QCloudCOSXMLUploadObjectRequest* put = [QCloudCOSXMLUploadObjectRequest new];
    NSURL* url = [NSURL fileURLWithPath:@"filePathString"] /*对象的URL*/;
    put.object = @"picture.jpg";
    put.bucket = @"examplebucket-1250000000";
    put.body =  url;
    //设置一些上传的参数
    put.initMultipleUploadFinishBlock = ^(QCloudInitiateMultipartUploadResult * multipleUploadInitResult, QCloudCOSXMLUploadObjectResumeData resumeData) {
        //在初始化分块上传完成以后会回调该block，在这里可以获取 resumeData，并且可以通过 resumeData 生成一个分块上传的请求
        QCloudCOSXMLUploadObjectRequest* request = [QCloudCOSXMLUploadObjectRequest requestWithRequestData:resumeData];
    };
    [put setSendProcessBlock:^(int64_t bytesSent, int64_t totalBytesSent, int64_t totalBytesExpectedToSend) {
        NSLog(@"upload %lld totalSend %lld aim %lld", bytesSent, totalBytesSent, totalBytesExpectedToSend);
    }];
    [put setFinishBlock:^(id outputObject, NSError* error) {
        //可以从 outputObject 中获取 response 中 etag 或者自定义头部等信息（更多头部信息可以通过打印 outputObject 查看）
    }];
    
    [[QCloudCOSTransferMangerService defaultCOSTransferManager] UploadObject:put];
    
    //•••在完成了初始化，并且上传没有完成前
    NSError* error;
    //这里是主动调用取消，并且产生 resumetData 的例子
    resumeData = [put cancelByProductingResumeData:&error];
    if (resumeData) {
        QCloudCOSXMLUploadObjectRequest* request = [QCloudCOSXMLUploadObjectRequest requestWithRequestData:resumeData];
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
    request.bucket = @"examplebucket-1250000000";//目的<BucketName-APPID>，需要是公有读或者在当前账号有权限
    request.object = @"text.txt";//目的文件名称
    request.sourceBucket = @"examplebucket-1250000000";//文件来源<BucketName-APPID>，需要是公有读或者在当前账号有权限
    request.sourceObject = @"text.txt";//源文件名称
    request.sourceAPPID = @"appid";//源文件的appid
    request.sourceRegion= @"ap-beijing";//来源的地域
    [request setFinishBlock:^(QCloudCopyObjectResult* result, NSError* error) {
        //完成回调
        //可以从 outputObject 中获取 response 中 etag 或者自定义头部等信息（更多头部信息可以通过打印 outputObject 查看）
        if (nil == error) {
            //成功
        }
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
    request.bucket = @"examplebucket-1250000000";
    request.maxKeys = 1000;
    [request setFinishBlock:^(QCloudListBucketResult * result, NSError*   error) {
        //additional actions after finishing
    }];
    [[QCloudCOSXMLService defaultCOSXML] GetBucket:request];
    
    [self waitForExpectationsWithTimeout:80 handler:nil];
    // .cssg-body-end
}
- (void)method21 {
    // .cssg-body-start: [put-object]
    XCTestExpectation* exp = [self expectationWithDescription:@"put-object"];
    QCloudPutObjectRequest* put = [QCloudPutObjectRequest new];
    put.object = @"text.txt";
    put.bucket = @"examplebucket-1250000000";
    put.body =  [@"testFileContent" dataUsingEncoding:NSUTF8StringEncoding];
    [put setFinishBlock:^(id outputObject, NSError *error) {
        //完成回调
        //可以从 outputObject 中获取 response 中 etag 或者自定义头部等信息（更多头部信息可以通过打印 outputObject 查看）
        if (nil == error) {
            //成功
        }
    }];
    [[QCloudCOSXMLService defaultCOSXML] PutObject:put];
    
    
    [self waitForExpectationsWithTimeout:80 handler:nil];
    // .cssg-body-end
}
- (void)method22 {
    // .cssg-body-start: [head-object]
    XCTestExpectation* exp = [self expectationWithDescription:@"head-object"];
    QCloudHeadObjectRequest* headerRequest = [QCloudHeadObjectRequest new];
    headerRequest.object = @"text.txt";
    headerRequest.bucket = @"examplebucket-1250000000";
    
    __block id resultError;
    [headerRequest setFinishBlock:^(NSDictionary* result, NSError *error) {
        resultError = error;
    }];
    [[QCloudCOSXMLService defaultCOSXML] HeadObject:headerRequest];
    
    [self waitForExpectationsWithTimeout:80 handler:nil];
    // .cssg-body-end
}
- (void)method23 {
    // .cssg-body-start: [get-object]
    XCTestExpectation* exp = [self expectationWithDescription:@"get-object"];
    QCloudGetObjectRequest* request = [QCloudGetObjectRequest new];
    //设置下载的路径 URL，如果设置了，文件将会被下载到指定路径中.如果该参数没有设置，那么文件将会被下载至内存里，存放在在 finishBlock 的 	outputObject 里。
    request.downloadingURL = [NSURL URLWithString:QCloudTempFilePathWithExtension(@"downding")];
    request.object = @“text.txt”;
    request.bucket = @"examplebucket-1250000000";
    [request setFinishBlock:^(id outputObject, NSError *error) {
        //additional actions after finishing
        //可以从 outputObject 中获取 response 中 etag 或者自定义头部等信息（更多头部信息可以通过打印 outputObject 查看）
    }];
    [request setDownProcessBlock:^(int64_t bytesDownload, int64_t totalBytesDownload, int64_t totalBytesExpectedToDownload) {
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
    request.bucket =@"examplebucket-1250000000";
    request.origin = @"*";
    request.accessControlRequestMethod = @"get";
    request.accessControlRequestHeaders = @"host";
    request.object = @"picture.jpg";
    __block id resultError;
    [request setFinishBlock:^(id outputObject, NSError* error) {
        resultError = error;
        //可以从 outputObject 中获取 response 中 etag 或者自定义头部等信息（更多头部信息可以通过打印 outputObject 查看）
    }];
    
    [[QCloudCOSXMLService defaultCOSXML] OptionsObject:request];
    
    
    [self waitForExpectationsWithTimeout:80 handler:nil];
    // .cssg-body-end
}
- (void)method25 {
    // .cssg-body-start: [copy-object]
    XCTestExpectation* exp = [self expectationWithDescription:@"copy-object"];
    QCloudPutObjectCopyRequest* request = [[QCloudPutObjectCopyRequest alloc] init];
    request.bucket = @"examplebucket-1250000000";
    request.object = @" ";
    [request setFinishBlock:^(QCloudCopyObjectResult * _Nonnull result, NSError * _Nonnull error) {
        
    }];
    request.objectCopySource = objectCopySource;//源对象所在的路径
    [[QCloudCOSXMLService defaultCOSXML]  PutObjectCopy:request];
    
    [self waitForExpectationsWithTimeout:80 handler:nil];
    // .cssg-body-end
}
- (void)method26 {
    // .cssg-body-start: [delete-object]
    XCTestExpectation* exp = [self expectationWithDescription:@"delete-object"];
    QCloudDeleteObjectRequest* deleteObjectRequest = [QCloudDeleteObjectRequest new];
    deleteObjectRequest.bucket = @"examplebucket-1250000000";
    deleteObjectRequest.object = @"text.txt";
    __block NSError* resultError;
    [deleteObjectRequest setFinishBlock:^(id outputObject, NSError *error) {
        resultError = error;
        //可以从 outputObject 中获取 response 中 etag 或者自定义头部等信息（更多头部信息可以通过打印 outputObject 查看）
    }];
    [[QCloudCOSXMLService defaultCOSXML] DeleteObject:deleteObjectRequest];
    
    [self waitForExpectationsWithTimeout:80 handler:nil];
    // .cssg-body-end
}
- (void)method27 {
    // .cssg-body-start: [delete-multi-object]
    XCTestExpectation* exp = [self expectationWithDescription:@"delete-multi-object"];
    QCloudDeleteMultipleObjectRequest* delteRequest = [QCloudDeleteMultipleObjectRequest new];
    delteRequest.bucket = @"examplebucket-1250000000";
    
    QCloudDeleteObjectInfo* deletedObject0 = [QCloudDeleteObjectInfo new];
    deletedObject0.key = @"text,txt";
    
    QCloudDeleteObjectInfo* deleteObject1 = [QCloudDeleteObjectInfo new];
    deleteObject1.key = @"picture.jpg";
    
    QCloudDeleteInfo* deleteInfo = [QCloudDeleteInfo new];
    deleteInfo.quiet = NO;
    deleteInfo.objects = @[ deletedObject0,deleteObject2];
    delteRequest.deleteObjects = deleteInfo;
    __block NSError* resultError;
    [delteRequest setFinishBlock:^(QCloudDeleteResult* outputObject, NSError *error) {
        localError = error;
        deleteResult = outputObject;
    }];
    [[QCloudCOSXMLService defaultCOSXML] DeleteMultipleObject:delteRequest];
    
    [self waitForExpectationsWithTimeout:80 handler:nil];
    // .cssg-body-end
}
- (void)method28 {
    // .cssg-body-start: [list-multi-upload]
    XCTestExpectation* exp = [self expectationWithDescription:@"list-multi-upload"];
    QCloudListBucketMultipartUploadsRequest* uploads = [QCloudListBucketMultipartUploadsRequest new];
    uploads.bucket = @"examplebucket-1250000000";
    uploads.maxUploads = 100;
    __block NSError* resulError;
    __block QCloudListMultipartUploadsResult* multiPartUploadsResult;
    [uploads setFinishBlock:^(QCloudListMultipartUploadsResult* result, NSError *error) {
        multiPartUploadsResult = result;
        localError = error;
    }];
    [[QCloudCOSXMLService defaultCOSXML] ListBucketMultipartUploads:uploads];
    
    [self waitForExpectationsWithTimeout:80 handler:nil];
    // .cssg-body-end
}
- (void)method29 {
    // .cssg-body-start: [init-multi-upload]
    XCTestExpectation* exp = [self expectationWithDescription:@"init-multi-upload"];
    QCloudInitiateMultipartUploadRequest* initrequest = [QCloudInitiateMultipartUploadRequest new];
    initrequest.bucket = @"examplebucket-1250000000";
    initrequest.object = @"text.txt";
    __block QCloudInitiateMultipartUploadResult* initResult;
    [initrequest setFinishBlock:^(QCloudInitiateMultipartUploadResult* outputObject, NSError *error) {
        initResult = outputObject;
    }];
    [[QCloudCOSXMLService defaultCOSXML] InitiateMultipartUpload:initrequest];
    
    [self waitForExpectationsWithTimeout:80 handler:nil];
    // .cssg-body-end
}
- (void)method30 {
    // .cssg-body-start: [upload-part]
    XCTestExpectation* exp = [self expectationWithDescription:@"upload-part"];
    QCloudUploadPartRequest* request = [QCloudUploadPartRequest new];
    request.bucket = @"examplebucket-1250000000";
    request.object = @"text.txt";
    request.partNumber = @"partNumber"
    request.uploadId = @"uploadId"; //标识本次分块上传的 ID；使用 Initiate Multipart Upload 接口初始化分块上传时会得到一个 uploadId，该 ID 不但唯一标识这一分块数据，也标识了这分块数据在整个文件内的相对位置
    request.body = body;//上传的数据：支持NSData*，NSURL(本地url)和QCloudFileOffsetBody *三种类型
    [request setSendProcessBlock:^(int64_t bytesSent,
                                   int64_t totalBytesSent,
                                   int64_t totalBytesExpectedToSend) {
    }];
    [request setFinishBlock:^(QCloudUploadPartResult* outputObject, NSError *error) {
        //可以从 outputObject 中获取 response 中 etag 或者自定义头部等信息（更多头部信息可以通过打印 outputObject 查看）
    }];
    [[QCloudCOSXMLService defaultCOSXML]  UploadPart:request];
    
    [self waitForExpectationsWithTimeout:80 handler:nil];
    // .cssg-body-end
}
- (void)method31 {
    // .cssg-body-start: [upload-part-copy]
    XCTestExpectation* exp = [self expectationWithDescription:@"upload-part-copy"];
    QCloudUploadPartCopyRequest* request = [[QCloudUploadPartCopyRequest alloc] init];
    request.bucket = @"examplebucket-1250000000";
    request.object = @"text.txt";
    request.source = @"objectCopySource"; //  源文件 URL 路径，可以通过 versionid 子资源指定历史版本
    request.uploadID = @"uploadID"; // 在初始化分块上传的响应中，会返回一个唯一的描述符（upload ID）
    request.partNumber = 1; // 标志当前分块的序号
    [request setFinishBlock:^(QCloudCopyObjectResult* result, NSError* error) {
    }];
    [[QCloudCOSXMLService defaultCOSXML]UploadPartCopy:request];
    
    [self waitForExpectationsWithTimeout:80 handler:nil];
    // .cssg-body-end
}
- (void)method32 {
    // .cssg-body-start: [list-parts]
    XCTestExpectation* exp = [self expectationWithDescription:@"list-parts"];
    QCloudListMultipartRequest* request = [QCloudListMultipartRequest new];
    request.object = @"text.txt"
    request.bucket = @"examplebucket-1250000000";
    request.uploadId = @"uploadId";//本次要查询的分块上传的uploadId,可从初始化分块上传的请求结果QCloudInitiateMultipartUploadResult中得到
    [request setFinishBlock:^(QCloudListPartsResult * _Nonnull result,
                              NSError * _Nonnull error) {
    }];
    
    [[QCloudCOSXMLService defaultCOSXML] ListMultipart:request];
    
    [self waitForExpectationsWithTimeout:80 handler:nil];
    // .cssg-body-end
}
- (void)method33 {
    // .cssg-body-start: [complete-multi-upload]
    XCTestExpectation* exp = [self expectationWithDescription:@"complete-multi-upload"];
    QCloudCompleteMultipartUploadRequest *completeRequst = [QCloudCompleteMultipartUploadRequest new];
    completeRequst.bucket = @"examplebucket-1250000000";
    completeRequst.object = @"text.txt";
    completeRequst.uploadId = @"uploadId"; //本次分块上传的UploadID
    [completeRequst setFinishBlock:^(QCloudUploadObjectResult * _Nonnull result, NSError * _Nonnull error) {
        
    }];
    [[QCloudCOSXMLService defaultCOSXML] CompleteMultipartUpload:completeRequst];
    
    [self waitForExpectationsWithTimeout:80 handler:nil];
    // .cssg-body-end
}
- (void)method34 {
    // .cssg-body-start: [abort-multi-upload]
    XCTestExpectation* exp = [self expectationWithDescription:@"abort-multi-upload"];
    QCloudAbortMultipfartUploadRequest *abortRequest = [QCloudAbortMultipfartUploadRequest new];
    abortRequest.bucket = @"examplebucket-1250000000"; // 存储桶名称，命名格式：BucketName-APPID
    abortRequest.object = @"text.txt";
    abortRequest.uploadId = @"uploadId";
    [abortRequest setFinishBlock:^(id outputObject, NSError *error) {
        //additional actions after finishing
        //可以从 outputObject 中获取 response 中 etag 或者自定义头部等信息（更多头部信息可以通过打印 outputObject 查看）
    }];
    [[QCloudCOSXMLService defaultCOSXML]AbortMultipfartUpload:abortRequest];
    
    [self waitForExpectationsWithTimeout:80 handler:nil];
    // .cssg-body-end
}
- (void)method35 {
    // .cssg-body-start: [restore-object]
    XCTestExpectation* exp = [self expectationWithDescription:@"restore-object"];
    QCloudPostObjectRestoreRequest *req = [QCloudPostObjectRestoreRequest new];
    req.bucket = @"examplebucket-1250000000";
    req.object = @"text.txt";
    req.restoreRequest.days  = 10;
    req.restoreRequest.CASJobParameters.tier =QCloudCASTierStandard;
    [req setFinishBlock:^(id outputObject, NSError *error) {
        //可以从 outputObject 中获取 response 中 etag 或者自定义头部等信息（更多头部信息可以通过打印 outputObject 查看）
    }];
    [[QCloudCOSXMLService defaultCOSXML] PostObjectRestore:req];
    
    [self waitForExpectationsWithTimeout:80 handler:nil];
    // .cssg-body-end
}
- (void)method36 {
    // .cssg-body-start: [put-object-acl]
    XCTestExpectation* exp = [self expectationWithDescription:@"put-object-acl"];
    QCloudPutObjectACLRequest* request = [QCloudPutObjectACLRequest new];
    request.object = @"text.txt";
    request.bucket = @"examplebucket-1250000000";
    NSString *grantString = [NSString stringWithFormat:@"id=\"%@\"",ownerIdentifier];
    request.grantFullControl = grantString;
    __block NSError* localError;
    [request setFinishBlock:^(id outputObject, NSError *error) {
        localError = error;
        //可以从 outputObject 中获取 response 中 etag 或者自定义头部等信息（更多头部信息可以通过打印 outputObject 查看）
    }];
    [[QCloudCOSXMLService defaultCOSXML] PutObjectACL:request];
    
    [self waitForExpectationsWithTimeout:80 handler:nil];
    // .cssg-body-end
}
- (void)method37 {
    // .cssg-body-start: [get-object-acl]
    XCTestExpectation* exp = [self expectationWithDescription:@"get-object-acl"];
    QCloudGetObjectACLRequest *request = [QCloudGetObjectACLRequest new];
    request.object = @"text.txt";
    request.bucket = @"examplebucket-1250000000"
    __block QCloudACLPolicy* policy;
    [request setFinishBlock:^(QCloudACLPolicy * _Nonnull result, NSError * _Nonnull error) {
        policy = result;
    }];
    [[QCloudCOSXMLService defaultCOSXML] GetObjectACL:request];
    
    [self waitForExpectationsWithTimeout:80 handler:nil];
    // .cssg-body-end
}
- (void)method43 {
    // .cssg-body-start: [get-object]
    XCTestExpectation* exp = [self expectationWithDescription:@"get-object"];
    QCloudGetObjectRequest* request = [QCloudGetObjectRequest new];
    //设置下载的路径 URL，如果设置了，对象将会被下载到指定路径中
    request.downloadingURL = [NSURL URLWithString:QCloudTempFilePathWithExtension(@"downding")];
    request.object = @"picture";
    request.bucket = @"examplebucket-1250000000";
    [request setFinishBlock:^(id outputObject, NSError *error) {
        //additional actions after finishing
        //可以从 outputObject 中获取 response 中 etag 或者自定义头部等信息（更多头部信息可以通过打印 outputObject 查看）
    }];
    [request setDownProcessBlock:^(int64_t bytesDownload, int64_t totalBytesDownload, int64_t totalBytesExpectedToDownload) {
        //下载过程中的进度
    }];
    [[QCloudCOSXMLService defaultCOSXML] GetObject:request];
    
    [self waitForExpectationsWithTimeout:80 handler:nil];
    // .cssg-body-end
}
- (void)method48 {
    // .cssg-body-start: [get-presign-download-url]
    XCTestExpectation* exp = [self expectationWithDescription:@"get-presign-download-url"];
    QCloudGetPresignedURLRequest* getPresignedURLRequest = [[QCloudGetPresignedURLRequest alloc] init];
    getPresignedURLRequest.bucket = @“examplebucket-1250000000”;
    getPresignedURLRequest.HTTPMethod = @"GET";
    getPresignedURLRequest.object = @"text.txt";
    [getPresignedURLRequest setFinishBlock:^(QCloudGetPresignedURLResult * _Nonnull result, NSError * _Nonnull error) {
        if (nil == error) {
            NSString* presignedURL = result.presienedURL;
        }
    }
     [[QCloudCOSXMLService defaultCOSXML] getPresignedURL:getPresignedURLRequest];
     
     // 演示一个使用带预签名 URL 进行下载的例子。
     
     NSMutableURLRequest* request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"带预签名的URL"]];
     request.HTTPMethod = @"GET";
     request.HTTPBody = [@"文件内容" dataUsingEncoding:NSUTF8StringEncoding];
     [[[NSURLSession sharedSession] downloadTaskWithRequest:request completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSInteger statusCode = [(NSHTTPURLResponse*)response statusCode];
    }] resume];
     
     [self waitForExpectationsWithTimeout:80 handler:nil];
     // .cssg-body-end
     }
     
     @end
