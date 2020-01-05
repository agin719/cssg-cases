//.cssg-snippet-body-start:[get-object-comp]
package main

import (
	"context"
	"fmt"
	"io/ioutil"
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
	// 1.Get object content by resp body.
	name := "test/objectPut.go"
	resp, err := c.Object.Get(context.Background(), name, nil)
	if err != nil {
		panic(err)
	}
	bs, _ := ioutil.ReadAll(resp.Body)
	resp.Body.Close()
	fmt.Printf("%s\n", string(bs))
	// 2.Get object to local file path.
	_, err = c.Object.GetToFile(context.Background(), name, "example", nil)
	if err != nil {
		panic(err)
	}
}

//.cssg-snippet-body-end
