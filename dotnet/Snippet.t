            CosXmlConfig config = new CosXmlConfig.Builder()
                .SetConnectionTimeoutMs(60000)  //设置连接超时时间，单位毫秒 ，默认 45000ms
	            .SetReadWriteTimeoutMs(40000)  //设置读写超时时间，单位毫秒 ，默认 45000ms
	            .IsHttps(true)  //设置默认 https 请求
                .SetAppid({{{appId}}}) //设置腾讯云账户的账户标识 APPID
                .SetRegion({{{region}}}) //设置一个默认的存储桶地域
                .Build();

            string secretId = {{{secretId}}};   //云 API 密钥 SecretId
            string secretKey = {{{secretKey}}}; //云 API 密钥 SecretKey
            long durationSecond = 600;          //每次请求签名有效时长,单位为 秒
            QCloudCredentialProvider qCloudCredentialProvider = new DefaultQCloudCredentialProvider(secretId, 
                    secretKey, durationSecond);

            CosXml service = new CosXmlServer(config, qCloudCredentialProvider);

{{{bodyBlock}}}