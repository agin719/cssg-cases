//.cssg-snippet-body-start:[get-service-comp]
package main

import (
	"context"
	"fmt"
	"net/http"
	"os"

	"github.com/tencentyun/cos-go-sdk-v5"
)

func main() {
	c := cos.NewClient(nil, &http.Client{
		Transport: &cos.AuthorizationTransport{
			SecretID:  os.Getenv("COS_KEY"),
			SecretKey: os.Getenv("COS_SECRET"),
		},
	})

	s, _, err := c.Service.Get(context.Background())
	if err != nil {
		panic(err)
	}

	for _, b := range s.Buckets {
		fmt.Printf("%#v\n", b)
	}
}

//.cssg-snippet-body-end
