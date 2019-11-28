## 工具安装

```shell
npm install -g cssg 
```

## 工具使用

### 1. 编写 Assembly 源文件， TestCasse 模版文件

`Assembly 文件内的代码块 跟 TestCase 模版文件共同生成测试用例 T。`

### 2. 编写配置文件

根目录下的 `cssg.json` 文件记录了SDK的相关信息，配置说明如下：

```json
{
  // 语言,必须全小写
  "language": "ios",
  // Assembly 源文件所在相对目录
  "sourcesRoot": "COS_iOS_TestTests/",
  // Assembly 源文件扩展名
  "sourceExtension": ".m",

  // 测试用例模版文件
  "testcaseTemplate": "TestCase.t",
  // 用例需要而文档应该忽略的表达式
  "ignoreExpressionInDoc": [
    "XCTAssertNotNil\\(.+\\);",
    ".+\\s*=\\s*self\\.uploadId;",
    "\\[self\\.parts\\s*.+\\];"
  ],

  // 用于文档的变量定义
  "macro4doc": {
  },
  // 用于测试的变量定义，作用域是 SDK 内部，同名会覆盖全局变量
  "macro4test": {
    "secretId": "Environment.GetEnvironmentVariable(\"COS_KEY\")", // secretId
    "secretKey": "Environment.GetEnvironmentVariable(\"COS_SECRET\")" // secretKey
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

变量可以在 Assembley 跟 Snippet 模版文件中 使用，引用方式为：

```js
{{变量名}} // 自动对变量值进行 html 转义
{{{变量名}}} // 变量值保留原始串，不进行 html 不转义
```

由于文档中的示例代码跟单元测试的代码中引用的资源，例如 bucket，appid，object 等不同，`请在代码中使用变量`，而不是直接 hardcode。

所有变量说明见下面章节。

## 变量定义

### 预设的全局变量

```json
{
    "appId": "1253653367",
    "uin": "1278687956",
    "region": "ap-guangzhou", // bucket所在地域
    "copySourceBucket":"bucket-cssg-test-1253653367", // 用于拷贝测试需要的源文件所在bucket
    "copySourceObject": "sourceObject", // 用于拷贝测试需要的源文件
    "replicationDestBucket":"bucket-cssg-assist-1253653367", // 用于跨区域复制测试需要的目标桶
    "replicationDestBucketRegion": "ap-beijing", // 用于跨区域复制测试需要的目标桶所在地域
    "uploadId": "xxx-uploadId", // 分片上传 uploadId
    "persistBucket": "bucket-cssg-test-1253653367", // 预设 bucket，用于 Object 操作
    "tempBucket": "bucket-cssg-xxx-temp-1253653367", // 临时bucket，用于 Bucket 操作
    "object": "object4xxx" // 临时对象，用于 Object 操作
}
```

### SDK 局部变量

除了全局变量，还可以定义 SDK 内的局部变量，同名会覆盖全局变量。

```json
{
  // 用于测试的变量定义，作用域是 SDK 内部
  "macro4test": {
    "secretId": "Environment.GetEnvironmentVariable(\"COS_KEY\")", // secretId
    "secretKey": "Environment.GetEnvironmentVariable(\"COS_SECRET\")" // secretKey
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
