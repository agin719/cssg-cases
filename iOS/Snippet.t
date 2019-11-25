QCloudServiceConfiguration* configuration = [QCloudServiceConfiguration new];
configuration.appID = @"{{appId}}";
// 签名提供者，这里假设由当前实例提供
configuration.signatureProvider = self;
QCloudCOSXMLEndPoint* endpoint = [[QCloudCOSXMLEndPoint alloc] init];
endpoint.regionName = @"{{region}}";
endpoint.useHTTPS = YES;
configuration.endpoint = endpoint;

[QCloudCOSXMLService registerDefaultCOSXMLWithConfiguration:configuration];
[QCloudCOSTransferMangerService registerDefaultCOSTransferMangerWithConfiguration:configuration];

{{{bodyBlock}}}