//
//  Assembly.m
//
//  Copyright © 2019 tencentyun.com. All rights reserved.
//

import XCTest
import QCloudCOSXML

class InitWithSecret: NSObject {
    // .cssg-body-start: [swift-global-init-signature]
    
    func signature(with fileds: QCloudSignatureFields!, request: QCloudBizHTTPRequest!, urlRequest urlRequst: NSMutableURLRequest!, compelete continueBlock: QCloudHTTPAuthentationContinueBlock!) {
        let cre = QCloudCredential.init();
        cre.secretID = "COS_SECRETID";
        cre.secretKey = "COS_SECRETKEY";
        let auth = QCloudAuthentationV5Creator.init(credential: cre);
        let signature = auth?.signature(forData: urlRequst)
        continueBlock(signature,nil);
    }
    // .cssg-body-end
}

class InitWithSTS: NSObject {
    // .cssg-body-start: [swift-global-init-signature-sts]
    
    func signature(with fileds: QCloudSignatureFields!, request: QCloudBizHTTPRequest!, urlRequest urlRequst: NSMutableURLRequest!, compelete continueBlock: QCloudHTTPAuthentationContinueBlock!) {
        let cre = QCloudCredential.init();
        cre.secretID = "COS_SECRETID";
        cre.secretKey = "COS_SECRETKEY";
        cre.token = "COS_TOKEN";
        /*强烈建议返回服务器时间作为签名的开始时间，用来避免由于用户手机本地时间偏差过大导致的签名不正确 */
        cre.startDate = DateFormatter().date(from: "start-time");
        cre.experationDate = DateFormatter().date(from: "expire-time");
        let auth = QCloudAuthentationV5Creator.init(credential: cre);
        let signature = auth?.signature(forData: urlRequst)
        continueBlock(signature,nil);
    }
    // .cssg-body-end
}

// cssg-snippet-lang: [swift]
class Assembly: XCTestCase,QCloudSignatureProvider,QCloudCredentailFenceQueueDelegate{
    
    
    var uploadId:String?;
    var parts:[QCloudMultipartInfo]?;
    var credentialFenceQueue:QCloudCredentailFenceQueue?
    
    
    
    // .cssg-body-start: [swift-global-init]
    //AppDelegate.m
    //第一步：注册默认的 COS 服务
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let config = QCloudServiceConfiguration.init();
        config.signatureProvider = self;
        config.appID = "appId";
        let endpoint = QCloudCOSXMLEndPoint.init();
        endpoint.regionName = "region";
        endpoint.useHTTPS = true;
        config.endpoint = endpoint;
        QCloudCOSXMLService.registerDefaultCOSXML(with: config);
        QCloudCOSTransferMangerService.registerDefaultCOSTransferManger(with: config);
        return true;
    }
    
    
    //第二步：实现 QCloudSignatureProvider 协议
    //实现签名的过程，我们推荐在服务器端实现签名的过程，详情请参考接下来的 “生成签名” 这一章。
    // .cssg-body-end
    
    // .cssg-body-start: [swift-global-init-fence-queue]
    //AppDelegate.m
    
    // 这里定义一个成员变量 @property (nonatomic) QCloudCredentailFenceQueue* credentialFenceQueue;
    
    func fenceQueue(_ queue: QCloudCredentailFenceQueue!, requestCreatorWithContinue continueBlock: QCloudCredentailFenceQueueContinue!) {
        let cre = QCloudCredential.init();
        //在这里可以同步过程从服务器获取临时签名需要的 secretID，secretKey，expiretionDate 和 token 参数
        cre.secretID = "COS_SECRETID";
        cre.secretKey = "COS_SECRETKEY";
        cre.token = "COS_TOKEN";
        /*强烈建议返回服务器时间作为签名的开始时间，用来避免由于用户手机本地时间偏差过大导致的签名不正确 */
        cre.startDate = DateFormatter().date(from: "start-time");
        cre.experationDate = DateFormatter().date(from: "expire-time");
        let auth = QCloudAuthentationV5Creator.init(credential: cre);
        continueBlock(auth,nil);
    }
    
    func signature(with fileds: QCloudSignatureFields!, request: QCloudBizHTTPRequest!, urlRequest urlRequst: NSMutableURLRequest!, compelete continueBlock: QCloudHTTPAuthentationContinueBlock!) {
        self.credentialFenceQueue?.performAction({ (creator, error) in
            if error != nil {
                continueBlock(nil,error!);
            }else{
                let signature = creator?.signature(forData: urlRequst);
                continueBlock(signature,nil);
            }
        })
    }
    // .cssg-body-end
    
    func method1() {
        // .cssg-body-start: [swift-get-service]
        let exception = XCTestExpectation.init(description: "get service exception");
        let getServiceReq = QCloudGetServiceRequest.init();
        getServiceReq.setFinish{(result,error) in
            XCTAssertNil(error);
            XCTAssertNotNil(result);
            if result == nil {
                print(error!);
            } else {
                //从 result 中获取返回信息
                print(result!);
            }
            exception .fulfill();
        }
        QCloudCOSXMLService.defaultCOSXML().getService(getServiceReq);
        self.wait(for: [exception], timeout: 100);
        // .cssg-body-end
    }
    
    func method2() {
        // .cssg-body-start: [swift-put-bucket]
        let exception = XCTestExpectation.init(description: "putBucket exception");
        let putBucketReq = QCloudPutBucketRequest.init();
        putBucketReq.bucket = "{{tempBucket}}";
        putBucketReq.finishBlock = {(result,error) in
            XCTAssertNil(error);
            XCTAssertNotNil(result);
            if error != nil {
                print(error!);
            } else {
                print(result!);
            }
            exception .fulfill();
        }
        QCloudCOSXMLService.defaultCOSXML().putBucket(putBucketReq);
        self.wait(for: [exception], timeout: 100);
    // .cssg-body-end
    }

func method3() {
    // .cssg-body-start: [swift-head-bucket]
    let exception = XCTestExpectation.init(description: "headBucket exception");
    let headBucketReq = QCloudHeadBucketRequest.init();
    headBucketReq.bucket = "{{tempBucket}}";
    headBucketReq.finishBlock = {(result,error) in
        XCTAssertNil(error);
        XCTAssertNotNil(result);
        if error != nil{
            print(error!);
        }else{
            print( result!);
        }
        exception .fulfill();
    }
    QCloudCOSXMLService.defaultCOSXML().headBucket(headBucketReq);
    self.wait(for: [exception], timeout: 100);
    // .cssg-body-end
}

func method4() {
    // .cssg-body-start: [swift-delete-bucket]
    let exception = XCTestExpectation.init(description: "deleteBucket exception");
    let deleteBucketReq = QCloudDeleteBucketRequest.init();
    deleteBucketReq.bucket = "{{tempBucket}}";
    deleteBucketReq.finishBlock = {(result,error) in
        XCTAssertNil(error);
        XCTAssertNotNil(result);
        if error != nil{
            print(error!);
        }else{
            print(result!);
        }
        exception .fulfill();
    }
    QCloudCOSXMLService.defaultCOSXML().deleteBucket(deleteBucketReq);
    self.wait(for: [exception], timeout: 100);
    // .cssg-body-end
}

func method5() {
    // .cssg-body-start: [swift-put-bucket-acl]
    let exception = XCTestExpectation.init(description: "putBucketACL exception");
    let putBucketACLReq = QCloudPutBucketACLRequest.init();
    putBucketACLReq.bucket = "{{tempBucket}}";
    let appTD = "1131975903";//授予全新的账号 ID
    let ownerIdentifier = "qcs::cam::uin/\(appTD):uin/\(appTD)";
    let grantString = "id=\"\(ownerIdentifier)\"";
    putBucketACLReq.grantWrite = grantString;
    putBucketACLReq.finishBlock = {(result,error) in
        XCTAssertNil(error);
        XCTAssertNotNil(result);
        if error != nil{
            print(error!);
        }else{
            print(result!);
        }
        exception .fulfill();
    }
    QCloudCOSXMLService.defaultCOSXML().putBucketACL(putBucketACLReq);
    self.wait(for: [exception], timeout: 100);
    // .cssg-body-end
}

func method6() {
    // .cssg-body-start: [swift-get-bucket-acl]
    let exception = XCTestExpectation.init(description: "getBucketACL exception");
    let getBucketACLReq = QCloudGetBucketACLRequest.init();
    getBucketACLReq.bucket = "{{tempBucket}}";
    getBucketACLReq.setFinish { (result, error) in
        XCTAssertNil(error);
        XCTAssertNotNil(result);
        if error != nil{
            print(error!);
        }else{
            print(result!);
        }
        exception .fulfill();
    }
    QCloudCOSXMLService.defaultCOSXML().getBucketACL(getBucketACLReq)
    self.wait(for: [exception], timeout: 100);
    // .cssg-body-end
}

func method7() {
    // .cssg-body-start: [swift-put-bucket-cors]
    let exception = XCTestExpectation.init(description: "putBucketCors exception");
    let putBucketCorsReq = QCloudPutBucketCORSRequest.init();
    
    let corsConfig = QCloudCORSConfiguration.init();
    
    let rule = QCloudCORSRule.init();
    rule.identifier = "swift-sdk";
    rule.allowedHeader = ["origin","host","accept","content-type","authorization"];
    rule.exposeHeader = "Etag";
    rule.allowedMethod = ["GET","PUT","POST", "DELETE", "HEAD"];
    rule.maxAgeSeconds = 3600;
    rule.allowedOrigin = "*";
    
    corsConfig.rules = [rule];
    
    putBucketCorsReq.corsConfiguration = corsConfig;
    putBucketCorsReq.bucket = "{{tempBucket}}";
    putBucketCorsReq.finishBlock = {(result,error) in
        XCTAssertNil(error);
        XCTAssertNotNil(result);
        if error != nil{
            print(error!);
        }else{
            print(result!);
        }
        exception .fulfill();
    }
    
    QCloudCOSXMLService.defaultCOSXML().putBucketCORS(putBucketCorsReq);
    self.wait(for: [exception], timeout: 100);
    // .cssg-body-end
}

func method8() {
    // .cssg-body-start: [swift-get-bucket-cors]
    let exception = XCTestExpectation.init(description: "getBucketCors exception");
    let  getBucketCorsRes = QCloudGetBucketCORSRequest.init();
    getBucketCorsRes.bucket = "{{tempBucket}}";
    getBucketCorsRes.setFinish { (corsConfig, error) in
        XCTAssertNil(error);
        XCTAssertNotNil(corsConfig);
        if error != nil{
            print(error!);
        }else{
            print(corsConfig!);
        }
        exception .fulfill();
    }
    QCloudCOSXMLService.defaultCOSXML().getBucketCORS(getBucketCorsRes);
    self.wait(for: [exception], timeout: 100);
    // .cssg-body-end
}

func method9() {
    // .cssg-body-start: [swift-delete-bucket-cors]
    let exception = XCTestExpectation.init(description: "deleteBucketCors exception");
    let deleteBucketCorsRequest = QCloudDeleteBucketCORSRequest.init();
    deleteBucketCorsRequest.bucket = "{{tempBucket}}";
    deleteBucketCorsRequest.finishBlock = {(result,error) in
        XCTAssertNil(error);
        XCTAssertNotNil(result);
        if error != nil{
            print(error!);
        }else{
            print(result!);
        }
        exception .fulfill();
    }
    QCloudCOSXMLService.defaultCOSXML().deleteBucketCORS(deleteBucketCorsRequest);
    self.wait(for: [exception], timeout: 100);
    // .cssg-body-end
}

func method10() {
    // .cssg-body-start: [swift-put-bucket-lifecycle]
    let exception = XCTestExpectation.init(description: "putBucketLifecycle exception");
    let putBucketLifecycleReq = QCloudPutBucketLifecycleRequest.init();
    putBucketLifecycleReq.bucket = "{{tempBucket}}";
    
    let config = QCloudLifecycleConfiguration.init();
    
    let rule = QCloudLifecycleRule.init();
    rule.identifier = "swift";
    rule.status = .enabled;
    
    let fileter = QCloudLifecycleRuleFilter.init();
    fileter.prefix = "0";
    
    rule.filter = fileter;
    
    let transition = QCloudLifecycleTransition.init();
    transition.days = 100;
    transition.storageClass = .standardIA;
    
    rule.transition = transition;
    
    putBucketLifecycleReq.lifeCycle = config;
    putBucketLifecycleReq.lifeCycle.rules = [rule];
    
    putBucketLifecycleReq.finishBlock = {(result,error) in
        if error != nil{
            print(error!);
        }else{
            print(result!);
        }
        exception .fulfill();
    }
    QCloudCOSXMLService.defaultCOSXML().putBucketLifecycle(putBucketLifecycleReq);
    self.wait(for: [exception], timeout: 100);
    // .cssg-body-end
}

func method11() {
    // .cssg-body-start: [swift-get-bucket-lifecycle]
    let exception = XCTestExpectation.init(description: "getBucketLifeCycle exception");
    let getBucketLifeCycle = QCloudGetBucketLifecycleRequest.init();
    getBucketLifeCycle.bucket = "{{tempBucket}}";
    getBucketLifeCycle.setFinish { (config, error) in
        if error != nil{
            print(error!);
        }else{
            print(config!);
        }
        exception .fulfill();
    };
    QCloudCOSXMLService.defaultCOSXML().getBucketLifecycle(getBucketLifeCycle);
    self.wait(for: [exception], timeout: 100);
    // .cssg-body-end
}

func method12() {
    // .cssg-body-start: [swift-delete-bucket-lifecycle]
    let exception = XCTestExpectation.init(description: "deleteBucketLifeCycle exception");
    let deleteBucketLifeCycle = QCloudDeleteBucketLifeCycleRequest.init();
    deleteBucketLifeCycle.bucket = "{{tempBucket}}";
    deleteBucketLifeCycle.finishBlock = { (result, error) in
        XCTAssertNil(error);
        XCTAssertNotNil(result);
        if error != nil{
            print(error!);
        }else{
            print(result!);
        }
        exception.fulfill();
    };
    QCloudCOSXMLService.defaultCOSXML().deleteBucketLifeCycle(deleteBucketLifeCycle);
    self.wait(for: [exception], timeout: 100);
    // .cssg-body-end
}

func method13() {
    // .cssg-body-start: [swift-put-bucket-versioning]
    let exception = XCTestExpectation.init(description: "putBucketVersioning exception");
    let putBucketVersioning = QCloudPutBucketVersioningRequest.init();
    putBucketVersioning.bucket = "{{tempBucket}}";
    
    let config = QCloudBucketVersioningConfiguration.init();
    config.status = .enabled;
    
    putBucketVersioning.configuration = config;
    
    putBucketVersioning.finishBlock = {(result,error) in
        XCTAssertNil(error);
        XCTAssertNotNil(result);
        if error != nil{
            print(error!);
        }else{
            print(result!);
        }
        exception.fulfill();
    }
    QCloudCOSXMLService.defaultCOSXML().putBucketVersioning(putBucketVersioning);
    self.wait(for: [exception], timeout: 100);
    // .cssg-body-end
}

func method14() {
    // .cssg-body-start: [swift-get-bucket-versioning]
    let exception = XCTestExpectation.init(description: "testGetBucketVersioning exception");
    let getBucketVersioning = QCloudGetBucketVersioningRequest.init();
    getBucketVersioning.bucket = "{{tempBucket}}";
    getBucketVersioning.setFinish { (config, error) in
        XCTAssertNil(error);
        XCTAssertNotNil(config);
        if error != nil{
            print(error!);
        }else{
            print(config!);
        }
        exception .fulfill();
    }
    QCloudCOSXMLService.defaultCOSXML().getBucketVersioning(getBucketVersioning);
    self.wait(for: [exception], timeout: 100);
    // .cssg-body-end
}

func method15() {
    // .cssg-body-start: [swift-put-bucket-replication]
    let exception = XCTestExpectation.init(description: "putBucketReplication exception");
    let putBucketReplication = QCloudPutBucketReplicationRequest.init();
    putBucketReplication.bucket = "{{tempBucket}}";
    
    let config = QCloudBucketReplicationConfiguation.init();
    config.role = "qcs::cam::uin/{{uin}}:uin/{{uin}}";
    
    let rule = QCloudBucketReplicationRule.init();
    rule.identifier = "swift";
    rule.status = .enabled;
    
    let destination = QCloudBucketReplicationDestination.init();
    let destinationBucket = "{{{replicationDestBucket}}}";
    let region = "{{replicationDestBucketRegion}}";
    destination.bucket = "qcs::cos:\(region)::\(destinationBucket)";
    rule.destination = destination;
    rule.prefix = "a";
    
    config.rule = [rule];
    
    putBucketReplication.configuation = config;
    
    putBucketReplication.finishBlock = {(result,error) in
        XCTAssertNil(error);
        XCTAssertNotNil(result);
            if error != nil{
                print(error!);
            }else{
                print(result!);
            }
            exception.fulfill();
    }
    QCloudCOSXMLService.defaultCOSXML().putBucketRelication(putBucketReplication);
    self.wait(for: [exception], timeout: 100);
    // .cssg-body-end
}

func method16() {
    // .cssg-body-start: [swift-get-bucket-replication]
    let exception = XCTestExpectation.init(description: "getBucketReplication exception");
    let getBucketReplication = QCloudGetBucketReplicationRequest.init();
    getBucketReplication.bucket = "{{tempBucket}}";
    getBucketReplication.setFinish { (config, error) in
        XCTAssertNil(error);
        XCTAssertNotNil(config);
        if error != nil{
            print(error!);
        }else{
            print(config!);
        }
        exception .fulfill();
    }
    QCloudCOSXMLService.defaultCOSXML().getBucketReplication(getBucketReplication);
    self.wait(for: [exception], timeout: 100);
    // .cssg-body-end
}

func method17() {
    // .cssg-body-start: [swift-delete-bucket-replication]
    let exception = XCTestExpectation.init(description: "deleteBucketReplication exception");
    let deleteBucketReplication = QCloudDeleteBucketReplicationRequest.init();
    deleteBucketReplication.bucket = "{{tempBucket}}";
    deleteBucketReplication.finishBlock = {(result,error) in
        XCTAssertNil(error);
        XCTAssertNotNil(result);
        if error != nil{
            print(error!);
        }else{
            print(result!);
        }
        exception.fulfill();
    }
    QCloudCOSXMLService.defaultCOSXML().deleteBucketReplication(deleteBucketReplication);
    self.wait(for: [exception], timeout: 100);
    // .cssg-body-end
}

func method18() {
    // .cssg-body-start: [swift-transfer-upload-object]
    let exception = XCTestExpectation.init(description: "transfer-upload-object exception");
    let uploadRequest = QCloudCOSXMLUploadObjectRequest<AnyObject>.init();
    let dataBody:NSData? = "wrwrwrwrwrw".data(using: .utf8) as NSData?;
    uploadRequest.body = dataBody!;
    uploadRequest.bucket = "{{persistBucket}}";
    uploadRequest.object = "{{object}}";
    //设置上传参数
    uploadRequest.initMultipleUploadFinishBlock = {(multipleUploadInitResult,resumeData) in
        //在初始化分块上传完成以后会回调该 block，在这里可以获取 resumeData，并且可以通过 resumeData 生成一个分块上传的请求
        let resumeUploadRequest = QCloudCOSXMLUploadObjectRequest<AnyObject>.init(request: resumeData as Data?);
    }
    uploadRequest.sendProcessBlock = {(bytesSent , totalBytesSent , totalBytesExpectedToSend) in
        
    }
    uploadRequest.setFinish { (result, error) in
        XCTAssertNotNil(error);
        XCTAssertNil(result);
        if error != nil{
            print(error!)
        }else{
            //从 result 中获取请求的结果
            print(result!);
        }
        exception.fulfill();
    }
    
    QCloudCOSTransferMangerService.defaultCOSTransferManager().uploadObject(uploadRequest);
    
    //•••在完成了初始化，并且上传没有完成前
    var error:NSError?;
        //这里是主动调用取消，并且产生 resumetData 的例子
    do {
        let resumedData = try uploadRequest.cancel(byProductingResumeData: &error);
            var resumeUploadRequest:QCloudCOSXMLUploadObjectRequest<AnyObject>?;
                 resumeUploadRequest = QCloudCOSXMLUploadObjectRequest<AnyObject>.init(request: resumedData as Data?);
                 //生成的用于恢复上传的请求可以直接上传
        if resumeUploadRequest != nil {
            QCloudCOSTransferMangerService.defaultCOSTransferManager().uploadObject(resumeUploadRequest!);
        }
                 
    } catch  {
        print("resumeData 为空");
        return;
    }
     
    
    self.wait(for: [exception], timeout: 100);
    // .cssg-body-end
}

func method19() {
    // .cssg-body-start: [swift-transfer-copy-object]
    let copyRequest =  QCloudCOSXMLCopyObjectRequest.init();
    copyRequest.bucket = "{{persistBucket}}";//目的 <BucketName-APPID>，需要是公有读或者在当前账号有权限
    copyRequest.object = "{{object}}";//目的文件名称
    //文件来源 <BucketName-APPID>，需要是公有读或者在当前账号有权限
    copyRequest.sourceBucket = "{{{copySourceBucket}}}";
    copyRequest.sourceObject = "{{copySourceObject}}";//源文件名称
    copyRequest.sourceAPPID = "{{appId}}";//源文件的 APPID
    copyRequest.sourceRegion = "{{region}}";//来源的地域
    copyRequest.setFinish { (copyResult, error) in
        if error != nil{
            print(error!);
        }else{
            print(copyResult!);
        }
    }
    //注意如果是跨地域复制，这里使用的 transferManager 所在的 region 必须为目标桶所在的 region
    QCloudCOSTransferMangerService.defaultCOSTransferManager().copyObject(copyRequest);
    // .cssg-body-end
}

func method20() {
    // .cssg-body-start: [swift-get-bucket]
    let exception = XCTestExpectation.init(description: "getBucket exception");
    let getBucketReq = QCloudGetBucketRequest.init();
    getBucketReq.bucket = "{{persistBucket}}";
    getBucketReq.maxKeys = 1000;
    getBucketReq.setFinish { (result, error) in
        XCTAssertNil(error);
        XCTAssertNotNil(result);
        if error != nil{
            print(error!);
        }else{
            print( result!.commonPrefixes);
        }
        exception .fulfill();
    }
    QCloudCOSXMLService.defaultCOSXML().getBucket(getBucketReq);
    self.wait(for: [exception], timeout: 100);
    // .cssg-body-end
}

func method21() {
    // .cssg-body-start: [swift-put-object]
    let exception = XCTestExpectation.init(description: "putObject exception");
    let putObject = QCloudPutObjectRequest<AnyObject>.init();
    putObject.bucket = "{{persistBucket}}";
    let dataBody:NSData? = "wrwrwrwrwrw".data(using: .utf8) as NSData?;
    putObject.body =  dataBody!;
    putObject.object = "{{object}}";
    putObject.finishBlock = {(result,error) in
        XCTAssertNil(error);
        XCTAssertNotNil(result);
        if error != nil{
            print(error!);
        }else{
            print(result!);
        }
        exception .fulfill();
    }
    QCloudCOSXMLService.defaultCOSXML().putObject(putObject);
    self.wait(for: [exception], timeout: 100);
    // .cssg-body-end
}

func method22(){
    // .cssg-body-start: [swift-head-object]
    let exception = XCTestExpectation.init(description: "headObject exception");
    let headObject = QCloudHeadObjectRequest.init();
    headObject.bucket = "{{persistBucket}}";
    headObject.object  = "{{object}}";
    headObject.finishBlock =  {(result,error) in
        XCTAssertNil(error);
        XCTAssertNotNil(result);
        if error != nil{
            print(error!);
        }else{
            print(result!);
        }
        exception .fulfill();
    }
    QCloudCOSXMLService.defaultCOSXML().headObject(headObject);
    self.wait(for: [exception], timeout: 100);
    // .cssg-body-end
}

func method23() {
    // .cssg-body-start: [swift-get-object]
    let exception = XCTestExpectation.init(description: "getObject exception");
    let getObject = QCloudGetObjectRequest.init();
    getObject.bucket = "{{persistBucket}}";
    getObject.object = "{{object}}";
    getObject.downloadingURL = URL.init(string: NSTemporaryDirectory())!.appendingPathComponent(getObject.object);
    getObject.finishBlock = {(result,error) in
        
        XCTAssertNil(error);
        XCTAssertNotNil(result);
        if error != nil{
            print(error!);
        }else{
            print(result!);
        }
        exception .fulfill();
    };
    getObject.downProcessBlock = {(bytesDownload, totalBytesDownload,  totalBytesExpectedToDownload) in
        print("totalBytesDownload:\(totalBytesDownload) totalBytesExpectedToDownload:\(totalBytesExpectedToDownload)");
    }
    QCloudCOSXMLService.defaultCOSXML().getObject(getObject);
    self.wait(for: [exception], timeout: 100);
    // .cssg-body-end
}

func method24() {
    // .cssg-body-start: [swift-option-object]
    let exception = XCTestExpectation.init(description: "optionsObject exception");
    let optionsObject = QCloudOptionsObjectRequest.init();
    optionsObject.object = "{{object}}";
    optionsObject.origin = "http://www.qcloud.com";
    optionsObject.accessControlRequestMethod = "GET";
    optionsObject.accessControlRequestHeaders = "origin";
    optionsObject.bucket = "{{tempBucket}}";
    optionsObject.finishBlock = {(result,error) in
        XCTAssertNil(error);
        XCTAssertNotNil(result);
        if error != nil{
            print(error!);
        }else{
            print(result!);
        }
        exception .fulfill();
    }
    QCloudCOSXMLService.defaultCOSXML().optionsObject(optionsObject);
    self.wait(for: [exception], timeout: 100);
    // .cssg-body-end
}

func method25() {
    // .cssg-body-start: [swift-copy-object]
    let exception = XCTestExpectation.init(description: "getBucket exception");
    let putObjectCopy = QCloudPutObjectCopyRequest.init();
    putObjectCopy.bucket = "{{persistBucket}}";
    putObjectCopy.object = "{{object}}";
    putObjectCopy.objectCopySource = "{{{copySourceBucket}}}.cos.{{region}}.myqcloud.com/{{copySourceObject}}";
    putObjectCopy.setFinish { (result, error) in
        XCTAssertNil(error);
        XCTAssertNotNil(result);
        if error != nil{
            print(error!);
        }else{
            print(result!);
        }
        exception .fulfill();
    }
    QCloudCOSXMLService.defaultCOSXML().putObjectCopy(putObjectCopy);
    self.wait(for: [exception], timeout: 100);
    // .cssg-body-end
}

func method26() {
    // .cssg-body-start: [swift-delete-object]
    let exception = XCTestExpectation.init(description: "deleteObject exception");
    let deleteObject = QCloudDeleteObjectRequest.init();
    deleteObject.bucket = "{{persistBucket}}";
    deleteObject.object = "{{object}}";
    deleteObject.finishBlock = {(result,error)in
        XCTAssertNil(error);
        XCTAssertNotNil(result);
        if error != nil{
            print(error!);
        }else{
            print(result!);
        }
        exception .fulfill();
    }
    QCloudCOSXMLService.defaultCOSXML().deleteObject(deleteObject);
    self.wait(for: [exception], timeout: 100);
    // .cssg-body-end
}

func method27() {
    // .cssg-body-start: [swift-delete-multi-object]
    let exception = XCTestExpectation.init(description: "mutipleDel exception");
    let mutipleDel = QCloudDeleteMultipleObjectRequest.init();
    mutipleDel.bucket = "{{persistBucket}}";
    
    let info1 = QCloudDeleteObjectInfo.init();
    info1.key = "{{object}}";
    let info2 = QCloudDeleteObjectInfo.init();
    
    
    let deleteInfos = QCloudDeleteInfo.init();
    deleteInfos.objects = [info1];
    deleteInfos.quiet = false;
    mutipleDel.deleteObjects = deleteInfos;
    
    mutipleDel.setFinish { (result, error) in
        XCTAssertNil(error);
        XCTAssertNotNil(result);
        if error != nil{
            print(error!);
        }else{
            print(result!);
        }
        exception .fulfill();
    }
    QCloudCOSXMLService.defaultCOSXML().deleteMultipleObject(mutipleDel);
    self.wait(for: [exception], timeout: 100);
    // .cssg-body-end
}

func method28() {
    // .cssg-body-start: [swift-list-multi-upload]
    let exception = XCTestExpectation.init(description: "listParts exception");
    let listParts = QCloudListBucketMultipartUploadsRequest.init();
    listParts.bucket = "{{persistBucket}}";
    listParts.maxUploads = 100;
    listParts.setFinish { (result, error) in
        XCTAssertNil(error);
        XCTAssertNotNil(result);
        if error != nil{
            print(error!);
        }else{
            print(result!);
        }
        exception .fulfill();
    }
    QCloudCOSXMLService.defaultCOSXML().listBucketMultipartUploads(listParts);
    self.wait(for: [exception], timeout: 100);
    // .cssg-body-end
}

func method29() {
    // .cssg-body-start: [swift-init-multi-upload]
    let exception = XCTestExpectation.init(description: "initRequest exception");
    let initRequest = QCloudInitiateMultipartUploadRequest.init();
    initRequest.bucket = "{{persistBucket}}";
    initRequest.object = "{{object}}";
    initRequest.setFinish { (result, error) in
        XCTAssertNil(error);
        XCTAssertNotNil(result);
        if error != nil{
            print(error!);
        }else{
            //获取分块上传的 uploadId，后续的上传都需要这个 ID，请保存以备后续使用
            self.uploadId = result!.uploadId;
            print(result!.uploadId);
        }
        exception .fulfill();
    }
    QCloudCOSXMLService.defaultCOSXML().initiateMultipartUpload(initRequest);
    self.wait(for: [exception], timeout: 100);
    // .cssg-body-end
}

func method30() {
    // .cssg-body-start: [swift-upload-part]
    let exception = XCTestExpectation.init(description: "uploadPart exception");
    
    let uploadPart = QCloudUploadPartRequest<AnyObject>.init();
    uploadPart.bucket = "{{persistBucket}}";
    uploadPart.object = "{{object}}";
    uploadPart.partNumber = 1;
    //标识本次分块上传的 ID；使用 Initiate Multipart Upload 接口初始化分块上传时会得到一个 uploadId
    //该 ID 不但唯一标识这一分块数据，也标识了这分块数据在整个文件内的相对位置
    uploadPart.uploadId = "{{uploadId}}";
    if self.uploadId != nil {
         uploadPart.uploadId = self.uploadId!;
    }
   
    let dataBody:NSData? = "wrwrwrwrwrwwrwrwrwrwrwwrwrwrwrwrwwrwrwrwrwrwwrwrwrwrwrwwrwrwrwrwrwwrwrwrwrwrwwrwrwrwrwrwwrwrwrwrwrwwrwrwrwrwrwwrwrwrwrwrwwrwrwrwrwrwwrwrwrwrwrw".data(using: .utf8) as NSData?;
    uploadPart.body = dataBody!;
    uploadPart.setFinish { (result, error) in
        XCTAssertNil(error);
        XCTAssertNotNil(result);
        if error != nil{
            print(error!);
        }else{
            let mutipartInfo = QCloudMultipartInfo.init();
            //获取所上传分块的 etag
            mutipartInfo.eTag = result!.eTag;
            mutipartInfo.partNumber = "1";
        }
          exception .fulfill();
    }
    uploadPart.sendProcessBlock = {(bytesSent,totalBytesSent,totalBytesExpectedToSend) in
        //上传进度信息
        print("totalBytesSent:\(totalBytesSent) totalBytesExpectedToSend:\(totalBytesExpectedToSend)");
        
    }
    QCloudCOSXMLService.defaultCOSXML().uploadPart(uploadPart);
    self.wait(for: [exception], timeout: 100);
    // .cssg-body-end
}

func method31() {
    // .cssg-body-start: [swift-upload-part-copy]
    let exception = XCTestExpectation.init(description: "uploadPartCopy exception");
    let req = QCloudUploadPartCopyRequest.init();
    req.bucket = "{{persistBucket}}";
    req.object = "{{object}}";
    //源文件 URL 路径，可以通过 versionid 子资源指定历史版本
    req.source = "{{{copySourceBucket}}}.cos.{{region}}.myqcloud.com/{{copySourceObject}}";
    //在初始化分块上传的响应中，会返回一个唯一的描述符（upload ID）
    req.uploadID = "{{uploadId}}";
    if self.uploadId != nil {
        req.uploadID = self.uploadId!;
    }
    
    //标志当前分块的序号
    req.partNumber = 1;
    req.setFinish { (result, error) in
        XCTAssertNil(error);
        XCTAssertNotNil(result);
        if error != nil{
            print(error!);
        }else{
            let mutipartInfo = QCloudMultipartInfo.init();
            //获取所复制分块的 etag
            mutipartInfo.eTag = result!.eTag;
            mutipartInfo.partNumber = "1";
        }
          exception .fulfill();
    }
    QCloudCOSXMLService.defaultCOSXML().uploadPartCopy(req);
    self.wait(for: [exception], timeout: 100);
    // .cssg-body-end
}

func method32()  {
    // .cssg-body-start: [swift-list-parts]
    let exception = XCTestExpectation.init(description: "listParts exception");
    let req = QCloudListMultipartRequest.init();
    req.object = "{{object}}";
    req.bucket = "{{persistBucket}}";
    //在初始化分块上传的响应中，会返回一个唯一的描述符（upload ID）
    req.uploadId = "{{uploadId}}";
    if self.uploadId != nil {
        req.uploadId = self.uploadId!;
    }
    req.setFinish { (result, error) in
        XCTAssertNil(error);
        XCTAssertNotNil(result);
        if error != nil{
            print(error!);
        }else{
            //从 result 中获取已上传分块信息
            print(result!);
        }
        exception .fulfill();
    }
    
    QCloudCOSXMLService.defaultCOSXML().listMultipart(req);
    self.wait(for: [exception], timeout: 100);
    // .cssg-body-end
}

func method33()  {
    // .cssg-body-start: [swift-complete-multi-upload]
    let exception = XCTestExpectation.init(description: "complete exception");
    let  complete = QCloudCompleteMultipartUploadRequest.init();
    complete.bucket = "{{persistBucket}}";
    complete.object = "{{object}}";
    //本次要查询的分块上传的 uploadId，可从初始化分块上传的请求结果 QCloudInitiateMultipartUploadResult 中得到
    complete.uploadId = "{{uploadId}}";
    if self.uploadId != nil {
        complete.uploadId = self.uploadId!;
    }
    
    
    //已上传分块的信息
    let completeInfo = QCloudCompleteMultipartUploadInfo.init();
    if self.parts == nil {
        print("没有要完成的分块");
        return;
    }
   
     completeInfo.parts = self.parts!;
    complete.parts = completeInfo;
    complete.setFinish { (result, error) in
        XCTAssertNil(error);
        XCTAssertNotNil(result);
        if error != nil{
            print(error!)
        }else{
            //从 result 中获取上传结果
            print(result!);
        }
        exception .fulfill();
    }
    QCloudCOSXMLService.defaultCOSXML().completeMultipartUpload(complete);
    self.wait(for: [exception], timeout: 100);
    // .cssg-body-end
}

func method34(){
    // .cssg-body-start: [swift-abort-multi-upload]
    let exception = XCTestExpectation.init(description: "abort exception");
    let abort = QCloudAbortMultipfartUploadRequest.init();
    abort.bucket = "{{persistBucket}}";
    abort.object = "{{object}}";
    //本次要查询的分块上传的 uploadId，可从初始化分块上传的请求结果 QCloudInitiateMultipartUploadResult 中得到
    abort.uploadId = "{{uploadId}}";
    if self.uploadId != nil {
        abort.uploadId = self.uploadId!;
    }
    
    abort.finishBlock = {(result,error)in
        XCTAssertNil(error);
        XCTAssertNotNil(result);
        if error != nil{
            print(error!)
        }else{
            //可以从 outputObject 中获取 response 中 etag 或者自定义头部等信息
            print(result!);
        }
        exception .fulfill();
        
    }
    QCloudCOSXMLService.defaultCOSXML().abortMultipfartUpload(abort);
    self.wait(for: [exception], timeout: 100);
    // .cssg-body-end
}

func method35() {
    // .cssg-body-start: [swift-restore-object]
    let exception = XCTestExpectation.init(description: "restore exception");
    let restore = QCloudPostObjectRestoreRequest.init();
    restore.bucket = "{{persistBucket}}";
    restore.object = "object4swift";
    restore.restoreRequest.days = 10;
    restore.restoreRequest.casJobParameters.tier = .standard;
    restore.finishBlock = {(result,error)in
        if error != nil{
            print(error!)
        }else{
            //可以从 outputObject 中获取 response 中 etag 或者自定义头部等信息
            print(result!);
        }
        exception .fulfill();
    }
    QCloudCOSXMLService.defaultCOSXML().postObjectRestore(restore);
    
    self.wait(for: [exception], timeout: 100);
    // .cssg-body-end
}

func method36() {
    // .cssg-body-start: [swift-put-object-acl]
    let exception = XCTestExpectation.init(description: "putObjectACl exception");
    let putObjectACl = QCloudPutObjectACLRequest.init();
    putObjectACl.bucket = "{{persistBucket}}";
    putObjectACl.object = "{{object}}";
    let grantString = "id=\"{{appId}}\"";
    putObjectACl.grantFullControl = grantString;
    putObjectACl.finishBlock = {(result,error)in
        XCTAssertNil(error);
        XCTAssertNotNil(result);
        if error != nil{
            print(error!)
        }else{
            //可以从 outputObject 中获取 response 中 etag 或者自定义头部等信息
            print(result!);
        }
        exception .fulfill();
    }
    QCloudCOSXMLService.defaultCOSXML().putObjectACL(putObjectACl);
    self.wait(for: [exception], timeout: 100);
    // .cssg-body-end
}

func method37() {
    // .cssg-body-start: [swift-get-object-acl]
    let exception = XCTestExpectation.init(description: "getObjectACL exception");
    let getObjectACL = QCloudGetObjectACLRequest.init();
    getObjectACL.bucket = "{{persistBucket}}";
    getObjectACL.object = "{{object}}";
    getObjectACL.setFinish { (result, error) in
        XCTAssertNil(error);
        XCTAssertNotNil(result);
        if error != nil{
            print(error!)
        }else{
            //可以从 result 的 accessControlList 中获取对象的 ACL
            print(result!.accessControlList);
        }
        exception .fulfill();
    }
    QCloudCOSXMLService.defaultCOSXML().getObjectACL(getObjectACL);
    self.wait(for: [exception], timeout: 100);
    // .cssg-body-end
}

func method48() {
    // .cssg-body-start: [swift-get-presign-download-url]
    let exception = XCTestExpectation.init(description: "putObjectACl exception");
    let getPresign  = QCloudGetPresignedURLRequest.init();
    getPresign.bucket = "{{persistBucket}}" ;
    getPresign.httpMethod = "GET";
    getPresign.object = "{{object}}";
    getPresign.setFinish { (result, error) in
        XCTAssertNil(error);
        XCTAssertNotNil(result);
        if error == nil{
            print(result?.presienedURL as Any);
        }
        exception .fulfill();
    }
    QCloudCOSXMLService.defaultCOSXML().getPresignedURL(getPresign);
    self.wait(for: [exception], timeout: 100);
    // .cssg-body-end
}

}
