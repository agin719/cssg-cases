//.cssg-snippet-body-start:[put-object-comp]
package main

import (
	"context"
	"net/http"
	"net/url"
	"os"
	"strings"

	"github.com/tencentyun/cos-go-sdk-v5"
)

func main() {
	// 将 bucket-cssg-test-go-1253653367 和 ap-guangzhou 修改为真实的信息
	u, _ := url.Parse("http://bucket-cssg-test-go-1253653367.cos.ap-guangzhou.myqcloud.com")
	b := &cos.BaseURL{BucketURL: u}
	c := cos.NewClient(b, &http.Client{
		Transport: &cos.AuthorizationTransport{
			SecretID:  os.Getenv("COS_KEY"),
			SecretKey: os.Getenv("COS_SECRET"),
		},
	})
	// 对象键（Key）是对象在存储桶中的唯一标识。
	// 例如，在对象的访问域名 `bucket-cssg-test-go-1253653367.cos.ap-guangzhou.myqcloud.com/test/objectPut.go` 中，对象键为 test/objectPut.go
	name := "test/objectPut.go"
	// 1.Normal put string content
	f := strings.NewReader("test")

	_, err := c.Object.Put(context.Background(), name, f, nil)
	if err != nil {
		panic(err)
	}
	// 2.Put object by local file path
	_, err = c.Object.PutFromFile(context.Background(), name, "./test", nil)
	if err != nil {
		panic(err)
	}
}

//.cssg-snippet-body-end
