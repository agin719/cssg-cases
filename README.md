## 工具安装

```shell
npm install -g cssg 
```

## 工具使用

### 1. 编写 Assembly 文件和模版文件

`Assembly 文件内的代码块跟 Snippet 模版文件共同生成文档中的示例代码 S，后期会自动插入文档中。`

`产出的示例代码 S 跟 TestCase 模版文件共同生成测试用例 T。`

### 2. 编写配置文件

根目录下的 `cssg.json` 文件记录了SDK的相关信息，配置说明如下：

```json
{
  // 语言
  "language": "iOS",
  // Assembly源文件所在相对目录
  "sourcesRoot": "COS_iOS_TestTests/",
  // 源文件扩展名
  "sourceExtension": ".m",

  // 文档所在相对目录
  "docsRoot": "docs",
  // 文档扩展名
  "docExtension": ".md",
  // 编译生成用例的目录，默认是 dist
  "compileDist": "dist",

  // 代码段模块文件
  "snippetTemplate": "Snippet.t",
  // 测试用例模版文件
  "testcaseTemplate": "TestCase.t",
  // 特殊用例模版文件
  "exclusiveTemplate": {
    "global-init": "TestCaseDelegate.t",
    "global-init-fence-queue": "TestCaseDelegate.t",
    "global-init-signature-sts": "TestCaseDelegate.t",
    "global-init-signature": "TestCaseDelegate.t"
  },
  // 用例需要而文档应该忽略的表达式
  "ignoreExpressionInDoc": [
    "XCTestExpectation\\*\\s+exp\\s*=\\s*.+;",
    "\\[exp\\s+fulfill\\];",
    "\\[self\\s+waitForExpectationsWithTimeout:\\d+ handler:nil\\];",
    "XCTAssertNotNil\\(.+\\);",
    "XCTAssertNil\\(.+\\);",
    ".+\\s*=\\s*self\\.uploadId;",
    "self\\.parts\\s*=\\s*.+;",
    "\\[self\\.parts\\s*.+\\];"
  ],

  // 用于文档的变量定义
  "macro4doc": {
    "secretId": "\"${g.secretId}\"", // secretId
    "secretKey": "\"${g.secretKey}\"" // secretKey
  },
  // 用于测试的变量定义，作用域是 SDK 内部，同名会覆盖全局变量
  "macro4test": {
    "secretId": "Environment.GetEnvironmentVariable(\"COS_KEY\")", // secretId
    "secretKey": "Environment.GetEnvironmentVariable(\"COS_SECRET\")", // secretKey
    "tempBucket": "bucket-cssg-dotnet-temp-1253653367", // 临时bucket，用于bucket所有操作
    "object": "object4dotnet" // 临时对象，用于对象操作
  }
}
```

### 3. 编译

```shell
cd iOS # SDK所在目录，以 iOS 为例
cssg compile
```

编译会生成可测试单元文件，在预设的目录下。

### 4. 执行单元测试

命令各 SDK 有不同。将命令保存到一个名为 `build.sh` 文件放在根目录下。

## 引用变量

变量可以在 Assembley 跟 模版文件中 使用，引用方式为：

```js
{{变量名}} // 自动对变量值进行 html 转义
{{{变量名}}} // 变量值保留原始串，不进行 html 不转义
```

由于文档中的示例代码跟单元测试的代码中引用的资源，例如 bucket，appid，object 等不同，`请在代码中使用变量`，而不是直接 hardcode。

所有变量说明见下面章节。

## 变量定义

### 全局变量

```json
{
    "appId": "1253653367",
    "uin": "1278687956",
    "persistBucket": "bucket-cssg-test-1253653367", // 预设bucket，用于 Object 操作
    "region": "ap-guangzhou", // bucket所在地域
    "copySourceBucket":"bucket-cssg-test-1253653367", // 用于拷贝测试需要的源文件所在bucket
    "copySourceObject": "sourceObject", // 用于拷贝测试需要的源文件
    "replicationDestBucket":"bucket-cssg-assist-1253653367", // 用于跨区域复制测试需要的目标桶
    "replicationDestBucketRegion": "ap-beijing", // 用于跨区域复制测试需要的目标桶所在地域
    "uploadId": "example-uploadId" // 分片上传 uploadId
}
```

### SDK 局部变量

除了全局变量，还可以定义 SDK 内的局部变量，见下面配置文件说明。

```json
{
  // 用于测试的变量定义，作用域是 SDK 内部，同名会覆盖全局变量
  "macro4test": {
    "secretId": "Environment.GetEnvironmentVariable(\"COS_KEY\")", // secretId
    "secretKey": "Environment.GetEnvironmentVariable(\"COS_SECRET\")", // secretKey
    "tempBucket": "bucket-cssg-dotnet-temp-1253653367", // 临时bucket，用于bucket所有操作
    "object": "object4dotnet" // 临时对象，用于对象操作
  }
}
```

### Snippet 模版文件变量定义

```json
{
  "bodyBlock": "代码段（不包括初始化服务）"
}
bodyBlock
```

####  举例

```C#
CosXmlConfig config = new CosXmlConfig.Builder()
  .SetConnectionTimeoutMs(60000)  //设置连接超时时间，单位毫秒 ，默认 45000ms
  .SetReadWriteTimeoutMs(40000)  //设置读写超时时间，单位毫秒 ，默认 45000ms
  .IsHttps(true)  //设置默认 https 请求
  .SetAppid("{{{appId}}}") //设置腾讯云账户的账户标识 APPID
  .SetRegion("{{{region}}}") //设置一个默认的存储桶地域
  .Build();

string secretId = {{{secretId}}};   //云 API 密钥 SecretId
string secretKey = {{{secretKey}}}; //云 API 密钥 SecretKey
long durationSecond = 600;          //每次请求签名有效时长,单位为 秒
QCloudCredentialProvider qCloudCredentialProvider = new DefaultQCloudCredentialProvider(secretId, 
  secretKey, durationSecond);

CosXml cosXml = new CosXmlServer(config, qCloudCredentialProvider);

{{{bodyBlock}}}
```

### TestCase 模版文件变量定义

```json
{
  "name": "测试用例名称，例如 PutObject",
  "isDemo": "false", // 生成 testcase 为 false，生成 demo 为 true
  "steps": [
    {
      "name": "代码名，例如 PutObject",
      "snippet": "代码"
    }
  ],
  "setupBlock": "setup 代码段",
  "teardownBlock": "teardown 代码段",
}
```

#### 举例

```C#
public class {{name}}Sample {

  string uploadId;

  {{#steps}}
  public void {{name}}()
  {
    {{{snippet}}}
  }
  
  {{/steps}}

  [SetUp()]
  public void setup() {
    {{{setupBlock}}}
  }

  [Test()]
  public void test{{name}}() {
    // isDemo = true 时不执行测试，仅编译，这里必须加上判断
    {{^isDemo}} 
    {{#steps}}
    {{name}}();
    {{/steps}}
    {{/isDemo}}
  }

  [TearDown()]
  public void teardown() {
    {{{teardownBlock}}}
  }
}
```

## CI 环境变量

CI 变量是代码中可使用的，不是模版需要的变量。

```js
COS_KEY  // secretId
COS_SECRET // secretKey
COS_APPID // appId
```
