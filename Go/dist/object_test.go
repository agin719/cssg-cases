package cos

import (
	"bytes"
	"context"
	"fmt"
	"github.com/stretchr/testify/assert"
	"github.com/tencentyun/cos-go-sdk-v5"
	"io/ioutil"
	"math/rand"
	"net/http"
	"os"
	"strings"
	"time"
)

func (s *CosTestSuite) deleteObject() {
	client := s.Client
	//.cssg-snippet-body-start:[delete-object]
	key := "example"
	_, err := client.Object.Delete(context.Background(), key)
	assert.Nil(s.T(), err, "Test Failed")
	//.cssg-snippet-body-end
}

func (s *CosTestSuite) putObject() {
	client := s.Client
	//.cssg-snippet-body-start:[put-object]
	key := "example"
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
	_, err = client.Object.Put(context.Background(), key, f, opt)
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
	key := "example"
	_, err := client.Object.PutACL(context.Background(), key, opt)
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

	_, err = client.Object.PutACL(context.Background(), key, opt)
	assert.Nil(s.T(), err, "Test Failed")
	//.cssg-snippet-body-end
}

func (s *CosTestSuite) getObjectAcl() {
	client := s.Client
	//.cssg-snippet-body-start:[get-object-acl]
	key := "example"
	_, _, err := client.Object.GetACL(context.Background(), key)
	assert.Nil(s.T(), err, "Test Failed")
	//.cssg-snippet-body-end
}

func (s *CosTestSuite) headObject() {
	client := s.Client
	//.cssg-snippet-body-start:[head-object]
	key := "example"
	_, err := client.Object.Head(context.Background(), key, nil)
	assert.Nil(s.T(), err, "Test Failed")
	//.cssg-snippet-body-end
}

func (s *CosTestSuite) getObject() {
	client := s.Client
	//.cssg-snippet-body-start:[get-object]
	key := "example"
	opt := &cos.ObjectGetOptions{
		ResponseContentType: "text/html",
		Range:               "bytes=0-3",
	}
	// opt 可选，无特殊设置可设为 nil
	// 1. Get object by resp body.
	resp, err := client.Object.Get(context.Background(), key, opt)
	ioutil.ReadAll(resp.Body)
	resp.Body.Close()

	// 2.Get object to local file.
	_, err = client.Object.GetToFile(context.Background(), key, "example.txt", nil)
	assert.Nil(s.T(), err, "Test Failed")
	//.cssg-snippet-body-end
}

func (s *CosTestSuite) getPresignDownloadUrl() {
	client := s.Client
	//.cssg-snippet-body-start:[get-presign-download-url]
	ak := os.Getenv("COS_KEY")
	sk := os.Getenv("COS_SECRET")
	name := "example"
	ctx := context.Background()
	// 1.Normal add auth header way to get object
	resp, err := client.Object.Get(ctx, name, nil)
	if err != nil {
		panic(err)
	}
	bs, _ := ioutil.ReadAll(resp.Body)
	resp.Body.Close()
	// Get presigned
	presignedURL, err := client.Object.GetPresignedURL(ctx, http.MethodGet, name, ak, sk, time.Hour, nil)
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
	assert.Nil(s.T(), err, "Test Failed")
	assert.Equal(s.T(), bytes.Compare(bs2, bs), 0, "Test Failed")
	//.cssg-snippet-body-end
}

func (s *CosTestSuite) getPresignUploadUrl() {
	client := s.Client
	//.cssg-snippet-body-start:[get-presign-upload-url]
	ak := os.Getenv("COS_KEY")
	sk := os.Getenv("COS_SECRET")

	name := "example"
	ctx := context.Background()
	// NewReader create file content
	f := strings.NewReader("test")

	// 1.Normal add auth header way to put object
	_, err := client.Object.Put(ctx, name, f, nil)
	if err != nil {
		panic(err)
	}
	// Get presigned
	presignedURL, err := client.Object.GetPresignedURL(ctx, http.MethodPut, name, ak, sk, time.Hour, nil)
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

	_, _, err := client.Object.DeleteMulti(context.Background(), opt)
	assert.Nil(s.T(), err, "Test Failed")
	//.cssg-snippet-body-end
}

func (s *CosTestSuite) restoreObject() {
	client := s.Client
	//.cssg-snippet-body-start:[restore-object]
	key := "example_restore"
	f, err := os.Open("./test")
	opt := &cos.ObjectPutOptions{
		ObjectPutHeaderOptions: &cos.ObjectPutHeaderOptions{
			ContentType:      "text/html",
			XCosStorageClass: "ARCHIVE",
		},
		ACLHeaderOptions: &cos.ACLHeaderOptions{
			// 如果不是必要操作，建议上传文件时不要给单个文件设置权限，避免达到限制。若不设置默认继承桶的权限。
			XCosACL: "private",
		},
	}
	_, err = client.Object.Put(context.Background(), key, f, opt)
	assert.Nil(s.T(), err, "Test Failed")

	opts := &cos.ObjectRestoreOptions{
		Days: 2,
		Tier: &cos.CASJobParameters{
			// Standard, Exepdited and Bulk
			Tier: "Expedited",
		},
	}
	_, err = client.Object.PostRestore(context.Background(), key, opts)
	assert.Nil(s.T(), err, "Test Failed")

	//.cssg-snippet-body-end
	_, err = client.Object.Delete(context.Background(), key)
	assert.Nil(s.T(), err, "Test Failed")
}

func (s *CosTestSuite) initMultiUpload() string {
	client := s.Client
	//.cssg-snippet-body-start:[init-multi-upload]
	name := "example_multipart"
	// 可选opt,如果不是必要操作，建议上传文件时不要给单个文件设置权限，避免达到限制。若不设置默认继承桶的权限。
	v, _, err := client.Object.InitiateMultipartUpload(context.Background(), name, nil)
	assert.Nil(s.T(), err, "Test Failed")
	//.cssg-snippet-body-end
	return v.UploadID
}

func (s *CosTestSuite) listMultiUpload() {
	client := s.Client
	//.cssg-snippet-body-start:[list-multi-upload]
	_, _, err := client.Bucket.ListMultipartUploads(context.Background(), nil)
	assert.Nil(s.T(), err, "Test Failed")
	//.cssg-snippet-body-end
}

func (s *CosTestSuite) uploadPart(uploadID string) {
	client := s.Client
	//.cssg-snippet-body-start:[upload-part]
	// 注意，上传分块的块数最多10000块
	key := "example_multipart"
	f := strings.NewReader("test hello")
	// opt可选
	_, err := client.Object.UploadPart(
		context.Background(), key, uploadID, 1, f, nil,
	)
	assert.Nil(s.T(), err, "Test Failed")
	//.cssg-snippet-body-end
}

func (s *CosTestSuite) listParts(uploadID string) {
	client := s.Client
	//.cssg-snippet-body-start:[list-parts]
	key := "example_multipart"
	_, _, err := client.Object.ListParts(context.Background(), key, uploadID, nil)
	assert.Nil(s.T(), err, "Test Failed")
	//.cssg-snippet-body-end
}

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

func (s *CosTestSuite) completeMultiUpload() {
	client := s.Client
	//.cssg-snippet-body-start:[complete-multi-upload]
	// 封装 UploadPart 接口返回 etag 信息

	// Init, UploadPart and Complete process
	key := "example_multipart"
	v, _, err := client.Object.InitiateMultipartUpload(context.Background(), key, nil)
	uploadID := v.UploadID
	blockSize := 1024 * 1024 * 3

	opt := &cos.CompleteMultipartUploadOptions{}
	for i := 1; i < 5; i++ {
		// 调用上面封装的接口获取 etag 信息
		etag := uploadPart(client, key, uploadID, blockSize, i)
		opt.Parts = append(opt.Parts, cos.Object{
			PartNumber: i, ETag: etag},
		)
	}

	_, _, err = client.Object.CompleteMultipartUpload(
		context.Background(), key, uploadID, opt,
	)
	assert.Nil(s.T(), err, "Test Failed")
	//.cssg-snippet-body-end
	_, err = client.Object.Delete(context.Background(), key)
	assert.Nil(s.T(), err, "Test Failed")
}

func (s *CosTestSuite) abortMultiUpload(uploadID string) {
	client := s.Client
	//.cssg-snippet-body-start:[abort-multi-upload]
	key := "example_multipart"
	// Abort
	_, err := client.Object.AbortMultipartUpload(context.Background(), key, uploadID)
	assert.Nil(s.T(), err, "Test Failed")
	//.cssg-snippet-body-end
}

func (s *CosTestSuite) transferUploadObject() {
	client := s.Client
	//.cssg-snippet-body-start:[transfer-upload-object]
	key := "example"
	file := "./test"

	_, _, err := client.Object.Upload(
		context.Background(), key, file, nil,
	)
	assert.Nil(s.T(), err, "Test Failed")
	//.cssg-snippet-body-end
	_, err = client.Object.Delete(context.Background(), key)
	assert.Nil(s.T(), err, "Test Failed")
}

func (s *CosTestSuite) copyObject() {
	client := s.Client
	//.cssg-snippet-body-start:[copy-object]
	name := "example"
	// 1.Normal put string content
	f := strings.NewReader("test")
	_, err := client.Object.Put(context.Background(), name, f, nil)
	assert.Nil(s.T(), err, "Test Failed")

	soruceURL := fmt.Sprintf("%s/%s", client.BaseURL.BucketURL.Host, name)
	dest := "example_dest"
	// 如果不是必要操作，建议上传文件时不要给单个文件设置权限，避免达到限制。若不设置默认继承桶的权限。
	// opt := &cos.ObjectCopyOptions{}
	_, _, err = client.Object.Copy(context.Background(), dest, soruceURL, nil)
	assert.Nil(s.T(), err, "Test Failed")
	//.cssg-snippet-body-end

	_, err = client.Object.Delete(context.Background(), name)
	assert.Nil(s.T(), err, "Test Failed")
	_, err = client.Object.Delete(context.Background(), dest)
	assert.Nil(s.T(), err, "Test Failed")
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
	uploadID := s.initMultiUpload()
	s.listMultiUpload()
	s.uploadPart(uploadID)
	s.listParts(uploadID)
	s.abortMultiUpload(uploadID)
	s.completeMultiUpload()
}
func (s *CosTestSuite) TestObjectAbortMultiUpload() {
	uploadID := s.initMultiUpload()
	s.uploadPart(uploadID)
	s.abortMultiUpload(uploadID)
}
func (s *CosTestSuite) TestObjectTransfer() {
	s.transferUploadObject()
}
func (s *CosTestSuite) TestObjectCopy() {
	s.copyObject()
}
