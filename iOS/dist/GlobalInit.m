#import <XCTest/XCTest.h>
#import <QCloudCOSXML/QCloudCOSXML.h>
#import <SecretStorage.h>
#import <QCloudCOSXML/QCloudUploadPartRequest.h>
#import <QCloudCOSXML/QCloudCompleteMultipartUploadRequest.h>
#import <QCloudCOSXML/QCloudAbortMultipfartUploadRequest.h>

@interface GlobalInitTest : XCTestCase <QCloudSignatureProvider>

@property (nonatomic) QCloudCredentailFenceQueue* credentialFenceQueue;

@end

@implementation GlobalInitTest

- (void)setUp {
    
}

- (void)tearDown {
    
}

//AppDelegate.m
//第一步：注册默认的cos服务
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

//第二步：实现QCloudSignatureProvider协议
//实现签名的过程，我们推荐在服务器端实现签名的过程，具体请参考接下来的 “生成签名” 这一章。


@end