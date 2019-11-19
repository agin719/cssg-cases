    QCloudServiceConfiguration* configuration = [QCloudServiceConfiguration new];
    configuration.appID = @"{{appId}}";
    configuration.signatureProvider = self;
    QCloudCOSXMLEndPoint* endpoint = [[QCloudCOSXMLEndPoint alloc] init];
    endpoint.regionName = @"{{region}}";
    endpoint.useHTTPS = YES;
    configuration.endpoint = endpoint;
   
    [QCloudCOSXMLService registerDefaultCOSXMLWithConfiguration:configuration];
    [QCloudCOSTransferMangerService registerDefaultCOSTransferMangerWithConfiguration:configuration];

{{{bodyBlock}}}