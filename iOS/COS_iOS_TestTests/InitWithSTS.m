//
//  Init.m
//  COS_iOS_TestTests
//
//  Created by wjielai on 2019/11/25.
//  Copyright © 2019 tencentyun.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QCloudCOSXML/QCloudCOSXML.h>

@interface InitWithSTS : NSObject

@end

@implementation InitWithSTS

// .cssg-body-start: [global-init-signature-sts]
- (void) signatureWithFields:(QCloudSignatureFields*)fileds
                     request:(QCloudBizHTTPRequest*)request
                  urlRequest:(NSMutableURLRequest*)urlRequst
                   compelete:(QCloudHTTPAuthentationContinueBlock)continueBlock
{
    /*向签名服务器请求临时的 Secret ID,Secret Key,Token*/
    QCloudCredential* credential = [QCloudCredential new];
    credential.secretID = @"COS_SECRETID";
    credential.secretKey = @"COS_SECRETKEY";
    credential.token = @"COS_TOKEN";
    /*强烈建议返回服务器时间作为签名的开始时间，用来避免由于用户手机本地时间偏差过大导致的签名不正确 */
    credential.startDate = [[[NSDateFormatter alloc] init] dateFromString:@"start-time"];
    credential.experationDate  = [[[NSDateFormatter alloc] init] dateFromString:@"expire-time"];
    QCloudAuthentationV5Creator* creator = [[QCloudAuthentationV5Creator alloc] initWithCredential:credential];
    QCloudSignature* signature =  [creator signatureForData:urlRequst];
    continueBlock(signature, nil);
}
// .cssg-body-end

@end
