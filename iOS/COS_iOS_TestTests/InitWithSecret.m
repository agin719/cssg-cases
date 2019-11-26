//
//  InitWithSecret.m
//  COS_iOS_TestTests
//
//  Created by wjielai on 2019/11/25.
//  Copyright © 2019 tencentyun.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QCloudCOSXML/QCloudCOSXML.h>

@interface InitWithSecret : NSObject

@end

@implementation InitWithSecret

// .cssg-body-start: [global-init-signature]
- (void) signatureWithFields:(QCloudSignatureFields*)fileds
                     request:(QCloudBizHTTPRequest*)request
                  urlRequest:(NSMutableURLRequest*)urlRequst
                   compelete:(QCloudHTTPAuthentationContinueBlock)continueBlock
{
    
    QCloudCredential* credential = [QCloudCredential new];
    credential.secretID = @"COS_SECRETID";
    credential.secretKey = @"COS_SECRETKEY";
    QCloudAuthentationV5Creator* creator = [[QCloudAuthentationV5Creator alloc] initWithCredential:credential];
    QCloudSignature* signature =  [creator signatureForData:urlRequst];
    continueBlock(signature, nil);
}
// .cssg-body-end

@end
