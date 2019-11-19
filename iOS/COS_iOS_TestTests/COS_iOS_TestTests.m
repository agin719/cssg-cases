//
//  COS_iOS_TestTests.m
//  COS_iOS_TestTests
//
//  Created by karisli(李雪) on 2019/11/13.
//  Copyright © 2019 tencentyun.com. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <QCloudCOSXML/QCloudCOSXML.h>

// cssg-snippet-lang: [iOS]
@interface COS_iOS_TestTests : NSObject

@end

@implementation COS_iOS_TestTests

- (void)test1 {
    XCTestExpectation* exp = nil;
    // .cssg-body-start: [get-object]
    QCloudGetObjectRequest* request = [QCloudGetObjectRequest new];
    //设置下载的路径 URL，如果设置了，文件将会被下载到指定路径中.如果该参数没有设置，那么文件将会被下载至内存里，存放在在 finishBlock 的     outputObject 里。
    request.downloadingURL = [NSURL URLWithString:QCloudTempFilePathWithExtension(@"downding")];
    request.object = @"your-cos-key";
    request.bucket = @"{{bucket}}";
    [request setFinishBlock:^(id outputObject, NSError *error) {
        NSLog(@"%@", outputObject);
        XCTAssertNil(error);
        [exp fulfill];
        //additional actions after finishing
       //可以从 outputObject 中获取 response 中 etag 或者自定义头部等信息（更多头部信息可以通过打印 outputObject 查看）
    }];
    [request setDownProcessBlock:^(int64_t bytesDownload, int64_t totalBytesDownload, int64_t totalBytesExpectedToDownload) {
       //下载过程中的进度
    }];
    NSLog(@"%@", [QCloudCOSXMLService defaultCOSXML]);
    [[QCloudCOSXMLService defaultCOSXML] GetObject:request];
    // .cssg-body-end
}

- (void)test2 {
    XCTestExpectation* exp = nil;
    // .cssg-body-start: [put-object]
    QCloudPutObjectRequest* put = [QCloudPutObjectRequest new];
    put.object = @"your-cos-key";
    put.bucket = @"{{bucket}}";
    put.body =  [@"testFileContent" dataUsingEncoding:NSUTF8StringEncoding];
    [put setFinishBlock:^(id outputObject, NSError *error) {
        XCTAssertNil(error);
        [exp fulfill];
       //完成回调
      //可以从 outputObject 中获取 response 中 etag 或者自定义头部等信息（更多头部信息可以通过打印 outputObject 查看）
      if (nil == error) {
          NSLog(@"%@", outputObject);
       //成功
       }
       }];
    [[QCloudCOSXMLService defaultCOSXML] PutObject:put];
    // .cssg-body-end
}

@end
