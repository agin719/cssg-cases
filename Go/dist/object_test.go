package cos;

import (
	"context"
	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/suite"
	"github.com/tencentyun/cos-go-sdk-v5"
	"net/http"
	"net/url"
	"os"
	"testing"
)

type CosTestSuite struct {
	suite.Suite
	VariableThatShouldStartAtFive int

	// CI client
	Client *cos.Client

	// Copy source client
	CClient *cos.Client

	// test_object
	TestObject string

	// special_file_name
	SepFileName string
}

func (s *CosTestSuite) SetupSuite() {
  //.cssg-snippet-body-start:[global-init]
  // 将<BucketName-APPID>和<region>修改为真实的信息
  // 例如：http://bucket-cssg-test-go-1253653367.cos.ap-guangzhou.myqcloud.com
  u, _ := url.Parse("http://<BucketName-APPID>.cos.<region>.myqcloud.com")
  b := &cos.BaseURL{BucketURL: u}
  // 1.永久密钥
  client := cos.NewClient(b, &http.Client{
      Transport: &cos.AuthorizationTransport{
          SecretID: os.Getenv("COS_KEY"),
          SecretKey: os.Getenv("COS_SECRET"),                      
      },                                 
  })
  assert.Nil(s.T(), err, "Test Failed")
  //.cssg-snippet-body-end
  s.Client = client

  putBucket()
}

func (s *CosTestSuite) TearDownSuite() {
  deleteObject()
  deleteBucket()
}

func (s *CosTestSuite) putBucket() {
  client := s.Client
  //.cssg-snippet-body-start:[put-bucket]
  opt := &cos.BucketPutOptions{
      XCosACL: "public-read",
  }
  resp, err := client.Bucket.Put(context.Background(), opt)
  //.cssg-snippet-body-end
}

func (s *CosTestSuite) deleteObject() {
  client := s.Client
  //.cssg-snippet-body-start:[delete-object]
  key := "test/objectPut.go"
  resp, err := client.Object.Delete(context.Background(), key)
  assert.Nil(s.T(), err, "Test Failed")
  //.cssg-snippet-body-end
}

func (s *CosTestSuite) deleteBucket() {
  client := s.Client
  //.cssg-snippet-body-start:[delete-bucket]
  resp, err := client.Bucket.Delete(context.Background())
  //.cssg-snippet-body-end
}

func (s *CosTestSuite) putObject() {
  client := s.Client
  //.cssg-snippet-body-start:[put-object]
  key := "put_option.go"
  f, err := os.Open("./test")
  opt := &cos.ObjectPutOptions{
      ObjectPutHeaderOptions: &cos.ObjectPutHeaderOptions{
          ContentType: "text/html",
      },
      ACLHeaderOptions: &cos.ACLHeaderOptions{
          // 如果不是必要操作，建议上传文件时不要给单个文件设置权限，避免达到限制。若不设置默认继承桶的权限。
          XCosACL: "private",
      },
  }
  resp, err = client.Object.Put(context.Background(), key, f, opt)
  assert.Nil(s.T(), err, "Test Failed")
  //.cssg-snippet-body-end
}

func (s *CosTestSuite) putObjectAcl() {
  client := s.Client
  //.cssg-snippet-body-start:[put-object-acl]
  // 1.Set by header
  opt := &cos.ObjectPutACLOptions{
      Header: &cos.ACLHeaderOptions{
          XCosACL: "private",
      },
  }
  key := "test/hello.txt"
  resp, err := client.Object.PutACL(context.Background(), key, opt)
  // 2.Set by body
  opt = &cos.ObjectPutACLOptions{
      Body: &cos.ACLXml{
          Owner: &cos.Owner{
              ID: "qcs::cam::uin/100000760461:uin/100000760461",
          },
          AccessControlList: []cos.ACLGrant{
              {
                  Grantee: &cos.ACLGrantee{
                      Type: "RootAccount",
                      ID:   "qcs::cam::uin/100000760461:uin/100000760461",
                  },
  
                  Permission: "FULL_CONTROL",
              },
          },
      },
  }
  
  resp, err = client.Object.PutACL(context.Background(), key, opt)
  assert.Nil(s.T(), err, "Test Failed")
  //.cssg-snippet-body-end
}

func (s *CosTestSuite) getObjectAcl() {
  client := s.Client
  //.cssg-snippet-body-start:[get-object-acl]
  key := "test/hello.txt"
  v, resp, err := client.Object.GetACL(context.Background(), key)
  assert.Nil(s.T(), err, "Test Failed")
  //.cssg-snippet-body-end
}

func (s *CosTestSuite) headObject() {
  client := s.Client
  //.cssg-snippet-body-start:[head-object]
  key := "test/hello.txt"
  resp, err := client.Object.Head(context.Background(), key, nil)
  assert.Nil(s.T(), err, "Test Failed")
  //.cssg-snippet-body-end
}

func (s *CosTestSuite) getObject() {
  client := s.Client
  //.cssg-snippet-body-start:[get-object]
  key := "test/hello.txt"
  opt := &cos.ObjectGetOptions{
      ResponseContentType: "text/html",
      Range:               "bytes=0-3",
  }
  // opt 可选，无特殊设置可设为 nil
  // 1. Get object by resp body.
  resp, err := client.Object.Get(context.Background(), key, opt)
  bs, _ = ioutil.ReadAll(resp.Body)
  resp.Body.Close()
  fmt.Printf("%s\n", string(bs))
  
  // 2.Get object to local file.
  _, err = c.Object.GetToFile(context.Background(), key, "hello_1.txt", nil)
  if err != nil {
      panic(err)
  }
  assert.Nil(s.T(), err, "Test Failed")
  //.cssg-snippet-body-end
}

func (s *CosTestSuite) getPresignDownloadUrl() {
  client := s.Client
  //.cssg-snippet-body-start:[get-presign-download-url]
  ak := os.Getenv("COS_KEY")
  sk := os.Getenv("COS_SECRET")
  u, _ := url.Parse("http://bucket-cssg-test-go-1253653367.cos.ap-guangzhou.myqcloud.com")
  b := &cos.BaseURL{BucketURL: u}
  c := cos.NewClient(b, &http.Client{
     Transport: &cos.AuthorizationTransport{
        SecretID:  ak,
        SecretKey: sk,
     },
  })
  
  name := "test"
  ctx := context.Background()
  // 1.Normal add auth header way to get object
  resp, err := c.Object.Get(ctx, name, nil)
  if err != nil {
      panic(err)
  } 
  bs, _ := ioutil.ReadAll(resp.Body)
  resp.Body.Close()
  // Get presigned
  presignedURL, err := c.Object.GetPresignedURL(ctx, http.MethodGet, name, ak, sk, time.Hour, nil)
  if err != nil {
      panic(err)
  } 
  // 2.Get object content by presinged url
  resp2, err := http.Get(presignedURL.String())
  if err != nil {
      panic(err)
  }                    
  bs2, _ := ioutil.ReadAll(resp2.Body)
  resp2.Body.Close()
  fmt.Printf("result2 is : %s\n", string(bs2))
  fmt.Printf("%v\n\n", bytes.Compare(bs2, bs) == 0)
  assert.Nil(s.T(), err, "Test Failed")
  //.cssg-snippet-body-end
}

func (s *CosTestSuite) getPresignUploadUrl() {
  client := s.Client
  //.cssg-snippet-body-start:[get-presign-upload-url]
  ak := os.Getenv("COS_KEY")
  sk := os.Getenv("COS_SECRET")
  u, _ := url.Parse("http://bucket-cssg-test-go-1253653367.cos.ap-guangzhou.myqcloud.com")
  b := &cos.BaseURL{BucketURL: u}
  c := cos.NewClient(b, &http.Client{
     Transport: &cos.AuthorizationTransport{
        SecretID:  ak,
        SecretKey: sk,
     },
  })
  
  name := "test/objectPut.go"
  ctx := context.Background()
  // NewReader create file content
  f := strings.NewReader("test")
  
  // 1.Normal add auth header way to put object
  _, err := c.Object.Put(ctx, name, f, nil)
  if err != nil {
      panic(err)
  }
  // Get presigned
  presignedURL, err := c.Object.GetPresignedURL(ctx, http.MethodPut, name, ak, sk, time.Hour, nil)
  if err != nil {
      panic(err)
  }
  // 2.Put object content by presinged url
  data := "test upload with presignedURL"
  f = strings.NewReader(data)
  req, err := http.NewRequest(http.MethodPut, presignedURL.String(), f)
  if err != nil {
      panic(err)
  }
  // Can set request header.
  req.Header.Set("Content-Type", "text/html")
  _, err = http.DefaultClient.Do(req)
  if err != nil {
      panic(err)
  }
  assert.Nil(s.T(), err, "Test Failed")
  //.cssg-snippet-body-end
}

func (s *CosTestSuite) deleteMultiObject() {
  client := s.Client
  //.cssg-snippet-body-start:[delete-multi-object]
  var objects []string
  objects = append(objects, []string{"a", "b", "c"}...)
  obs := []cos.Object{}
  for _, v := range objects {
      obs = append(obs, cos.Object{Key: v})
  }
  opt := &cos.ObjectDeleteMultiOptions{
      Objects: obs,
      // 布尔值，这个值决定了是否启动 Quiet 模式
      // 值为 true 启动 Quiet 模式，值为 false 则启动 Verbose 模式，默认值为 false
      // Quiet: true,
  }                                       
  
  v, _, err := c.Object.DeleteMulti(context.Background(), opt)
  assert.Nil(s.T(), err, "Test Failed")
  //.cssg-snippet-body-end
}

func (s *CosTestSuite) restoreObject() {
  client := s.Client
  //.cssg-snippet-body-start:[restore-object]
  opt := &cos.ObjectRestoreOptions{
      Days: 2,
      Tier: &cos.CASJobParameters{
              // Standard, Exepdited and Bulk
              Tier: "Expedited",
      },
  }
  key := "archivetest"
  resp, err := c.Object.PostRestore(context.Background(), key, opt)
  //.cssg-snippet-body-end
}

func (s *CosTestSuite) initMultiUpload() {
  client := s.Client
  //.cssg-snippet-body-start:[init-multi-upload]
  name := "test_multipart"
  // 可选opt,如果不是必要操作，建议上传文件时不要给单个文件设置权限，避免达到限制。若不设置默认继承桶的权限。
  v, resp, err := client.Object.InitiateMultipartUpload(context.Background(), name, nil)
  assert.Nil(s.T(), err, "Test Failed")
  //.cssg-snippet-body-end
}

func (s *CosTestSuite) listMultiUpload() {
  client := s.Client
  //.cssg-snippet-body-start:[list-multi-upload]
  v, resp, err := c.Bucket.ListMultipartUploads(context.Background(), opt)
  assert.Nil(s.T(), err, "Test Failed")
  //.cssg-snippet-body-end
}

func (s *CosTestSuite) uploadPart() {
  client := s.Client
  //.cssg-snippet-body-start:[upload-part]
  // 注意，上传分块的块数最多10000块
  key := "test/test_multi_upload.go"
  f := strings.NewReader("test heoo")
  // opt可选
  _, err := client.Object.UploadPart(
      context.Background(), key, uploadID, 1, f, nil,
  )
  assert.Nil(s.T(), err, "Test Failed")
  //.cssg-snippet-body-end
}

func (s *CosTestSuite) listParts() {
  client := s.Client
  //.cssg-snippet-body-start:[list-parts]
  key := "test/test_list_parts.go"
  v, resp, err := client.Object.ListParts(context.Background(), key, uploadID, nil) 
  assert.Nil(s.T(), err, "Test Failed")
  //.cssg-snippet-body-end
}

func (s *CosTestSuite) completeMultiUpload() {
  client := s.Client
  //.cssg-snippet-body-start:[complete-multi-upload]
  // 封装 UploadPart 接口返回 etag 信息
  func uploadPart(c *cos.Client, name string, uploadID string, blockSize, n int) string {
      b := make([]byte, blockSize)
      if _, err := rand.Read(b); err != nil {
          panic(err)
      }
      s := fmt.Sprintf("%X", b)
      f := strings.NewReader(s)
  
      // 当传入参数 f 不是 bytes.Buffer/bytes.Reader/strings.Reader 时，必须指定 opt.ContentLength
      // opt := &cos.ObjectUploadPartOptions{
      //     ContentLength: size,
      // }
  
      resp, err := c.Object.UploadPart(
          context.Background(), name, uploadID, n, f, nil,
      )
      if err != nil {
          panic(err)
      }
      return resp.Header.Get("Etag")
  }
  
  // Init, UploadPart and Complete process
  key := "test/test_complete_upload.go"
  v, resp, err := client.Object.InitiateMultipartUpload(context.Background(), key, nil)
  uploadID := v.UploadID
  blockSize := 1024 * 1024 * 3
  
  opt := &cos.CompleteMultipartUploadOptions{}
  for i := 1; i < 5; i++ {
      // 调用上面封装的接口获取 etag 信息
      etag := uploadPart(c, key, uploadID, blockSize, i)
      opt.Parts = append(opt.Parts, cos.Object{
          PartNumber: i, ETag: etag},
      )
  }
  
  v, resp, err = client.Object.CompleteMultipartUpload(
      context.Background(), key, uploadID, opt,
  )
  assert.Nil(s.T(), err, "Test Failed")
  //.cssg-snippet-body-end
}

func (s *CosTestSuite) abortMultiUpload() {
  client := s.Client
  //.cssg-snippet-body-start:[abort-multi-upload]
  key := "test_multipart.txt"
  v, _, err := client.Object.InitiateMultipartUpload(context.Background(), key, nil)
  // Abort
  resp, err := client.Object.AbortMultipartUpload(context.Background(), key, v.UploadID)
  assert.Nil(s.T(), err, "Test Failed")
  //.cssg-snippet-body-end
}

func (s *CosTestSuite) transferUploadObject() {
  client := s.Client
  //.cssg-snippet-body-start:[transfer-upload-object]
  key := "object4go"
  file := "./test1G"
  
  v, resp, err := c.Object.Upload(
      context.Background(), key, file, nil,
  )   
  assert.Nil(s.T(), err, "Test Failed")
  //.cssg-snippet-body-end
}

func (s *CosTestSuite) copyObject() {
  client := s.Client
  //.cssg-snippet-body-start:[copy-object]
  u, _ := url.Parse("http://bucket-cssg-test-go-12536533670.cos.ap-guangzhou.myqcloud.com")
  source := "test/objectMove_src"
  soruceURL := fmt.Sprintf("%s/%s", u.Host, source)
  dest := "test/objectMove_dest"
  // 如果不是必要操作，建议上传文件时不要给单个文件设置权限，避免达到限制。若不设置默认继承桶的权限。
  // opt := &cos.ObjectCopyOptions{}
  r, resp, err := client.Object.Copy(context.Background(), dest, soruceURL, nil)
  assert.Nil(s.T(), err, "Test Failed")
  //.cssg-snippet-body-end
}


func (s *CosTestSuite) TestObjectMetadata() {
  s.putObject()
  s.putObjectAcl()
  s.getObjectAcl()
  s.headObject()
  s.getObject()
  s.getPresignDownloadUrl()
  s.getPresignUploadUrl()
  s.deleteObject()
  s.deleteMultiObject()
  s.restoreObject()
}
func (s *CosTestSuite) TestObjectMultiUpload() {
  s.initMultiUpload()
  s.listMultiUpload()
  s.uploadPart()
  s.listParts()
  s.completeMultiUpload()
}
func (s *CosTestSuite) TestObjectAbortMultiUpload() {
  s.initMultiUpload()
  s.uploadPart()
  s.abortMultiUpload()
}
func (s *CosTestSuite) TestObjectTransfer() {
  s.transferUploadObject()
}
func (s *CosTestSuite) TestObjectCopy() {
  s.copyObject()
  s.initMultiUpload()
  s.completeMultiUpload()
}

func TestCosTestSuite(t *testing.T) {
	suite.Run(t, new(CosTestSuite))
}
