## 工具安装

```shell
npm install -g cssg 
```

## 工具使用

### 1. 生成单元测试文件

```shell
cssg build
```

### 2. 写入代码段到文档

```shell
cssg write
```

### 可选参数

#### docs

指定本地文档目录

```
cssg build --docs=/Users/wjielai/Workspace/cssg-cases/docRepo
```


## C环境变量

CI 变量是代码中可使用的，不是模版需要的变量。

```js
COS_KEY  // secretId
COS_SECRET // secretKey
COS_APPID // appId
```
