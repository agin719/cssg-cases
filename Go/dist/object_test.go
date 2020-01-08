package cos

import (
	"bytes"
	"context"
	"errors"
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
	if err != nil {
		panic(err)
	}
	//.cssg-snippet-body-end
	assert.Nil(s.T(), err, "Test Failed")
}

var (
	UploadID string
	PartETag string
)

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
	if err != nil {
		panic(err)
	}
	//.cssg-snippet-body-end
	assert.Nil(s.T(), err, "Test Failed")
}

func (s *CosTestSuite) putObjectAcl() {
	client := s.Client
	//.cssg-snippet-body-start:[put-object-acl]
	// 1.通过请求头设置
	opt := &cos.ObjectPutACLOptions{
		Header: &cos.ACLHeaderOptions{
			XCosACL: "private",
		},
	}
	key := "example"
	_, err := client.Object.PutACL(context.Background(), key, opt)
	if err != nil {
		panic(err)
	}
	// 2.通过请求体设置
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
	if err != nil {
		panic(err)
	}
	//.cssg-snippet-body-end
	assert.Nil(s.T(), err, "Test Failed")
}

func (s *CosTestSuite) getObjectAcl() {
	client := s.Client
	//.cssg-snippet-body-start:[get-object-acl]
	key := "example"
	_, _, err := client.Object.GetACL(context.Background(), key)
	if err != nil {
		panic(err)
	}
	//.cssg-snippet-body-end
	assert.Nil(s.T(), err, "Test Failed")
}

func (s *CosTestSuite) headObject() {
	client := s.Client
	//.cssg-snippet-body-start:[head-object]
	key := "example"
	_, err := client.Object.Head(context.Background(), key, nil)
	if err != nil {
		panic(err)
	}
	//.cssg-snippet-body-end
	assert.Nil(s.T(), err, "Test Failed")
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
	// 1. 从响应体中获取对象
	resp, err := client.Object.Get(context.Background(), key, opt)
	if err != nil {
		panic(err)
	}
	ioutil.ReadAll(resp.Body)
	resp.Body.Close()

	// 2. 下载对象到本地文件
	_, err = client.Object.GetToFile(context.Background(), key, "example.txt", nil)
	if err != nil {
		panic(err)
	}
	//.cssg-snippet-body-end
	assert.Nil(s.T(), err, "Test Failed")
}

func (s *CosTestSuite) getPresignDownloadUrl() {
	client := s.Client
	//.cssg-snippet-body-start:[get-presign-download-url]
	ak := os.Getenv("COS_KEY")
	sk := os.Getenv("COS_SECRET")
	name := "example"
	ctx := context.Background()
	// 1. 通过普通方式下载对象
	resp, err := client.Object.Get(ctx, name, nil)
	if err != nil {
		panic(err)
	}
	bs, _ := ioutil.ReadAll(resp.Body)
	resp.Body.Close()
	// 获取预签名URL
	presignedURL, err := client.Object.GetPresignedURL(ctx, http.MethodGet, name, ak, sk, time.Hour, nil)
	if err != nil {
		panic(err)
	}
	// 2. 通过预签名URL下载对象
	resp2, err := http.Get(presignedURL.String())
	if err != nil {
		panic(err)
	}
	bs2, _ := ioutil.ReadAll(resp2.Body)
	resp2.Body.Close()
	if bytes.Compare(bs2, bs) != 0 {
		panic(errors.New("content is not consistent"))
	}
	//.cssg-snippet-body-end
	assert.Nil(s.T(), err, "Test Failed")
	assert.Equal(s.T(), bytes.Compare(bs2, bs), 0, "Test Failed")
}

func (s *CosTestSuite) getPresignUploadUrl() {
	client := s.Client
	//.cssg-snippet-body-start:[get-presign-upload-url]
	ak := os.Getenv("COS_KEY")
	sk := os.Getenv("COS_SECRET")

	name := "example"
	ctx := context.Background()
	f := strings.NewReader("test")

	// 1. 通过普通方式上传对象
	_, err := client.Object.Put(ctx, name, f, nil)
	if err != nil {
		panic(err)
	}
	// 获取预签名URL
	presignedURL, err := client.Object.GetPresignedURL(ctx, http.MethodPut, name, ak, sk, time.Hour, nil)
	if err != nil {
		panic(err)
	}
	// 2. 通过预签名方式上传对象
	data := "test upload with presignedURL"
	f = strings.NewReader(data)
	req, err := http.NewRequest(http.MethodPut, presignedURL.String(), f)
	if err != nil {
		panic(err)
	}
	// 用户可自行设置请求头部
	req.Header.Set("Content-Type", "text/html")
	_, err = http.DefaultClient.Do(req)
	if err != nil {
		panic(err)
	}
	//.cssg-snippet-body-end
	assert.Nil(s.T(), err, "Test Failed")
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
	if err != nil {
		panic(err)
	}
	//.cssg-snippet-body-end
	assert.Nil(s.T(), err, "Test Failed")
}

func (s *CosTestSuite) restoreObject() {
	client := s.Client
	//.cssg-snippet-body-start:[restore-object]
	key := "example_restore"
	f, err := os.Open("./test")
	if err != nil {
		panic(err)
	}
	opt := &cos.ObjectPutOptions{
		ObjectPutHeaderOptions: &cos.ObjectPutHeaderOptions{
			ContentType:      "text/html",
			XCosStorageClass: "ARCHIVE", //归档类型
		},
		ACLHeaderOptions: &cos.ACLHeaderOptions{
			// 如果不是必要操作，建议上传文件时不要给单个文件设置权限，避免达到限制。若不设置默认继承桶的权限。
			XCosACL: "private",
		},
	}
	// 归档直传
	_, err = client.Object.Put(context.Background(), key, f, opt)
	if err != nil {
		panic(err)
	}

	opts := &cos.ObjectRestoreOptions{
		Days: 2,
		Tier: &cos.CASJobParameters{
			// Standard, Exepdited and Bulk
			Tier: "Expedited",
		},
	}
	// 归档恢复
	_, err = client.Object.PostRestore(context.Background(), key, opts)
	if err != nil {
		panic(err)
	}
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
	if err != nil {
		panic(err)
	}
	//.cssg-snippet-body-end
	assert.Nil(s.T(), err, "Test Failed")
	UploadID = v.UploadID
	return v.UploadID
}

func (s *CosTestSuite) listMultiUpload() {
	client := s.Client
	//.cssg-snippet-body-start:[list-multi-upload]
	_, _, err := client.Bucket.ListMultipartUploads(context.Background(), nil)
	//.cssg-snippet-body-end
	assert.Nil(s.T(), err, "Test Failed")
}

func (s *CosTestSuite) uploadPart() {
	client := s.Client
	//.cssg-snippet-body-start:[upload-part]
	// 注意，上传分块的块数最多10000块
	key := "example_multipart"
	f := strings.NewReader("test hello")
	// opt可选
	resp, err := client.Object.UploadPart(
		context.Background(), key, UploadID, 1, f, nil,
	)
	if err != nil {
		panic(err)
	}
	//.cssg-snippet-body-end
	PartETag = resp.Header.Get("ETag")
	assert.Nil(s.T(), err, "Test Failed")
}

func (s *CosTestSuite) listParts() {
	client := s.Client
	//.cssg-snippet-body-start:[list-parts]
	key := "example_multipart"
	_, _, err := client.Object.ListParts(context.Background(), key, UploadID, nil)
	if err != nil {
		panic(err)
	}
	//.cssg-snippet-body-end
	assert.Nil(s.T(), err, "Test Failed")
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

	// 完成分块上传
	key := "example_multipart"
	uploadID := UploadID

	opt := &cos.CompleteMultipartUploadOptions{}
	opt.Parts = append(opt.Parts, cos.Object{
		PartNumber: 1, ETag: PartETag},
	)

	_, _, err := client.Object.CompleteMultipartUpload(
		context.Background(), key, uploadID, opt,
	)
	if err != nil {
		panic(err)
	}
	//.cssg-snippet-body-end
	_, err = client.Object.Delete(context.Background(), key)
	assert.Nil(s.T(), err, "Test Failed")
}

func (s *CosTestSuite) abortMultiUpload() {
	client := s.Client
	//.cssg-snippet-body-start:[abort-multi-upload]
	key := "example_multipart"
	// Abort
	_, err := client.Object.AbortMultipartUpload(context.Background(), key, UploadID)
	if err != nil {
		panic(err)
	}
	//.cssg-snippet-body-end
	assert.Nil(s.T(), err, "Test Failed")
}

func (s *CosTestSuite) transferUploadObject() {
	client := s.Client
	//.cssg-snippet-body-start:[transfer-upload-object]
	key := "example"
	file := "./test"

	_, _, err := client.Object.Upload(
		context.Background(), key, file, nil,
	)
	if err != nil {
		panic(err)
	}
	//.cssg-snippet-body-end
	_, err = client.Object.Delete(context.Background(), key)
	assert.Nil(s.T(), err, "Test Failed")
}

func (s *CosTestSuite) copyObject() {
	client := s.Client
	//.cssg-snippet-body-start:[copy-object]
	name := "example"
	// 上传源对象
	f := strings.NewReader("test")
	_, err := client.Object.Put(context.Background(), name, f, nil)
	assert.Nil(s.T(), err, "Test Failed")

	soruceURL := fmt.Sprintf("%s/%s", client.BaseURL.BucketURL.Host, name)
	dest := "example_dest"
	// 如果不是必要操作，建议上传文件时不要给单个文件设置权限，避免达到限制。若不设置默认继承桶的权限。
	// opt := &cos.ObjectCopyOptions{}
	_, _, err = client.Object.Copy(context.Background(), dest, soruceURL, nil)
	if err != nil {
		panic(err)
	}
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
}
