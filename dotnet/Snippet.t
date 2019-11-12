            CosXmlConfig config = new CosXmlConfig.Builder()
                .SetRegion({{{region}}})
                .SetAppid({{{appId}}})
                .Build();

            QCloudCredentialProvider qCloudCredentialProvider = new DefaultQCloudCredentialProvider({{{secretId}}}, 
                    {{{secretKey}}}, 600);

            CosXml service = new CosXmlServer(config, qCloudCredentialProvider);

{{{bodyBlock}}}