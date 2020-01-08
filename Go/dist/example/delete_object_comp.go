//.cssg-snippet-body-start:[delete-object-comp]
package main

import (
	"context"
	"net/http"
	"net/url"
	"os"

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
	name := "test/objectPut.go"
	_, err := c.Object.Delete(context.Background(), name)
	if err != nil {
		panic(err)
	}
}

//.cssg-snippet-body-end