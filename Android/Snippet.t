CosXmlServiceConfig serviceConfig = new CosXmlServiceConfig.Builder()
       .isHttps(true) // 设置 Https 请求
       .setRegion("{{{region}}}") // 设置默认的存储桶地域
       .builder();

// 构建一个从临时密钥服务器拉取临时密钥的 Http 请求
HttpRequest<String> httpRequest = null;
try {
   httpRequest = new HttpRequest.Builder<String>()
           .url(new URL("{{{signUrl}}}"))
           .build();
} catch (MalformedURLException e) {
   e.printStackTrace();
}
QCloudCredentialProvider credentialProvider = new SessionCredentialProvider(httpRequest);
credentialProvider = new ShortTimeCredentialProvider({{{secretId}}}, {{{secretKey}}}, 3600); // for ut
CosXmlService cosXmlService = new CosXmlService(context, serviceConfig, credentialProvider);

{{{bodyBlock}}}
