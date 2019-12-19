#import <XCTest/XCTest.h>
#import <QCloudCOSXML/QCloudCOSXML.h>
#import <SecretStorage.h>
#import <QCloudCOSXML/QCloudUploadPartRequest.h>
#import <QCloudCOSXML/QCloudCompleteMultipartUploadRequest.h>
#import <QCloudCOSXML/QCloudAbortMultipfartUploadRequest.h>
#import <QCloudCOSXML/QCloudMultipartInfo.h>
#import <QCloudCOSXML/QCloudCompleteMultipartUploadInfo.h>

@interface globalInitTest : NSObject
@property (nonatomic) QCloudCredentailFenceQueue* credentialFenceQueue;
@end

@implementation globalInitTest

    //.cssg-snippet-body-start:[global-init]
    //AppDelegate.m
    //第一步：注册默认的 COS 服务
    - (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
        QCloudServiceConfiguration* configuration = [QCloudServiceConfiguration new];
        configuration.appID = @"1253653367";
        configuration.signatureProvider = self;
        QCloudCOSXMLEndPoint* endpoint = [[QCloudCOSXMLEndPoint alloc] init];
        endpoint.regionName = @"ap-guangzhou";//服务地域名称，可用的地域请参考注释
        configuration.endpoint = endpoint;
        [QCloudCOSXMLService registerDefaultCOSXMLWithConfiguration:configuration];
        [QCloudCOSTransferMangerService registerDefaultCOSTransferMangerWithConfiguration:configuration];
        return YES;
    }
    
    //第二步：实现 QCloudSignatureProvider 协议
    //实现签名的过程，我们推荐在服务器端实现签名的过程，详情请参考接下来的 “生成签名” 这一章。
    //.cssg-snippet-body-end

@end

@interface globalInitFenceQueueTest : NSObject
@property (nonatomic) QCloudCredentailFenceQueue* credentialFenceQueue;
@end

@implementation globalInitFenceQueueTest

    //.cssg-snippet-body-start:[global-init-fence-queue]
    //AppDelegate.m
    
    //这里定义一个成员变量 @property (nonatomic) QCloudCredentailFenceQueue* credentialFenceQueue;
    
    - (void) fenceQueue:(QCloudCredentailFenceQueue * )queue requestCreatorWithContinue:(QCloudCredentailFenceQueueContinue)continueBlock
    {
        QCloudCredential* credential = [QCloudCredential new];
        //在这里可以同步过程从服务器获取临时签名需要的 secretID，secretKey，expiretionDate 和 token 参数
        credential.secretID = [SecretStorage sharedInstance].secretID;
        credential.secretKey = [SecretStorage sharedInstance].secretKey;
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
    //.cssg-snippet-body-end

@end

@interface globalInitSignatureTest : NSObject
@property (nonatomic) QCloudCredentailFenceQueue* credentialFenceQueue;
@end

@implementation globalInitSignatureTest

    //.cssg-snippet-body-start:[global-init-signature]
    - (void) signatureWithFields:(QCloudSignatureFields*)fileds
                         request:(QCloudBizHTTPRequest*)request
                      urlRequest:(NSMutableURLRequest*)urlRequst
                       compelete:(QCloudHTTPAuthentationContinueBlock)continueBlock
    {
        
        QCloudCredential* credential = [QCloudCredential new];
        credential.secretID = [SecretStorage sharedInstance].secretID;
        credential.secretKey = [SecretStorage sharedInstance].secretKey;
        QCloudAuthentationV5Creator* creator = [[QCloudAuthentationV5Creator alloc] initWithCredential:credential];
        QCloudSignature* signature =  [creator signatureForData:urlRequst];
        continueBlock(signature, nil);
    }
    //.cssg-snippet-body-end

@end

@interface globalInitSignatureStsTest : NSObject
@property (nonatomic) QCloudCredentailFenceQueue* credentialFenceQueue;
@end

@implementation globalInitSignatureStsTest

    //.cssg-snippet-body-start:[global-init-signature-sts]
    - (void) signatureWithFields:(QCloudSignatureFields*)fileds
                         request:(QCloudBizHTTPRequest*)request
                      urlRequest:(NSMutableURLRequest*)urlRequst
                       compelete:(QCloudHTTPAuthentationContinueBlock)continueBlock
    {
        /*向签名服务器请求临时的 Secret ID,Secret Key,Token*/
        QCloudCredential* credential = [QCloudCredential new];
        credential.secretID = [SecretStorage sharedInstance].secretID;
        credential.secretKey = [SecretStorage sharedInstance].secretKey;
        credential.token = @"COS_TOKEN";
        /*强烈建议返回服务器时间作为签名的开始时间，用来避免由于用户手机本地时间偏差过大导致的签名不正确 */
        credential.startDate = [[[NSDateFormatter alloc] init] dateFromString:@"start-time"];
        credential.experationDate  = [[[NSDateFormatter alloc] init] dateFromString:@"expire-time"];
        QCloudAuthentationV5Creator* creator = [[QCloudAuthentationV5Creator alloc] initWithCredential:credential];
        QCloudSignature* signature =  [creator signatureForData:urlRequst];
        continueBlock(signature, nil);
    }
    //.cssg-snippet-body-end

@end

